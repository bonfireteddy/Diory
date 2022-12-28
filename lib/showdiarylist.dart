import 'package:flutter/material.dart';
import 'homepage.dart';
import 'dart:math';

List diaryList = [
  {
    'image': 'assets/images/coverImages/0.png',
    'title': 'My Diary 1',
    'password': 'qwer',
    'bookmarked': true,
  },
  {
    'image': 'assets/images/coverImages/1.png',
    'title': 'Mydiary 2',
    'password': null,
    'bookmarked': false,
  },
  {
    'image': 'assets/images/coverImages/2.png',
    'title': 'MY_Diary3',
    'password': 'qwer',
    'bookmarked': true,
  },
  {
    'image': 'assets/images/coverImages/3.png',
    'title': 'my diary 4',
    'password': null,
    'bookmarked': false,
  },
  {
    'image': 'assets/images/coverImages/4.png',
    'title': 'My-Diary5',
    'password': null,
    'bookmarked': true,
  },
  {
    'image': 'assets/images/coverImages/5.png',
    'title': 'myDiary6',
    'password': null,
    'bookmarked': false,
  },
  {
    'image': 'assets/images/coverImages/6.png',
    'title': 'myDiary7',
    'password': null,
    'bookmarked': true,
  },
  {
    'image': 'assets/images/coverImages/7.png',
    'title': 'myDiary8',
    'password': null,
    'bookmarked': false,
  },
  {
    'image': 'assets/images/coverImages/8.png',
    'title': 'myDiary9',
    'password': null,
    'bookmarked': false,
  },
  {
    'image': 'assets/images/coverImages/9.png',
    'title': 'myDiary10',
    'password': null,
    'bookmarked': false,
  },
  {
    'image': 'assets/images/coverImages/10.png',
    'title': 'myDiary11',
    'password': null,
    'bookmarked': false,
  },
  {
    'image': 'assets/images/coverImages/11.png',
    'title': 'myDiary12',
    'password': null,
    'bookmarked': false,
  },
  {
    'image': 'assets/images/coverImages/12.png',
    'title': 'myDiary13',
    'password': null,
    'bookmarked': false,
  },
  {
    'image': 'assets/images/coverImages/13.png',
    'title': 'myDiary14',
    'password': null,
    'bookmarked': false,
  },
  {
    'image': 'assets/images/coverImages/14.png',
    'title': 'myDiary15',
    'password': null,
    'bookmarked': false,
  },
  {
    'image': 'assets/images/coverImages/15.png',
    'title': 'myDiary16',
    'password': null,
    'bookmarked': true,
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
    return Container(
        child: GridView.builder(
            itemCount: diaryList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 3 / 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10),
            itemBuilder: (context, index) => DragTarget(
                  builder: (context, candidateData, rejectedData) => Container(
                    child: DiaryGridItem(listIndex: index),
                  ),
                  onWillAccept: (data) => true,
                  onAccept: (data) {
                    int fromIndex = int.tryParse(data.toString()) ?? -1;
                    if (fromIndex == -1) return;
                    int largerIndex = index > fromIndex ? index : fromIndex;
                    int smallerIndex = index < fromIndex ? index : fromIndex;
                    setState(() {
                      diaryList.insert(
                          smallerIndex, diaryList.removeAt(largerIndex));
                      diaryList.insert(
                          largerIndex, diaryList.removeAt(smallerIndex + 1));
                    });
                  },
                )));
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
                diaryList.elementAt(widget.listIndex)['bookmarked'] =
                    !diaryList.elementAt(widget.listIndex)['bookmarked'];
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
          childWhenDragging: SizedBox(
            width: MediaQuery.of(context).size.width * 0.21,
            height: MediaQuery.of(context).size.width * 0.28,
          ),
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
  final bool bookmarked = diaryList.elementAt(index)['bookmarked'] ?? false;
  return Container(
    width: MediaQuery.of(context).size.width * 0.21,
    height: MediaQuery.of(context).size.width * 0.28,
    alignment: Alignment.bottomRight,
    padding: EdgeInsets.all(4),
    decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(diaryList.elementAt(index)['image'] ??
                'assets/images/coverImages/default.png'))),
    child: Icon(
      bookmarked ? Icons.star_rate_rounded : Icons.star_border_rounded,
      color: bookmarked ? Colors.amber : Color(0x00000000),
    ),
  );
}
