import 'package:diory_project/homepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth userInfo = FirebaseAuth.instance;

class SetProfile extends StatefulWidget {
  const SetProfile({Key? key}) : super(key: key);

  @override
  _SetProfileState createState() => _SetProfileState();
}

class _SetProfileState extends State<SetProfile> {
  final _usernameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[

              const SizedBox(height: 20.0),
              // [UserName]
              TextField(
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
              ),
              Container(
                //alignment: MainAxisAlignment.center,
                height: 70,
                width: 150,
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
                  )
              )

            ])
        ),
      ),
    );
  }
}