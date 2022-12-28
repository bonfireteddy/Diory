import 'package:diory_project/write_page.dart';
import 'package:flutter/material.dart';
import 'homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'selectTemplate.dart';
import 'write_text_page.dart';
import 'package:diory_project/edit_page.dart' as edit;

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
      home: const edit.MyHomePage(
          title: '테스트'), //여기에서 처음에는 로그인 및 회원가입 화면으로, 이후 로그인상태에서는 홈화면으로 이동
    );
  }
}
