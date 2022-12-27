import 'package:flutter/material.dart';

class WriteTextPage extends StatefulWidget {
  String myText;
  WriteTextPage({Key? key, required this.myText}) : super(key: key);
  @override
  _WriteTextPageState createState() => _WriteTextPageState();
}

class _WriteTextPageState extends State<WriteTextPage> {
  Offset offset = Offset.zero;
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {});
    _textController.text = widget.myText;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          left: offset.dx,
          top: offset.dy,
          child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  offset = Offset(offset.dx + details.delta.dx,
                      offset.dy + details.delta.dy);
                });
              },
              child: Container(
                  child: Center(
                child: Text(
                  widget.myText,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                  ),
                ),
              )),
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
                          actions: [
                            TextField(controller: _textController),
                            TextButton(
                              child: const Text('확인'),
                              onPressed: () {
                                Navigator.of(context).pop();
                                setState(() {
                                  widget.myText = _textController.text;
                                });
                              },
                            ),
                          ]))),
        ),
      ],
    );
  }
}
