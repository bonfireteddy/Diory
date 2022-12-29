import 'package:diory_project/diary_showlist.dart';
import 'package:diory_project/edit_page.dart';
import 'package:diory_project/selectTemplate.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class DiaryReadingView extends StatelessWidget {
  int index;
  DiaryReadingView({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Row(children: [
            Text('${diaryList.elementAt(index)['title']}\t\t'),
            SizedBox(
                width: 30,
                height: 30,
                child: TextField(keyboardType: TextInputType.number)),
            const Text('page\t'),
            const Expanded(child: SizedBox()),
            IconButton(
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyEditPage(
                                title: 'title',
                              )));
                },
                icon: Icon(Icons.edit)),
          ]),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SelectTemplatePage()));
                },
                icon: Icon(Icons.add)),
          ],
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          //physics: const NeverScrollableScrollPhysics(),
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width * 2.0,
              child: DiaryPageView(index: index)),
        ));
  }
}

class DiaryPageView extends StatefulWidget {
  int index;
  DiaryPageView({super.key, required this.index});
  @override
  State<DiaryPageView> createState() => _DiaryPageViewState();
}

class _DiaryPageViewState extends State<DiaryPageView> {
  int _currentPageIndex = 0;
  Map _pageList = {};
  PageController _pageController = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    _pageList = diaryList.elementAt(widget.index);
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width * 1.5,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _pageList.length,
            itemBuilder: (context, index) {
              return Container(
                width: MediaQuery.of(context).size.width * 0.60 + 20,
                height: MediaQuery.of(context).size.width * 0.80 + 20,
                color:
                    Colors.primaries[Random().nextInt(Colors.primaries.length)],
              );
            },
            onPageChanged: (value) {
              _currentPageIndex = value;
            },
          ),
        ),
        const SizedBox(height: 10.0),
      ],
    );
  }
}
