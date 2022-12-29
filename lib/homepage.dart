import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diory_project/diary_setting.dart';
import 'package:diory_project/diary_readingview.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'diary_showlist.dart';
import 'account_setprofile.dart';

final FirebaseAuth userInfo = FirebaseAuth.instance;
var nickname;

class MyHomePage extends StatelessWidget {
  //final String? id;
  //final String? pass;
  //const MyHomePage({super.key, this.id, this.pass});
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
      endDrawer: DrawerMenuBar(
        //id: id,
        //pass: pass,
      ),
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
  List bookmarkedDiaryList = [];
  final ValueNotifier<int> _currentPageIndex = ValueNotifier<int>(0);

  PageController _pageController = PageController(initialPage: 0);
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
            return Text("Loading");
          }
          bookmarkedDiaryList = snapshot.data!.docs
              .map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                data['id'] = document.id;
                return data;
              })
              .where((element) => element['bookmarked'])
              .toList();
          print(_currentPageIndex.value);
          return bookmarkedDiaryList.isEmpty
              ? Container(
                  alignment: Alignment.topCenter,
                  child: Text('즐겨찾기한 다이어리가 없어요!', style: TextStyle(height: 5)),
                )
              : Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.55,
                      color: Colors.white,
                      child: PageView.builder(
                        itemCount: bookmarkedDiaryList.length,
                        controller: _pageController,
                        itemBuilder: (context, index) {
                          return Container(
                              width:
                                  MediaQuery.of(context).size.width * 0.60 + 20,
                              height:
                                  MediaQuery.of(context).size.width * 0.80 + 20,
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
                                          image: NetworkImage(bookmarkedDiaryList
                                                  .elementAt(index)['cover'] ??
                                              'assets/images/coverImages/default.png'))),
                                ),
                                onTap: () {
                                  passwordCheck(
                                      context,
                                      bookmarkedDiaryList.elementAt(index),
                                      DiaryReadingView());
                                },
                              )));
                        },
                        onPageChanged: (value) {
                          _currentPageIndex.value = value;
                        },
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    ValueListenableBuilder(
                        valueListenable: _currentPageIndex,
                        builder: (context, value, child) => Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (bookmarkedDiaryList.elementAt(
                                        _currentPageIndex.value)['password'] !=
                                    '')
                                  const Icon(Icons.lock, size: 20),
                                SizedBox(
                                  height: 30,
                                  child: PopupMenuButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    itemBuilder: (context) {
                                      List<PopupMenuEntry> a = [];
                                      int index = 0;
                                      bookmarkedDiaryList.forEach((e) {
                                        a.add(PopupMenuItem(
                                            value: index++,
                                            child: Text(e['title'])));
                                      });
                                      return a;
                                    },
                                    onSelected: ((value) {
                                      _currentPageIndex.value = value;
                                      _pageController.animateToPage(
                                          _currentPageIndex.value,
                                          duration:
                                              const Duration(microseconds: 500),
                                          curve: Curves.easeIn);
                                    }),
                                    child: Text(
                                      ' ${bookmarkedDiaryList.elementAt(_currentPageIndex.value)['title']}\t',
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),
                                diaryMenuButton(
                                    context,
                                    bookmarkedDiaryList
                                        .elementAt(_currentPageIndex.value),
                                    30)
                              ],
                            )),
                  ],
                );
        });
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
  //final String? id;
  //final String? pass;
  //const DrawerMenuBar({super.key, this.id, this.pass});
  const DrawerMenuBar({super.key});
  @override
  State<DrawerMenuBar> createState() => _DrawerMenuBarState();
}

class _DrawerMenuBarState extends State<DrawerMenuBar> {
  static final storage = FlutterSecureStorage();
  //String? id = "";
  //String? pass = "";
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
  void initState() {
    super.initState();
    //id = widget.id;
    //pass = widget.pass;
  }


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
              '$nickname님',
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
                //storage.delete(key: "login");
                signOut();
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              }
          ),
        ),
    ]),
    );
  }
}

Widget diaryMenuButton(context, data, double size) {
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
            passwordCheck(context, data, EditDiarySetting(data: data));
            break;
          case 1:
            passwordCheck(
                context, data, DeleteDiaryWarningDialog(context, data));
            break;
        }
      },
    ),
  );
}

void passwordCheck(context, data, route) {
  String password = data['password'];
  if (password == '') {
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

Widget DeleteDiaryWarningDialog(context, Map<String, dynamic> data) {
  return AlertDialog(
      icon: Icon(
        Icons.warning,
        color: Colors.red,
        size: 50,
      ),
      content: Text(
        '정말로....\n${data['title']} 다이어리를\n영원히 삭제할까요....?',
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
