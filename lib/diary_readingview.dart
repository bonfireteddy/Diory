import 'package:diory_project/edit_page.dart';
import 'package:diory_project/selectTemplate.dart';
import 'package:flutter/material.dart';

class DiaryReadingView extends StatelessWidget {
  DiaryReadingView({super.key, required int index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('title'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyEditPage(
                              title: 'title',
                            )));
              },
              icon: Icon(Icons.edit)),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SelectTemplatePage()));
              },
              icon: Icon(Icons.add)),
        ],
      ),
    );
  }
}
