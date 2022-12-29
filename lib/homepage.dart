import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diory_project/diary_setting.dart';
import 'package:diory_project/diary_readingview.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'diary_showlist.dart';
import 'account_setprofile.dart';

final bookmarkedDiaryList = diaryList;
final FirebaseAuth userInfo = FirebaseAuth.instance;
var nickname;

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
                      // 현재 사용자 nickname 가져오기
                      FirebaseFirestore.instance
                          .collection('Users')
                          .snapshots()
                          .listen((event) {
                            for(int i=0; i<event.size; i++) {
                              if(event.docs[i]['email'] == userInfo.currentUser!.email) {
                                nickname = event.docs[i]['username'];
                                break;
                              }
                            }
                            Scaffold.of(context).openEndDrawer();
                      });
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Icon(
                          Icons.star_rate_rounded,
                          color: Colors.amber,
                        ),
                        const Text('bookmarked diaries',
                            style: TextStyle(fontSize: 18)),
                        const Expanded(child: SizedBox()),
                        IconButton(
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.list),
                          iconSize: 32,
                          onPressed: (() {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DiaryShowList()));
                          }),
                        )
                      ],
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
  PageController _pageController = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.55,
          color: Colors.white,
          child: PageView.builder(
            controller: _pageController,
            itemCount: bookmarkedDiaryList.length,
            itemBuilder: (context, index) {
              return Container(
                  width: MediaQuery.of(context).size.width * 0.60 + 20,
                  height: MediaQuery.of(context).size.width * 0.80 + 20,
                  child: Material(
                      child: InkWell(
                    child: Container(
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 10.0,
                                spreadRadius: 0,
                                offset: Offset(0, 5))
                          ],
                          image: DecorationImage(
                              image: AssetImage(bookmarkedDiaryList
                                      .elementAt(index)['image'] ??
                                  'assets/images/coverImages/default.png'))),
                    ),
                    onTap: () {
                      passwordCheck(context, index, bookmarkedDiaryList,
                          DiaryReadingView(diaryIndex: index));
                    },
                  )));
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
            if (bookmarkedDiaryList.elementAt(_currentPageIndex)['password'] !=
                null)
              const Icon(Icons.lock, size: 20),
            SizedBox(
              height: 30,
              child: PopupMenuButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                itemBuilder: (context) {
                  List<PopupMenuEntry> a = [];
                  int index = 0;
                  bookmarkedDiaryList.forEach((e) {
                    a.add(
                        PopupMenuItem(value: index++, child: Text(e['title'])));
                  });
                  return a;
                },
                onSelected: ((value) {
                  _currentPageIndex = value;
                  _pageController.animateToPage(_currentPageIndex,
                      duration: const Duration(microseconds: 500),
                      curve: Curves.easeIn);
                }),
                child: Text(
                  ' ${bookmarkedDiaryList.elementAt(_currentPageIndex)['title']}\t',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            diaryMenuButton(context, 30, _currentPageIndex)
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
  Future signOut() async {
    try {
      return await FirebaseAuth.instance.signOut();
    } catch(e) {
      print(e);
    }
  }

  //final String alias = '오리너구리'; //사용자 별명
  String? alias = userInfo.currentUser!.email;
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
                      icon: const Icon(Icons.arrow_back),
                      iconSize: 32,
                      onPressed: () {
                        Scaffold.of(context).closeEndDrawer();
                      },
                    )),
            Text(
              '$nickname님',  // 닉네임이 아니라 이메일로 나옴->수정필요
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
            const SizedBox(width: 50)
          ],
        ),
        const SizedBox(height: 30.0),
        const Divider(
            height: 20,
            thickness: 1.5,
            indent: 20,
            endIndent: 30,
            color: Color(0xffFCD2D2)),
        ListTile(
          leading: Icon(
            Icons.account_box,
            color: Colors.black,
          ),
          title: Text('계정 관리', style: TextStyle(fontSize: 16)),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AccountSetProfile()));
          },
        ),
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
        Container(  // 로그아웃 기능
          width: 60,
          height: 100,
          alignment: Alignment.bottomCenter,
          child: TextButton(
              style: TextButton.styleFrom(primary: Colors.grey),
              child: Text('Logout'),
              onPressed: () {
                signOut();
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              }
          ),
        ),
    ]),
    );
  }
}

Widget diaryMenuButton(context, double size, int index) {
  return SizedBox(
    height: size < 30 ? 30 : size,
    width: size < 30 ? 30 : size,
    child: PopupMenuButton(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      icon: const Icon(Icons.keyboard_arrow_down),
      iconSize: size,
      itemBuilder: ((context) => [
            PopupMenuItem(
              value: 0,
              child: const Text('표지·제목·잠금 설정'),
            ),
            PopupMenuItem(
              value: 1,
              child: const Text(
                '다이어리 삭제',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ]),
      onSelected: (value) {
        switch (value) {
          case 0:
            passwordCheck(
                context, index, diaryList, EditDiarySetting(index: index));
            break;
          case 1:
            passwordCheck(context, index, diaryList,
                DeleteDiaryWarningDialog(context, index));
            break;
        }
      },
    ),
  );
}

void passwordCheck(context, int index, diaryList, route) {
  String? password = diaryList.elementAt(index)['password'];
  if (password == null) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => route,
        ));
    return;
  }
  String valueText = '';
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("비밀번호를 입력하세요"),
      content: TextField(
        onChanged: (value) {
          valueText = value;
        },
      ),
      actions: [
        OutlinedButton(
            onPressed: (() {
              valueText = '';
              Navigator.pop(context);
            }),
            child: const Text("취소")),
        ElevatedButton(
            onPressed: (() {
              if (valueText == password) {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => route,
                    ));
              } else {
                Navigator.pop(context);
                showDialog(
                    context: context,
                    builder: (context) => const AlertDialog(
                          content: Text('비밀번호가 틀렸습니다.'),
                        ));
              }
            }),
            child: const Text("확인"))
      ],
    ),
  );
  return;
}

Widget DeleteDiaryWarningDialog(context, index) {
  return AlertDialog(
      icon: Icon(
        Icons.warning,
        color: Colors.red,
        size: 50,
      ),
      content: Text(
        '정말로....\n${bookmarkedDiaryList.elementAt(index)['title']} 다이어리를\n영원히 삭제할까요....?',
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            backgroundColor: Colors.yellow),
      ),
      actions: [
        TextButton(
            onPressed: () {
              //데이터베이스에서 다이어리 삭제하기
              Navigator.pop(context);
            },
            child: const Text('그러세요')),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('아직좀더생각해봄'))
      ]);
}
