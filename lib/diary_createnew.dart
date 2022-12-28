import 'package:diory_project/diary_showlist.dart';
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
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [SetNewDiaryCoverImage()]),
    );
  }
}

class SetNewDiaryCoverImage extends StatefulWidget {
  const SetNewDiaryCoverImage({super.key});

  @override
  State<SetNewDiaryCoverImage> createState() => _SetNewDiaryCoverImageState();
}

class _SetNewDiaryCoverImageState extends State<SetNewDiaryCoverImage> {
  String titleText = '';
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
    //image = 'notnull';
    return Column(children: [
      Row(children: [
        const Expanded(flex: 1, child: SizedBox()),
        const Text('title:\t'),
        Expanded(
            flex: 1,
            child: TextField(
              maxLength: 18,
              maxLines: 1,
              style: TextStyle(fontSize: 18),
              onChanged: (value) {
                titleText = value;
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
                        ? DecorationImage(image: FileImage(File(image!.path)))
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
      ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: titleText != '' && image != null
                  ? Colors.amber
                  : Colors.grey),
          onPressed: () {
            if (titleText != '' && image != null) {
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

Widget diaryCreateSuccesDialog(context, index) {
  return AlertDialog(
      title: const Text('Create Success!'),
      content: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(children: [
                Image.asset(
                  diaryList.elementAt(index)['image'],
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: MediaQuery.of(context).size.width * 0.60,
                ),
                Text(diaryList.elementAt(index)['title'])
              ]),
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
                          /* 
                      #
                      #   다이어리 작성 페이지로 이동 필요
                      #
                      */
                        },
                        child: const Text('지금 작성!'))
                  ]),
            ],
          )));
}
