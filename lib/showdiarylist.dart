import 'package:flutter/material.dart';
import 'homepage.dart';
import 'dart:math';

final List diaryList = [
  {
    'image': 'assets/images/coverImages/0.png',
    'title': 'My Diary 1',
    'password': 'qwer'
  },
  {
    'image': 'assets/images/coverImages/1.png',
    'title': 'Mydiary 2',
    'password': null
  },
  {
    'image': 'assets/images/coverImages/2.png',
    'title': 'MY_Diary3',
    'password': 'qwer'
  },
  {
    'image': 'assets/images/coverImages/3.png',
    'title': 'my diary 4',
    'password': null
  },
  {
    'image': 'assets/images/coverImages/4.png',
    'title': 'My-Diary5',
    'password': null
  },
  {
    'image': 'assets/images/coverImages/5.png',
    'title': 'myDiary6',
    'password': null
  },
  {
    'image': 'assets/images/coverImages/6.png',
    'title': 'myDiary7',
    'password': null
  },
  {
    'image': 'assets/images/coverImages/7.png',
    'title': 'myDiary8',
    'password': null
  },
  {
    'image': 'assets/images/coverImages/8.png',
    'title': 'myDiary9',
    'password': null
  },
  {
    'image': 'assets/images/coverImages/9.png',
    'title': 'myDiary10',
    'password': null
  },
  {
    'image': 'assets/images/coverImages/10.png',
    'title': 'myDiary11',
    'password': null
  },
  {
    'image': 'assets/images/coverImages/11.png',
    'title': 'myDiary12',
    'password': null
  },
  {
    'image': 'assets/images/coverImages/12.png',
    'title': 'myDiary13',
    'password': null
  },
  {
    'image': 'assets/images/coverImages/13.png',
    'title': 'myDiary14',
    'password': null
  },
  {
    'image': 'assets/images/coverImages/14.png',
    'title': 'myDiary15',
    'password': null
  },
  {
    'image': 'assets/images/coverImages/15.png',
    'title': 'myDiary16',
    'password': null
  },
];

class ShowDiaryList extends StatelessWidget {
  const ShowDiaryList({super.key});
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
                  const Expanded(flex: 1, child: SizedBox()),
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
    return DragTarget(
      builder: (context, candidateData, rejectedData) {
        return Container(
            child: GridView.builder(
          itemCount: diaryList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 3 / 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10),
          itemBuilder: (context, index) => Container(
            child: DiaryGridItem(listIndex: index),
          ),
        ));
      },
      onWillAccept: (data) {
        return true;
      },
      onAccept: (data) {},
    );
  }
}

class DiaryGridItem extends StatefulWidget {
  final int listIndex;
  DiaryGridItem({super.key, required this.listIndex});
  @override
  State<DiaryGridItem> createState() => _DiaryGridItemState();
}

class _DiaryGridItemState extends State<DiaryGridItem> {
  int _maxSimultaneousDrags = 1;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Draggable(
          data: widget.listIndex,
          maxSimultaneousDrags: _maxSimultaneousDrags,
          child: Material(
              child: InkWell(
            child: diaryCover(context, widget.listIndex),
            onLongPress: () {
              setState(() {
                _maxSimultaneousDrags = 1;
              });
            },
          )),
          feedback: Material(
              child: InkWell(
            child: diaryCover(context, widget.listIndex),
            onLongPress: () {
              setState(() {
                _maxSimultaneousDrags = 1;
              });
            },
          )),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: Text(
              diaryList.elementAt(widget.listIndex)['title'],
              softWrap: false,
              overflow: TextOverflow.clip,
            )),
            diaryMenuButton(20)
          ],
        )
      ],
    );
  }
}

Widget diaryCover(context, int index) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.21,
    height: MediaQuery.of(context).size.width * 0.28,
    alignment: Alignment.center,
    decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(diaryList.elementAt(index)['image'] ??
                'assets/images/coverImages/default.png'))),
  );
}
