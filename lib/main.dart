import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diory',
      theme: ThemeData(
          fontFamily: 'Chivo',
          //primaryColor: Colors.white,
          appBarTheme: const AppBarTheme(
            toolbarHeight: 70,
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            iconTheme: IconThemeData(
              color: Colors.black,
              opacity: 1.0,
              size: 32,
            ),
          ),
          drawerTheme: DrawerThemeData(
            //scrimColor: Colors.white,
            backgroundColor: Colors.white,
            elevation: 0,
          )),
      home: const MyHomePage(title: 'Diory_HomePage'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({super.key, required this.title});
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
              fontSize: 30,
              fontWeight: FontWeight.w700,
            )),
        leading: null,
        /*leading: const IconButton(
          icon: Icon(Icons.store),
          onPressed: null,
        ),*/
        actions: [
          Builder(
              builder: (context) => IconButton(
                    icon: Icon(Icons.account_circle_outlined),
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer();
                    },
                  )),
          SizedBox(width: 12)
        ],
      ),
      endDrawer: Drawer(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [],
          )),
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
                      padding: EdgeInsets.only(bottom: 2),
                      alignment: Alignment.bottomRight,
                      child: const Icon(Icons.list),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.amber,
                    ),
                  ),
                  Expanded(
                    flex: 2,
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
