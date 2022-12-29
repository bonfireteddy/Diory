import 'package:diory_project/diary_showlist.dart';
import 'package:diory_project/selectTemplate.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class DiaryCreateNew extends StatelessWidget {
  const DiaryCreateNew({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('create new diary'),
        leading: Builder(
            builder: (context) => IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )),
        actions: [],
      ),
      body: DiarySetting(data: null),
    );
  }
}

class EditDiarySetting extends StatelessWidget {
  Map<String, dynamic> data;
  EditDiarySetting({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('edit diary setting'),
        leading: Builder(
            builder: (context) => IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )),
        actions: [
          Builder(
              builder: (context) => IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )),
          const SizedBox(width: 10)
        ],
      ),
      body: DiarySetting(data: data),
    );
  }
}

class DiarySetting extends StatefulWidget {
  Map<String, dynamic>? data;
  DiarySetting({super.key, required this.data});

  @override
  State<DiarySetting> createState() => _DiarySettingState();
}

class _DiarySettingState extends State<DiarySetting> {
  Map<String, dynamic> newData = {};
  bool lock = false;
  XFile? image;
  final ImagePicker picker = ImagePicker();
  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);
    setState(() {
      image = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data != null) {
      newData = widget.data!;
    }
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(children: [
            const Expanded(flex: 1, child: SizedBox()),
            const Text('title:\t'),
            Expanded(
                flex: 1,
                child: TextField(
                  controller: TextEditingController(text: newData['title']),
                  maxLength: 18,
                  maxLines: 1,
                  style: const TextStyle(fontSize: 18),
                  autofocus: widget.data == null,
                  onChanged: (value) {
                    newData['title'] = value;
                  },
                )),
            const Expanded(flex: 1, child: SizedBox()),
          ]),
          const Divider(
              height: 20,
              thickness: 1.5,
              indent: 50,
              endIndent: 50,
              color: Color(0xffFCD2D2)),
          Row(children: [
            const Expanded(flex: 1, child: SizedBox()),
            const Text('다이어리 잠그기:\t'),
            Checkbox(
              value: lock,
              onChanged: (value) {
                setState(() {
                  lock = value!;
                });
              },
            ),
            const Expanded(flex: 1, child: SizedBox()),
          ]),
          Row(children: [
            const Expanded(flex: 1, child: SizedBox()),
            Text('password:\t',
                style: TextStyle(color: (lock ? Colors.black : Colors.grey))),
            Expanded(
                flex: 1,
                child: TextField(
                  controller: TextEditingController(text: newData['password']),
                  enabled: lock,
                  maxLength: 18,
                  maxLines: 1,
                  style: TextStyle(
                      fontSize: 18, color: (lock ? Colors.black : Colors.grey)),
                  onChanged: (value) {
                    newData['password'] = value;
                  },
                )),
            const Expanded(flex: 1, child: SizedBox()),
          ]),
          const SizedBox(height: 30),
          Material(
            child: InkWell(
              child: image != null
                  ? Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      height: MediaQuery.of(context).size.width * 0.60,
                      decoration: BoxDecoration(
                        image: image != null
                            ? DecorationImage(
                                image: FileImage(File(image!.path)))
                            : null,
                      ),
                    )
                  : Container(
                      width: MediaQuery.of(context).size.width * 0.30,
                      height: MediaQuery.of(context).size.width * 0.40,
                      decoration: const BoxDecoration(
                        color: Color(0xffdfdada),
                      ),
                      child: const Icon(
                        Icons.add_rounded,
                        size: 50,
                        color: Color(0x88000000),
                      ),
                    ),
              onTap: () {
                getImage(ImageSource.gallery);
              },
            ),
          ),
          const SizedBox(height: 20),
          if (widget.data == null)
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: newData['title'] != '' && image != null
                        ? Colors.amber
                        : Colors.grey),
                onPressed: () {
                  if (newData['title'] != '' && image != null) {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => diaryCreateSuccesDialog(context, 1),
                    );
                  } else {
                    //print('no title or coverimage!');
                  }
                },
                child: const Text('다이어리 생성'))
        ]);
  }
}

Widget diaryCreateSuccesDialog(context, id) {
  return AlertDialog(
      title: const Text('Create Success!'),
      content: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              /*Column(children: [
                Image.asset(
                  diaryList.elementAt(index)['image'],
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: MediaQuery.of(context).size.width * 0.60,
                ),
                Text(diaryList.elementAt(index)['title'])
              ]),*/
              const Text('첫 페이지를 작성하시겠습니까?'),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('나중에')),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SelectTemplatePage()));
                        },
                        child: const Text('지금 작성!'))
                  ]),
            ],
          )));
}
