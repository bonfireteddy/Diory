import 'package:flutter/material.dart';
import 'homepage.dart';

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
                      child: const Text('my diaries'),
                    ),
                  ),
                  const Expanded(flex: 12, child: ListGridView()),
                  const Expanded(flex: 1, child: SizedBox()),
                ],
              )),
          const Expanded(flex: 1, child: SizedBox()),
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
  final List diaryList = [
    {'image': null, 'title': 'My Diary 1', 'password': 'qwer'},
    {'image': null, 'title': 'Mydiary 2', 'password': null},
    {'image': null, 'title': 'MY_Diary3', 'password': 'qwer'},
    {'image': null, 'title': 'my diary 4', 'password': null},
    {'image': null, 'title': 'My-Diary5', 'password': null},
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
        child: GridView.builder(
      itemCount: diaryList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 3 / 4,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10),
      itemBuilder: (context, index) => Container(
        color: Colors.blueGrey,
      ),
    ));
  }
}
