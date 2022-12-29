import 'package:diory_project/diary_showlist.dart';
import 'package:diory_project/edit_page.dart';
import 'package:diory_project/selectTemplate.dart';
import 'package:diory_project/store.dart';
import 'package:flutter/material.dart';

import 'store.dart';

class DiaryReadingView extends StatelessWidget {
  const DiaryReadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return DiaryPageView();
  }
}

class DiaryPageView extends StatefulWidget {
  const DiaryPageView({super.key});
  @override
  State<DiaryPageView> createState() => _DiaryPageViewState();
}

class _DiaryPageViewState extends State<DiaryPageView> {
  int? _currentPageIndex;
  List _pageList = [];
  @override
  Widget build(BuildContext context) {
    _pageList = Store.currentDiaryInfo['pages'];
    print('페이지 길이${_pageList.length}');
    print(_pageList);

    _currentPageIndex = _currentPageIndex ?? _pageList.length - 1;
    PageController _pageController =
        PageController(initialPage: _currentPageIndex!);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Row(children: [
            Expanded(
                child: Text(
              '${Store.currentDiaryInfo['title']}\t\t',
              overflow: TextOverflow.fade,
            )),
            Visibility(
                visible: _currentPageIndex != -1,
                child: Row(
                  children: [
                    SizedBox(
                        width: 30,
                        height: 30,
                        child: TextField(
                          controller: TextEditingController(
                              text: '${_currentPageIndex}'),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.go,
                          onSubmitted: (value) {
                            int toPageIndex = -1;
                            setState(() {
                              try {
                                toPageIndex = int.parse(value);
                              } catch (FormatException) {
                                return;
                              }
                              if (toPageIndex < 0 ||
                                  toPageIndex > _pageList.length - 1) {
                              } else {
                                setState(() {
                                  _currentPageIndex = int.parse(value);
                                  _pageController.animateToPage(
                                      _currentPageIndex!,
                                      duration:
                                          const Duration(microseconds: 500),
                                      curve: Curves.easeIn);
                                });
                              }
                            });
                          },
                        )),
                    const Text('page\t'),
                  ],
                )),
            Visibility(
                visible: _currentPageIndex != -1,
                child: IconButton(
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Store.drawPage(Store.currentDiaryInfo,
                          (_currentPageIndex! > 0) ? _currentPageIndex : 0);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyEditPage(
                                  diaryIndex: /*widget.diaryIndex*/ 0,
                                  pageIndex: _currentPageIndex!)));
                    },
                    icon: Icon(Icons.edit))),
          ]),
          actions: [
            IconButton(
                onPressed: () {
                  ItemController.stickerItems = [];
                  ItemController.textItems = [];
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SelectTemplatePage()));
                },
                icon: const Icon(Icons.add)),
            const SizedBox(width: 10)
          ],
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          //physics: const NeverScrollableScrollPhysics(),
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width * 2.0,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width * 1.5,
                    child: _pageList.isNotEmpty
                        ? PageView.builder(
                            controller: _pageController,
                            // itemCount: _pageList.length,
                            itemCount: ItemController.pages.length,
                            itemBuilder: (context, index) {
                              return Container(
                                color: Colors.blue,
                                width:
                                    MediaQuery.of(context).size.width * 0.60 +
                                        20,
                                height:
                                    MediaQuery.of(context).size.width * 0.80 +
                                        20,
                                child: ItemController.pages[index],
                              );
                            },
                            onPageChanged: (value) {
                              setState(() {
                                print('page changed to ${value}');
                                _currentPageIndex = value;
                              });
                            },
                          )
                        : Container(
                            alignment: Alignment.center,
                            child: Text('아직 작성한 페이지가 없습니다!'),
                          ),
                  ),
                  const SizedBox(height: 10.0),
                ],
              )),
        ));
  }
}
