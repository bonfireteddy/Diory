import 'package:diory_project/edit_text_page.dart';
import 'package:flutter/material.dart';

class EditPage extends StatefulWidget {
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _items = <Widget>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  addText();
                },
                icon: Icon(Icons.edit)),
            IconButton(onPressed: () {}, icon: Icon(Icons.check)),
          ],
        ),
        body: Stack(
          children: [for (int i = 0; i < _items.length; i++) _items[i]],
        ));
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
                      _items.add(EditTextPage(myText: _text));
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
}
