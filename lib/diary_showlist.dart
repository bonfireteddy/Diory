import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diory_project/diary_setting.dart';
import 'package:diory_project/diary_readingview.dart';
import 'package:diory_project/edit_page.dart';
import 'package:flutter/material.dart';
import 'homepage.dart';

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
            .collection('TempDiarys')
            .orderBy('index')
            .snapshots(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            //return Text("...");
          }
          return GridView(
/////////// IOS-ISSUE-2
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
                    ? (snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        data['id'] = document.id;
                        return DragTarget(
                          builder: (context, candidateData, rejectedData) =>
                              Container(
                            child: DiaryGridItem(data: data),
                          ),
                          onWillAccept: (objectData) =>
                              int.parse(objectData.toString()) != -1,
                          onAccept: (objectData) {
                            int fromIndex =
                                int.tryParse(objectData.toString()) ?? -1;
                            int toIndex = data['index'];
                            if (toIndex == -1 || toIndex == fromIndex) return;
                            int largerIndex =
                                toIndex > fromIndex ? toIndex : fromIndex;
                            int smallerIndex =
                                toIndex < fromIndex ? toIndex : fromIndex;
                            print("from $fromIndex to $toIndex");
                            setState(() {
                              /*diaryList.insert(smallerIndex,
                                  diaryList.removeAt(largerIndex));
                              diaryList.insert(largerIndex,
                                  diaryList.removeAt(smallerIndex + 1));*/
                            });
                          },
                        );
                      }).toList())
                    : []),
          );
        });
    /*return Container(
        child: GridView.builder(
            itemCount: diaryList.length + 1,

/////////// main
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 3 / 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10),
///////////IOS-ISSUE-2
            itemBuilder: (context, index) => DragTarget(
                  builder: (context, candidateData, rejectedData) => Container(
                    child: DiaryGridItem(listIndex: index - 1),
                  ),
                  onWillAccept: (data) => int.parse(data.toString()) != -1,
                  onAccept: (data) {
                    int fromIndex = int.tryParse(data.toString()) ?? -1;
                    int toIndex = index - 1;
                    if (toIndex == -1 || toIndex == fromIndex) return;
                    int largerIndex = toIndex > fromIndex ? toIndex : fromIndex;
                    int smallerIndex =
                        toIndex < fromIndex ? toIndex : fromIndex;
                    setState(() {
                      diaryList.insert(
                          smallerIndex, diaryList.removeAt(largerIndex));
                      diaryList.insert(
                          largerIndex, diaryList.removeAt(smallerIndex + 1));
                    });
                  },
                )));*/
=======
            children: [
                  DragTarget(
                    builder: (context, candidateData, rejectedData) =>
                        Container(
                      child: DiaryGridItem(data: null),
                    ),
                  )
                ] +
                (snapshot.data != null
                    ? (snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        data['id'] = document.id;
                        return DragTarget(
                          builder: (context, candidateData, rejectedData) =>
                              Container(
                            child: DiaryGridItem(data: data),
                          ),
                          onWillAccept: (objectData) =>
                              jsonDecode(objectData.toString())['listIndex'] !=
                              -1,
                          onAccept: (objectData) {
                            int fromIndex = jsonDecode(
                                    objectData.toString())['listIndex'] ??
                                -1;

                            int toIndex = data['index'];
                            if (toIndex == -1 || toIndex == fromIndex) return;
                            String fromId =
                                jsonDecode(objectData.toString())['data']['id'];
                            String toId = data['id'];
                            print("from $fromIndex $fromId to $toIndex $toId");

                            FirebaseFirestore.instance
                                .collection("TempDiarys")
                                .doc(fromId)
                                .update({'index': toIndex});
                            FirebaseFirestore.instance
                                .collection("TempDiarys")
                                .doc(toId)
                                .update({'index': fromIndex});
                            /*diaryList.insert(smallerIndex,
                                  diaryList.removeAt(largerIndex));
                              diaryList.insert(largerIndex,
                                  diaryList.removeAt(smallerIndex + 1));*/
                          },
                        );
                      }).toList())
                    : []),
          );
        });
// main
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
                      widget.data!['bookmarked'] = !widget.data!['bookmarked'];
                    });
                  },
                  onTap: () {
                    ItemController.stickerItems = [];
                    ItemController.textItems = [];
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
