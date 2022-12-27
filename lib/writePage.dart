import 'package:flutter/material.dart';

class WritePage extends StatefulWidget {
  @override
  _WritePageState createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  Offset offset = Offset.zero;
  String text = "test";
  final _textController = TextEditingController();

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
                  height: 100,
                  width: 200,
                  color: Colors.white,
                  child: Center(
                    child: Text(
                      text,
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
                                  text = _textController.text;
                                });
                              },
                            ),
                          ]))),
        ),
      ],
    );
  }
}
