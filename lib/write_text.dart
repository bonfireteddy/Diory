import 'package:flutter/material.dart';
import 'edit_page.dart';

class WriteText extends StatefulWidget {
  int id;
  String text;
  double dx;
  double dy;
  bool isExist = true;

  WriteText(
      {Key? key,
      required this.id,
      required this.text,
      this.dx = 0.0,
      this.dy = 0.0})
      : super(key: key);

  void setText(String text) {
    this.text = text;
  }

  void setPosition(double dx, double dy) {
    this.dx = dx;
    this.dy = dy;
  }

  @override
  _WriteTextState createState() => _WriteTextState();
}

class _WriteTextState extends State<WriteText> {
  Offset offset = Offset.zero;
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {});
    _textController.text = widget.text;
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MyEditPageState parent =
        context.findAncestorStateOfType<MyEditPageState>()!;

    return Stack(
      children: <Widget>[
        Positioned(
          left: widget.dx,
          top: widget.dy,
          child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  widget.dx += details.delta.dx;
                  widget.dy += details.delta.dy;
                  offset = Offset(widget.dx, widget.dy);
                });
              },
              child: Container(
                child: Center(
                  child: Text(
                    widget.text,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),
              onLongPress: () => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        title: Column(
                          children: <Widget>[
                            Text("Edit Text"),
                          ],
                        ),
                        content: Container(
                          height: 150,
                          width: 300,
                          color: Color.fromARGB(0, 177, 177, 177),
                        ),
                        actions: <Widget>[
                          TextField(controller: _textController),
                          TextButton(
                            child: const Text('확인'),
                            onPressed: () {
                              Navigator.of(context).pop();
                              ItemController.update(
                                  widget.id, _textController.text);
                              parent.setState(() {});
                              setState(() {
                                widget.text = _textController.text;
                              });
                            },
                          ),
                          TextButton(
                            child: const Text(
                              '삭제',
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              ItemController.delete(widget.id);
                              parent.setState(() {});
                              // setState(() {
                              //   widget.isExist = false;
                              // });
                            },
                          ),
                        ]),
                  )),
        ),
      ],
    );
  }
}
