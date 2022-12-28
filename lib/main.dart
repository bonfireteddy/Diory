import 'package:flutter/material.dart';
import 'homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Diory',
        theme: ThemeData(
            fontFamily: 'Chivo',
            //primaryColor: Colors.white,
            appBarTheme: const AppBarTheme(
              toolbarHeight: 80,
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              iconTheme: IconThemeData(
                color: Colors.black,
                opacity: 1.0,
                size: 32,
              ),
            ),
            drawerTheme: const DrawerThemeData(
              scrimColor: Colors.white,
              elevation: 0,
            ),
            textTheme: const TextTheme()),
        home: ElevatedButton(
          child: Container(
            height: 200,
            width: 200,
            color: Colors.amber,
          ),
          onPressed: () {
            FirebaseFirestore.instance
                .collection('post')
                .add({'title': "123123", 'content': "aaaaaa"});
          },
        )
        // const MyHomePage(), //여기에서 처음에는 로그인 및 회원가입 화면으로, 이후 로그인상태에서는 홈화면으로 이동
        );
  }
}
