import 'package:diory_project/write_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'store.dart';

class ItemController {
  static int id = 0;
  static List<WriteText> items = <WriteText>[];

  static void add(WriteText item) {
    items.add(item);
  }

  static void update(int id, String text) {
    int index = items.indexWhere((item) => item.id == id);
    if (index < 0) return;
    items[index].text = text;
  }

  static void delete(int id) {
    items.removeWhere((item) => item.id == id);
  }

  static void setPage(int idx) {
    var pageData = {"idx": idx, "components": []};
    var temp = [];
    for (var item in ItemController.items) {
      temp.add({
        "type": "Text",
        "text": item.text,
        "x": item.dx,
        "y": item.dy,
      });
    }
    pageData["components"] = temp;
    Store.setPage(idx, pageData);
    Store.setDiary();
    print(Store.currentDiaryInfo);
  }
}

class EditPage extends StatelessWidget {
  const EditPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: TextButton(
          onPressed: () => Navigator.pushNamed(context, '/my'),
          child: Text('nextpage'),
        ),
      ),
    );
  }
}

class MyEditPage extends StatefulWidget {
  const MyEditPage({super.key, required this.title});

  final String title;

  @override
  State<MyEditPage> createState() => MyEditPageState();
}

class MyEditPageState extends State<MyEditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        title: Text(widget.title),
        centerTitle: true,
        // 중앙 정렬
        elevation: 0.0,
        // 앱바 밑에 내려오는 그림자 조절 가능
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () => ItemController.setPage(0),
              icon: const Icon(Icons.save)),
          IconButton(
              onPressed: () => Store.createNewDiary(),
              icon: const Icon(Icons.refresh))
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Item1'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      // ------------------------------------------------------

      body: Stack(children: [for (var item in ItemController.items) item]),

      // ---------------------------------------------------------

      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        children: [
          SpeedDialChild(
            child: Icon(Icons.text_fields),
            label: 'text',
            onTap: () {
              addText();
            },
          ),
          SpeedDialChild(child: Icon(Icons.emoji_emotions), label: 'sticker'),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  void addText() {
    String _text = '';

    final _textEditingController = TextEditingController();

    @override
    void initState() {
      super.initState();
      _textEditingController.addListener(() {});
    }

    @override
    void dispose() {
      _textEditingController.dispose();
      super.dispose();
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Column(
              children: <Widget>[
                Text("Input Text"),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[TextField(controller: _textEditingController)],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text("입력"),
                onPressed: () {
                  _text = _textEditingController.text;
                  if (_text != '') {
                    setState(() {
                      var writetext =
                          WriteText(id: ItemController.id, text: _text);
                      ItemController.add(writetext);
                      ItemController.id++;
                    });
                  }
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text("취소"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}
