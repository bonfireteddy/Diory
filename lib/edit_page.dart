import 'package:diory_project/stickerCollection.dart';
import 'package:diory_project/write_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_stickers/image_stickers.dart';
import 'package:image_stickers/image_stickers_controls_style.dart';
import 'store.dart';
import 'package:diory_project/stickerCollection.dart';

class ItemController {
  static int id = 0;
  static List<WriteText> textItems = <WriteText>[];
  static List<UISticker> stickerItems = <UISticker>[];

  static List<Stack> pages = <Stack>[];

  static Future setPages() async {
    pages = <Stack>[];
    int i = 0;
    await Store.getPost();
    for (var data in Store.currentDiaryInfo["pages"]) {
      List<WriteText> textItems = <WriteText>[];
      List<UISticker> stickerItems = <UISticker>[];
      if (data["components"].length > 0) {
        for (var page in data["components"]) {
          print(page);
          if (page["type"] == "Text") {
            textItems.add(WriteText(
                id: i++, text: page["text"], dx: page["x"], dy: page["y"]));
          } else if (page["type"] == "Sticker") {
            stickerItems.add(UISticker(
                imageProvider: AssetImage(page["stickerId"]),
                x: page["x"],
                y: page["y"],
                size: page["size"],
                angle: page["angle"],
                editable: false));
          }
        }
      }

      pages.add(Stack(children: [
        ImageStickers(
          backgroundImage: const AssetImage("assets/stickers/white_page.png"),
          stickerList: stickerItems,
          stickerControlsStyle: ImageStickersControlsStyle(
              color: Colors.blueGrey,
              child: const Icon(
                Icons.zoom_out_map,
                color: Colors.white,
              )),
        ),
        for (var item in textItems) item,
      ]));
    }
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
        "stickerId": item.imageProvider.toString().split("\"")[1],
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
  }
}

class EditPage extends StatelessWidget {
  const EditPage({super.key});

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
  final int diaryIndex;
  final int pageIndex;
  MyEditPage({super.key, required this.diaryIndex, required this.pageIndex});

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
        title: Text('${widget.pageIndex == -1 ? 'new page' : 'edit page'}'),
        centerTitle: true,
        // 중앙 정렬
        elevation: 0.0,
        // 앱바 밑에 내려오는 그림자 조절 가능
        backgroundColor: Colors.white,

        actions: [
          IconButton(
              onPressed: () {
                print("Now Page : ${widget.pageIndex}");
                if (widget.pageIndex == -1) {
                  ItemController.setPage(ItemController.pages.length);
                } else {
                  ItemController.setPage(widget.pageIndex);
                }
                ItemController.setPages();
              },
              icon: const Icon(Icons.save)),
          IconButton(
              onPressed: () async {
                await Store.getPost();
                setState(() {});
              },
              icon: const Icon(Icons.refresh)),
          IconButton(
              onPressed: () async {
                await ItemController.setPages();
                bool state = (ItemController.stickerItems.length > 0)
                    ? ItemController.stickerItems[0].editable
                    : true;
                ItemController.stickerItems.forEach((sticker) {
                  sticker.editable = !state;
                  setState(() {});
                });
              },
              icon: const Icon(Icons.check)),
          IconButton(
              onPressed: () {
                Store.createNewDiary();
              },
              icon: const Icon(Icons.create_new_folder))
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
                      ItemController.textItems.add(writetext);
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
            child: GridView.builder(
              itemCount: AssetSticker.stickerIdx.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1.0,
              ),
              itemBuilder: (context, index) {
                return Container(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            ItemController.stickerItems.add(createSticker(
                                ItemController.stickerItems.length,
                                'assets/stickers/${index.toString()}.png'));
                          });
                        },
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: Image.asset(
                              'assets/stickers/${index.toString()}.png'),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ));
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
