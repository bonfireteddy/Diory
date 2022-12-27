import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Hello, My Diory',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            )),
        leading: null,
        /*leading: const IconButton(
          icon: Icon(Icons.store),
          onPressed: null,
        ),*/
        actions: [
          Builder(
              /*builder: (context) => IconButton(
                    icon: Icon(Icons.account_circle_outlined),
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer();
                    },
                  )*/
              builder: (context) => RawMaterialButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: const CircleBorder(),
                    child: Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1.2, color: Colors.black),
                          shape: BoxShape.circle,
                          image: const DecorationImage(
                            image: AssetImage(
                                'assets/images/account_icon_image.png'),
                            fit: BoxFit.fill,
                          ),
                        )),
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer();
                    },
                  )),
        ],
      ),
      endDrawer: Drawer(
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
                        onPressed: () {
                          Scaffold.of(context).closeEndDrawer();
                        },
                      )),
              const Text(
                '오리너구리님',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
              const Expanded(child: SizedBox()),
              Container(
                  width: 75,
                  height: 75,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1.5, color: Colors.black),
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image:
                            AssetImage('assets/images/account_icon_image.png'),
                        fit: BoxFit.fill),
                  )),
              IconButton(
                  icon: Icon(
                    Icons.settings,
                    color: Colors.black,
                  ),
                  onPressed: null),
              const SizedBox(width: 25.0),
            ],
          ),
          const SizedBox(height: 40.0),
          const Divider(
              height: 20,
              thickness: 1.5,
              indent: 10,
              endIndent: 50,
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
              indent: 10,
              endIndent: 50,
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
              indent: 10,
              endIndent: 50,
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
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 2),
                      alignment: Alignment.bottomRight,
                      child: const Icon(Icons.list),
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.amber,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                        padding: const EdgeInsets.only(top: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'My Diary 1',
                              style: TextStyle(fontSize: 18),
                            ),
                            Icon(Icons.keyboard_arrow_down)
                          ],
                        )),
                  ),
                ],
              )),
          const Expanded(flex: 1, child: SizedBox()),
        ],
      ),
    );
  }
}
