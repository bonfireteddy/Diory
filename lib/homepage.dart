import 'package:flutter/material.dart';
import 'dart:math';

import 'showdiarylist.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});
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
        leading: null,
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
              flex: 4,
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 2),
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.list),
                        iconSize: 32,
                        onPressed: (() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ShowDiaryList()));
                        }),
                      ),
                    ),
                  ),
                  const Expanded(flex: 8, child: HomeDiaryPageView()),
                ],
              )),
          const Expanded(flex: 1, child: SizedBox()),
        ],
      ),
    );
  }
}

class HomeDiaryPageView extends StatefulWidget {
  const HomeDiaryPageView({super.key});
  @override
  State<HomeDiaryPageView> createState() => _HomeDiaryPageViewState();
}

class _HomeDiaryPageViewState extends State<HomeDiaryPageView> {
  int _currentPageIndex = 0;
  PageController pageController = PageController(initialPage: 0);
  final List diaryList = [
    {'image': null, 'title': 'My Diary 1', 'password': 'qwer'},
    {'image': null, 'title': 'Mydiary 2', 'password': null},
    {'image': null, 'title': 'MY_Diary3', 'password': 'qwer'},
    {'image': null, 'title': 'my diary 4', 'password': null},
    {'image': null, 'title': 'My-Diary5', 'password': null},
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.55,
          color: Colors.white,
          child: PageView.builder(
            controller: pageController,
            itemCount: diaryList.length,
            itemBuilder: (context, index) {
              return Material(
                  child: InkWell(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  color: Colors
                      .primaries[Random().nextInt(Colors.primaries.length)],
                  child: Text(
                    (index + 1).toString(),
                    style: TextStyle(fontSize: 100),
                  ),
                ),
                onTap: () {
                  String _valueText = '';
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("비밀번호를 입력하세요"),
                      content: TextField(
                        onChanged: (value) {
                          _valueText = value;
                        },
                      ),
                      actions: [
                        OutlinedButton(
                            onPressed: (() {
                              Navigator.pop(context);
                            }),
                            child: const Text("취소")),
                        ElevatedButton(
                            onPressed: (() {
                              Navigator.pop(context, []);
                            }),
                            child: const Text("확인"))
                      ],
                    ),
                  );
                },
              ));
            },
            onPageChanged: (value) {
              setState(() {
                _currentPageIndex = value;
              });
            },
          ),
        ),
        const SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
              child: PopupMenuButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                itemBuilder: (context) {
                  List<PopupMenuEntry> a = [];
                  int _index = 0;
                  diaryList.forEach((e) {
                    a.add(PopupMenuItem(
                        value: _index++, child: Text(e['title'])));
                  });
                  return a;
                },
                onSelected: ((value) {
                  _currentPageIndex = value;
                  pageController.animateToPage(_currentPageIndex,
                      duration: const Duration(microseconds: 500),
                      curve: Curves.easeIn);
                }),
                child: Text(
                  '${diaryList.elementAt(_currentPageIndex)['title']}\t',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            SizedBox(
              height: 30,
              width: 30,
              child: PopupMenuButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                icon: const Icon(Icons.keyboard_arrow_down),
                itemBuilder: ((context) => [
                      PopupMenuItem(
                        child: Text('표지 바꾸기'),
                        onTap: null,
                      ),
                      PopupMenuItem(
                        child: Text('잠금 설정'),
                        onTap: null,
                      ),
                      PopupMenuItem(
                        child: Text(
                          '다이어리 삭제',
                          style: TextStyle(color: Colors.red),
                        ),
                        onTap: null,
                      ),
                    ]),
              ),
            ),
          ],
        )
      ],
    );
  }
}

class AccountImageIcon extends StatefulWidget {
  const AccountImageIcon({super.key});
  @override
  State<AccountImageIcon> createState() => _AccountImageIconState();
}

class _AccountImageIconState extends State<AccountImageIcon> {
  final String accountImageUrl = 'assets/images/account_icon_image.png';
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          border: Border.all(width: 1.2, color: Colors.black),
          shape: BoxShape.circle,
          image: DecorationImage(
            image: AssetImage(accountImageUrl),
            fit: BoxFit.fill,
          ),
        ));
  }
}

class DrawerMenuBar extends StatefulWidget {
  const DrawerMenuBar({super.key});
  @override
  State<DrawerMenuBar> createState() => _DrawerMenuBarState();
}

class _DrawerMenuBarState extends State<DrawerMenuBar> {
  final String alias = '오리너구리'; //사용자 별명
  final String accountImageUrl =
      'assets/images/account_icon_image.png'; //프로필 사진 주소
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width,
      child: ListView(children: <Widget>[
        const Padding(padding: EdgeInsets.all(8)),
        const SizedBox(height: 40.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Builder(
                builder: (context) => IconButton(
                      icon: const Icon(Icons.arrow_right_rounded),
                      iconSize: 40,
                      onPressed: () {
                        Scaffold.of(context).closeEndDrawer();
                      },
                    )),
            Text(
              '$alias님',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
            const Expanded(child: SizedBox()),
            Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  border: Border.all(width: 1.5, color: Colors.black),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage(accountImageUrl), fit: BoxFit.fill),
                )),
            Container(
              width: 60,
              height: 100,
              alignment: Alignment.bottomLeft,
              child: IconButton(
                  icon: Icon(
                    Icons.settings,
                    color: Colors.black,
                  ),
                  onPressed: null),
            ),
          ],
        ),
        const SizedBox(height: 40.0),
        const Divider(
            height: 20,
            thickness: 1.5,
            indent: 20,
            endIndent: 30,
            color: Color(0xffFCD2D2)),
        const ListTile(
          leading: Icon(
            Icons.document_scanner,
            color: Colors.black,
          ),
          title: Text('나의 템플릿 관리', style: TextStyle(fontSize: 16)),
          onTap: null,
        ),
        const Divider(
            height: 20,
            thickness: 1.5,
            indent: 20,
            endIndent: 30,
            color: Color(0xffFCD2D2)),
        const ListTile(
          leading: Icon(
            Icons.storefront,
            color: Colors.black,
          ),
          title: Text('템플릿 스토어', style: TextStyle(fontSize: 16)),
          onTap: null,
        ),
        const Divider(
            height: 20,
            thickness: 1.5,
            indent: 20,
            endIndent: 30,
            color: Color(0xffFCD2D2)),
        const ListTile(
          leading: Icon(
            Icons.play_lesson_rounded,
            color: Colors.black,
          ),
          title: Text('튜토리얼 다시보기', style: TextStyle(fontSize: 16)),
          onTap: null,
        ),
      ]),
    );
  }
}