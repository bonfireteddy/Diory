import 'package:diory_project/homepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

final FirebaseAuth userInfo = FirebaseAuth.instance;

class SetProfile extends StatelessWidget {
  const SetProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [SettingProfile()]),
        ));
  }
}

class SettingProfile extends StatefulWidget {
  const SettingProfile({super.key});
  @override
  State<SettingProfile> createState() => _SettingProfile();
}

class _SettingProfile extends State<SettingProfile> {
  final _usernameController = TextEditingController();
  String alias = '';
  XFile? image;
  final ImagePicker picker = ImagePicker();
  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);
    if (img != null) {
      //ImageCropper().cropImage
    }
    setState(() {
      image = img;
    });

    final ref = FirebaseStorage.instance.ref().child('userProfile').child(userInfo.currentUser!.uid+'jpg');
    //await ref.putFile(image);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          Material(
            child: GestureDetector(
              child: image != null
                  ? Container(
                width: MediaQuery.of(context).size.width * 0.33,
                height: MediaQuery.of(context).size.width * 0.33,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: image != null
                      ? DecorationImage(
                      image: FileImage(File(image!.path)),
                      fit: BoxFit.cover)
                      : null,
                ),
              )
                  : Container(
                      width: MediaQuery.of(context).size.width * 0.33,
                      height: MediaQuery.of(context).size.width * 0.33,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1.2, color: Colors.black),
                          shape: BoxShape.circle,
                          color: const Color(0xffdfdada),
                      ),
                      child: const Icon(
                          Icons.account_circle,
                          size: 100,
                          color: Colors.white,
                      ),
                    ),
                onTap: () {
                getImage(ImageSource.gallery);
              },
            ),
          ),
          const SizedBox(height: 20),
          Row(children: [
            const Expanded(flex: 1, child: SizedBox()),
            Expanded(
                flex: 1,
                child: TextField(
                    maxLength: 18,
                    maxLines: 1,
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      contentPadding: const EdgeInsets.only(left: 30.0, right: 30.0),
                      floatingLabelStyle: TextStyle(
                        color: Colors.yellow,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.yellow,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                    ),
                  )),
                const Expanded(flex: 1, child: SizedBox()
          )]),
          const SizedBox(height: 20),
          Container(
          //alignment: MainAxisAlignment.center,
            height: 70,
            width: 120,
            padding: const EdgeInsets.only(top: 20.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                primary: Colors.yellow[600],
              ),
              child: const Text('Save'),
              onPressed: () {
                final userprofile = userInfo.currentUser;

                FirebaseFirestore.instance.collection('Users').doc(userprofile!.uid).update({
                    "username" : _usernameController.text,
                });

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyHomePage()),
                  );
                },
              ))
            ]);
  }
}
