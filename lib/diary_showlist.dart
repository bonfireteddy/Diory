import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diory_project/diary_setting.dart';
import 'package:diory_project/diary_readingview.dart';
import 'package:flutter/material.dart';
import 'homepage.dart';
import 'store.dart';

class DiaryShowList extends StatelessWidget {
  const DiaryShowList({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Hello, My Diory\t',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            )),
        leading: Builder(
            builder: (context) => IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )),
        actions: [
          Builder(
              builder: (context) => RawMaterialButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: const CircleBorder(),
                    child: AccountImageIcon(),
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer();
                    },
                  )),
        ],
      ),
      endDrawer: DrawerMenuBar(),
      body: Row(
        children: [
          const Expanded(flex: 1, child: SizedBox()),
          Expanded(
              flex: 12,
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      child: const Text(
                        'my diaries',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w300),
                      ),
                    ),
                  ),
                  const Expanded(flex: 12, child: ListGridView()),
                  Expanded(flex: 2, child: Container()),
                ],
              )),
          Expanded(flex: 1, child: Container()),
        ],
      ),
    );
  }
}

class ListGridView extends StatefulWidget {
  const ListGridView({super.key});
  @override
  State<ListGridView> createState() => _ListGridViewState();
}

class _ListGridViewState extends State<ListGridView> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Diarys')
            .orderBy('index')
            .snapshots(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            //return Text("...");
          }
          Iterable datas = snapshot.hasData
              ? snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  data['id'] = document.id;
                  return data;
                }).where(
                  (element) => element['userId'] == userInfo.currentUser!.uid)
              : Iterable.empty();

          return GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 3 / 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10),
            children: [
                  DragTarget(
                    builder: (context, candidateData, rejectedData) =>
                        Container(
                      child: DiaryGridItem(data: null),
                    ),
                  )
                ] +
                (snapshot.data != null
                    ? (datas
                        .map((data) {
                          return DragTarget(
                            builder: (context, candidateData, rejectedData) =>
                                Container(
                              child: DiaryGridItem(data: data),
                            ),
                            onWillAccept: (objectData) =>
                                jsonDecode(
                                    objectData.toString())['listIndex'] !=
                                -1,
                            onAccept: (objectData) {
                              int fromIndex = jsonDecode(
                                      objectData.toString())['listIndex'] ??
                                  -1;

                              int toIndex = data['index'];
                              if (toIndex == -1 || toIndex == fromIndex) return;
                              String fromId =
                                  jsonDecode(objectData.toString())['data']
                                      ['id'];
                              String toId = data['id'];
                              print(
                                  "from $fromIndex $fromId to $toIndex $toId");

                              FirebaseFirestore.instance
                                  .collection("Diarys")
                                  .doc(fromId)
                                  .update({'index': toIndex});
                              FirebaseFirestore.instance
                                  .collection("Diarys")
                                  .doc(toId)
                                  .update({'index': fromIndex});
                            },
                          );
                        })
                        .where((element) => element != null)
                        .toList())
                    : []),
          );
        });
  }
}

class DiaryGridItem extends StatefulWidget {
  Map<String, dynamic>? data;
  DiaryGridItem({super.key, required this.data});
  @override
  State<DiaryGridItem> createState() => _DiaryGridItemState();
}

class _DiaryGridItemState extends State<DiaryGridItem> {
  @override
  Widget build(BuildContext context) {
    int listIndex = widget.data != null ? widget.data!['index'] : -1;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        widget.data == null
            ? Material(
                child: InkWell(
                child: addDiaryButton(context),
              ))
            : Draggable(
                data: jsonEncode({'listIndex': listIndex, 'data': widget.data}),
                maxSimultaneousDrags: listIndex == -1 ? 0 : 1,
                child: Material(
                    child: InkWell(
                  child: diaryCover(context, widget.data),
                  onLongPress: () {
                    setState(() {
                      print(widget.data!['id']);
                      FirebaseFirestore.instance
                          .collection('Diarys')
                          .doc(widget.data!['id'])
                          .update({'bookmarked': !widget.data!['bookmarked']});
                      widget.data!['bookmarked'] = !widget.data!['bookmarked'];
                    });
                  },
                  onTap: () {
                    Store.currentDiaryId = widget.data!['id'];
                    passwordCheck(context, widget.data, DiaryReadingView());
                  },
                )),
                feedback: Material(
                    child: InkWell(
                  child: diaryCover(context, widget.data),
                )),
                childWhenDragging: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.21,
                  height: MediaQuery.of(context).size.width * 0.28,
                ),
              ),
        widget.data != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: Text(
                    widget.data!['title'] ?? 'tempTitle',
                    softWrap: false,
                    overflow: TextOverflow.clip,
                  )),
                  diaryMenuButton(context, widget.data, 20)
                ],
              )
            : const SizedBox(),
      ],
    );
  }
}

Widget addDiaryButton(context) {
  return Material(
      child: InkWell(
    child: Container(
      width: MediaQuery.of(context).size.width * 0.21,
      height: MediaQuery.of(context).size.width * 0.28,
      decoration: BoxDecoration(
        color: Color(0xffdfdada),
      ),
      child: const Icon(
        Icons.add_rounded,
        size: 50,
        color: Color(0x88000000),
      ),
    ),
    onTap: () {
      /*db.collection("TempDiarys").get().then((res) {
        print(res.docs);
        res.docs.forEach((element) {
          db.collection("Diarys").add(element.data());
        });
      });
    */

      Navigator.push(
          context, MaterialPageRoute(builder: ((context) => DiaryCreateNew())));
    },
  ));
}

Widget diaryCover(context, data) {
  final bool locked = data['password'] != '';
  final bool bookmarked = data['bookmarked'] ?? false;
  return Container(
      width: MediaQuery.of(context).size.width * 0.21,
      height: MediaQuery.of(context).size.width * 0.28,
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 5.0,
                spreadRadius: 0,
                offset: const Offset(0, 3))
          ],
          image: DecorationImage(image: NetworkImage('${data['cover']}')
              //image: AssetImage('assets/images/coverImages/default.png')
              )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.lock,
            color: locked ? Colors.black : const Color(0x00000000),
          ),
          Icon(
            bookmarked ? Icons.star_rate_rounded : Icons.star_border_rounded,
            color: bookmarked ? Colors.amber : const Color(0x00000000),
          ),
        ],
      ));
}
