import 'package:diory_project/write_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_stickers/image_stickers.dart';
import 'package:image_stickers/image_stickers_controls_style.dart';
import 'store.dart';

class ItemController {
  static int id = 0;
  static List<WriteText> textItems = <WriteText>[];
  static List<UISticker> stickerItems = <UISticker>[];

  static void reload() {}
  static void add(WriteText item) {
    textItems.add(item);
  }

  static void update(int id, String text) {
    int index = textItems.indexWhere((item) => item.id == id);
    if (index < 0) return;
    textItems[index].text = text;
  }

  static void delete(int id) {
    textItems.removeWhere((item) => item.id == id);
  }

  static void setPage(int idx) {
    var pageData = {"idx": idx, "components": []};
    var temp = [];
    for (var item in ItemController.textItems) {
      temp.add({
        "type": "Text",
        "text": item.text,
        "x": item.dx,
        "y": item.dy,
      });
    }
    for (var item in ItemController.stickerItems) {
      temp.add({
        "type": "Sticker",
        "x": item.x,
        "y": item.y,
        "angle": item.angle,
        "size": item.size
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
  final _items = <Widget>[];
  List<UISticker> stickers = [];

  UISticker createSticker(int index, String s) {
    return UISticker(
        imageProvider: AssetImage(s), x: 100, y: 360, editable: true);
  }

  // 여기까지 스티커 나오게 하는 UIsticker--------------------------
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
              onPressed: () async {
                await Store.getPost();
                setState(() {});
              },
              icon: const Icon(Icons.refresh)),
          IconButton(
              onPressed: () {
                bool state = (ItemController.stickerItems.length > 0)
                    ? ItemController.stickerItems[0].editable
                    : true;
                ItemController.stickerItems.forEach((sticker) {
                  sticker.editable = !state;
                  setState(() {});
                });
              },
              icon: const Icon(Icons.check))
        ],
      ),
      body: Stack(children: [
        ImageStickers(
          backgroundImage: const AssetImage("assets/stickers/white_page.png"),
          stickerList: ItemController.stickerItems,
          stickerControlsStyle: ImageStickersControlsStyle(
              color: Colors.blueGrey,
              child: const Icon(
                Icons.zoom_out_map,
                color: Colors.white,
              )),
        ),
        for (var item in ItemController.textItems) item,
      ]),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        overlayColor: Colors.grey,
        overlayOpacity: 0.5,
        //animatedIcon: AnimatedIcons.menu_close, -> 기본아이콘이 햄버거로 정해져있음.

        children: [
          SpeedDialChild(
            child: Icon(Icons.text_fields),
            label: 'text',
            onTap: () {
              addText();
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.emoji_emotions),
            label: 'sticker',
            onTap: () {
              /////------------------스티커 추가기능
              show_sticker_menu();
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.undo),
            label: 'undo',
            onTap: () {
              undo();
            },
          ),
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
              children: <Widget>[
                TextField(
                    controller: _textEditingController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null)
              ],
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

  void show_sticker_menu() {
    showModalBottomSheet(
      // bottom sheet
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 400,
          child: Column(
            children: [
              Expanded(
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            // 아이콘 tap했을 때 나오는 효과 이걸 해줘야 tap할 수가 있음.
                            onTap: () {
                              setState(() {
                                ItemController.stickerItems.add(createSticker(
                                    ItemController.stickerItems.length,
                                    "assets/stickers/ory_1.png"));
                              });
                            },
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: Image.asset('assets/stickers/ory_1.png'),
                            ),
                          ),
                          InkWell(
                            // 아이콘 tap했을 때 나오는 효과 이걸 해줘야 tap할 수가 있음.
                            onTap: () {
                              setState(() {
                                ItemController.stickerItems.add(createSticker(
                                    ItemController.stickerItems.length,
                                    'assets/stickers/Ribone.png'));
                              });
                            },
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: Image.asset('assets/stickers/Ribone.png'),
                            ),
                          ),
                          InkWell(
                            // 아이콘 tap했을 때 나오는 효과 이걸 해줘야 tap할 수가 있음.
                            onTap: () {
                              setState(() {
                                ItemController.stickerItems.add(createSticker(
                                    ItemController.stickerItems.length,
                                    'assets/stickers/tabaco.png'));
                              });
                            },
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: Image.asset('assets/stickers/tabaco.png'),
                            ),
                          ),
                          InkWell(
                            // 아이콘 tap했을 때 나오는 효과 이걸 해줘야 tap할 수가 있음.
                            onTap: () {
                              setState(() {
                                ItemController.stickerItems.add(createSticker(
                                    ItemController.stickerItems.length,
                                    'assets/stickers/tears.png'));
                              });
                            },
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: Image.asset('assets/stickers/tears.png'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 1줄 ------------------------------------------
              Expanded(
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            // 아이콘 tap했을 때 나오는 효과 이걸 해줘야 tap할 수가 있음.
                            onTap: () {},
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: Image.asset('assets/ory_1.png'),
                            ),
                          ),
                          InkWell(
                            // 아이콘 tap했을 때 나오는 효과 이걸 해줘야 tap할 수가 있음.
                            onTap: () {},
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: Image.asset('assets/ory_1.png'),
                            ),
                          ),
                          InkWell(
                            // 아이콘 tap했을 때 나오는 효과 이걸 해줘야 tap할 수가 있음.
                            onTap: () {},
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: Image.asset('assets/ory_1.png'),
                            ),
                          ),
                          InkWell(
                            // 아이콘 tap했을 때 나오는 효과 이걸 해줘야 tap할 수가 있음.
                            onTap: () {},
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: Image.asset('assets/ory_1.png'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            // 아이콘 tap했을 때 나오는 효과 이걸 해줘야 tap할 수가 있음.
                            onTap: () {},
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: Image.asset('assets/ory_1.png'),
                            ),
                          ),
                          InkWell(
                            // 아이콘 tap했을 때 나오는 효과 이걸 해줘야 tap할 수가 있음.
                            onTap: () {},
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: Image.asset('assets/ory_1.png'),
                            ),
                          ),
                          InkWell(
                            // 아이콘 tap했을 때 나오는 효과 이걸 해줘야 tap할 수가 있음.
                            onTap: () {},
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: Image.asset('assets/ory_1.png'),
                            ),
                          ),
                          InkWell(
                            // 아이콘 tap했을 때 나오는 효과 이걸 해줘야 tap할 수가 있음.
                            onTap: () {},
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: Image.asset('assets/ory_1.png'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void clear() {
    for (int i = _items.length - 1; i >= 0; i--) {
      setState(() {
        _items.removeAt(i);
      });
    }
  }

  void undo() {
    setState(() {
      if (!_items.isEmpty) _items.removeAt(_items.length - 1);
    });
  }
}
