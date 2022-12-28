import 'package:diory_project/write_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

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
  final _items = <WriteText>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        // 중앙 정렬
        elevation: 0.0,
        // 앱바 밑에 내려오는 그림자 조절 가능
        backgroundColor: Colors.grey,
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   onPressed: () {
        //     FocusManager.instance.primaryFocus?.unfocus();
        //     print('back button is clicked');
        //   },
        // ),

        // 텍스트 필드 누르면 키보드가 올라옴과 동시에 우측 상단 햄버거 메뉴가
        // 완료 TextButton으로 바뀌고 완료를 누르면 키보드가 내려가게 하는 이벤트
        actions: [
          if (MediaQuery.of(context).viewInsets.bottom > 0)
            TextButton(
              onPressed: FocusManager.instance.primaryFocus?.unfocus,
              child: Text('완료', style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      endDrawer: Drawer(
        // 햄버거 menu아이콘을 만들지 않아야 나온다!!! -> 햄버거 아이콘을 자동적으로 만들어줌
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

      body: Stack(children: [
        ElevatedButton(
            onPressed: () => {
                  for (var item in _items)
                    print(item.dx.toString() + item.dy.toString() + item.text)
                },
            child: Container(
              width: 100,
              height: 100,
              color: Colors.blue,
            )),
        for (var item in _items) item
      ]),

      // ---------------------------------------------------------

      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        //animatedIcon: AnimatedIcons.menu_close, -> 기본아이콘이 햄버거로 정해져있음.

        children: [
          SpeedDialChild(child: Icon(Icons.arrow_downward), label: 'return'),
          SpeedDialChild(child: Icon(Icons.text_fields), label: 'font change'),
          SpeedDialChild(
            child: Icon(Icons.edit),
            label: 'text',
            onTap: () {
              addText();
            },
          ),
          SpeedDialChild(child: Icon(Icons.emoji_emotions), label: 'sticker'),
          SpeedDialChild(
              child: Icon(Icons.add_photo_alternate), label: 'gallery'),
          SpeedDialChild(
            child: Icon(Icons.delete),
            label: 'delete',
            onTap: () {
              deleteText();
            },
          ),
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      // floatingActionButton의 위치 변경
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
              children: <Widget>[
                TextField(
                  controller: _textEditingController,
                )
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text("입력"),
                onPressed: () {
                  _text = _textEditingController.text;
                  if (_text != '') {
                    setState(() {
                      var writetext = WriteText(text: _text);
                      _items.add(writetext);
                    });
                  }
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text("취소"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  void deleteText() {
    for (int i = 0; i < _items.length; i++) {
      if (!_items[i].isExist) {
        setState(() {
          _items.removeAt(i);
        });
      }
    }
  }
}
