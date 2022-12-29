import 'package:diory_project/diary_showlist.dart';
import 'package:diory_project/edit_page.dart';
import 'package:diory_project/selectTemplate.dart';
import 'package:flutter/material.dart';

class DiaryReadingView extends StatelessWidget {
  int diaryIndex;
  DiaryReadingView({super.key, required this.diaryIndex});

  @override
  Widget build(BuildContext context) {
    return DiaryPageView(diaryIndex: diaryIndex);
  }
}

class DiaryPageView extends StatefulWidget {
  int diaryIndex;
  DiaryPageView({super.key, required this.diaryIndex});
  @override
  State<DiaryPageView> createState() => _DiaryPageViewState();
}

class _DiaryPageViewState extends State<DiaryPageView> {
  int? _currentPageIndex;
  List _pageList = [];
  @override
  Widget build(BuildContext context) {
    _pageList = diaryList.elementAt(widget.diaryIndex)['pages'] ?? [];
    _currentPageIndex = _currentPageIndex ?? _pageList.length - 1;
    PageController _pageController =
        PageController(initialPage: _currentPageIndex!);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Row(children: [
            Text('${diaryList.elementAt(widget.diaryIndex)['title']}\t\t'),
            SizedBox(
                width: 30,
                height: 30,
                child: TextField(
                  controller:
                      TextEditingController(text: '${_currentPageIndex}'),
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
                          _pageController.animateToPage(_currentPageIndex!,
                              duration: const Duration(microseconds: 500),
                              curve: Curves.easeIn);
                        });
                      }
                    });
                  },
                )),
            const Text('page\t'),
            const Expanded(child: SizedBox()),
            Visibility(
                visible: _currentPageIndex != -1,
                child: IconButton(
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyEditPage(
                                  diaryIndex: widget.diaryIndex,
                                  pageIndex: _currentPageIndex!)));
                    },
                    icon: Icon(Icons.edit))),
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
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width * 1.5,
                    child: _pageList.isNotEmpty
                        ? PageView.builder(
                            controller: _pageController,
                            itemCount: _pageList.length,
                            itemBuilder: (context, index) {
                              return Container(
                                color: Colors.blue,
                                width:
                                    MediaQuery.of(context).size.width * 0.60 +
                                        20,
                                height:
                                    MediaQuery.of(context).size.width * 0.80 +
                                        20,
                                child: Text(
                                  '$index',
                                  style: TextStyle(fontSize: 100),
                                ),
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
