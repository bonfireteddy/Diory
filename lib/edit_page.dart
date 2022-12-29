import 'package:diory_project/attach_sticker.dart';
import 'package:diory_project/write_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_stickers/image_stickers.dart';
import 'package:image_stickers/image_stickers_controls_style.dart';

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
  State<MyEditPage> createState() => _MyEditPageState();
}

class _MyEditPageState extends State<MyEditPage> {
  final _items = <Widget>[];
  List<UISticker> stickers = [];

  @override
  void initState() {
    stickers.add(createSticker(0, "assets/stickers/Ribone.png"));
  }

  UISticker createSticker(int index, String s) {
    return UISticker(
        imageProvider: AssetImage(s),

        x: 100,
        y: 360,
        editable: true);
  }
  // 여기까지 스티커 나오게 하는 UIsticker--------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        // 중앙 정렬
        elevation: 0.0,
        // 앱바 밑에 내려오는 그림자 조절 가능
        backgroundColor: Colors.white,


        // 텍스트 필드 누르면 키보드가 올라옴과 동시에 우측 상단 햄버거 메뉴가
        // 완료 TextButton으로 바뀌고 완료를 누르면 키보드가 내려가게 하는 이벤트
        actions: [
          if (MediaQuery.of(context).viewInsets.bottom > 0)
            TextButton(
              onPressed: FocusManager.instance.primaryFocus?.unfocus,
              child: Text('완료', style: TextStyle(color: Colors.white)),
            ),
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.check))
        ],

      ),


      body: Column(
        children: [
          Expanded(
              flex: 30,
              child: Container(
                child: ImageStickers(
                  backgroundImage: const AssetImage("assets/stickers/white_page.png"),
                  stickerList: stickers,
                  stickerControlsStyle: ImageStickersControlsStyle(
                      color: Colors.blueGrey,
                      child: const Icon(
                        Icons.zoom_out_map,
                        color: Colors.white,
                      )),
                ),
              )),
          Expanded(flex: 1, child: Container()),
          // ----------아이콘 크기 조절 박스 -----------------
          for (var item in _items) item
        ],
      ),

      // ---------------------------------------------------------

      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        overlayColor: Colors.grey,
        overlayOpacity: 0.5,
        //animatedIcon: AnimatedIcons.menu_close, -> 기본아이콘이 햄버거로 정해져있음.

        children: [
          SpeedDialChild(child: Icon(Icons.text_fields), label: 'font change'),
          SpeedDialChild(
            child: Icon(Icons.edit),
            label: 'text',
            onTap: () {
              addText();
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.emoji_emotions),
            label: 'sticker',
            onTap: () { /////------------------스티커 추가기능
              show_sticker_menu();
            },
          ),
          SpeedDialChild(
              child: Icon(Icons.add_photo_alternate), label: 'gallery'),
          SpeedDialChild(
            child: Icon(Icons.delete),
            label: 'delete',
            onTap: () {
              clear();
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
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: null,
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text("취소"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text("입력"),
                onPressed: () {
                  _text = _textEditingController.text;
                  if (_text != '') {
                    setState(() {
                      _items.add(WriteText(text: _text));
                    });
                  }
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
                        mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell( // 아이콘 tap했을 때 나오는 효과 이걸 해줘야 tap할 수가 있음.
                            onTap: () {
                              setState(() {
                                stickers.add(createSticker(stickers.length,"assets/stickers/ory_1.png"));
                              });
                            },
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: Image.asset('assets/stickers/ory_1.png'),
                            ),
                          ),
                          InkWell( // 아이콘 tap했을 때 나오는 효과 이걸 해줘야 tap할 수가 있음.
                            onTap: () {
                              setState(() {
                                stickers.add(createSticker(stickers.length, 'assets/stickers/Ribone.png'));
                              });
                            },
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: Image.asset('assets/stickers/Ribone.png'),
                            ),
                          ),
                          InkWell( // 아이콘 tap했을 때 나오는 효과 이걸 해줘야 tap할 수가 있음.
                            onTap: () {
                              setState(() {
                                stickers.add(createSticker(stickers.length, 'assets/stickers/tabaco.png'));
                              });
                            },
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: Image.asset('assets/stickers/tabaco.png'),
                            ),
                          ),
                          InkWell( // 아이콘 tap했을 때 나오는 효과 이걸 해줘야 tap할 수가 있음.
                            onTap: () {
                              setState(() {
                                stickers.add(createSticker(stickers.length, 'assets/stickers/tears.png'));
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
                        mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell( // 아이콘 tap했을 때 나오는 효과 이걸 해줘야 tap할 수가 있음.
                            onTap: () {

                            },
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: Image.asset('assets/ory_1.png'),
                            ),
                          ),
                          InkWell( // 아이콘 tap했을 때 나오는 효과 이걸 해줘야 tap할 수가 있음.
                            onTap: () {

                            },
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: Image.asset('assets/ory_1.png'),
                            ),
                          ),
                          InkWell( // 아이콘 tap했을 때 나오는 효과 이걸 해줘야 tap할 수가 있음.
                            onTap: () {

                            },
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: Image.asset('assets/ory_1.png'),
                            ),
                          ),
                          InkWell( // 아이콘 tap했을 때 나오는 효과 이걸 해줘야 tap할 수가 있음.
                            onTap: () {

                            },
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
                        mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell( // 아이콘 tap했을 때 나오는 효과 이걸 해줘야 tap할 수가 있음.
                            onTap: () {

                            },
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: Image.asset('assets/ory_1.png'),
                            ),
                          ),
                          InkWell( // 아이콘 tap했을 때 나오는 효과 이걸 해줘야 tap할 수가 있음.
                            onTap: () {

                            },
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: Image.asset('assets/ory_1.png'),
                            ),
                          ),
                          InkWell( // 아이콘 tap했을 때 나오는 효과 이걸 해줘야 tap할 수가 있음.
                            onTap: () {

                            },
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: Image.asset('assets/ory_1.png'),
                            ),
                          ),
                          InkWell( // 아이콘 tap했을 때 나오는 효과 이걸 해줘야 tap할 수가 있음.
                            onTap: () {

                            },
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
