import 'package:diory_project/page.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

import 'login.dart';

const clientId = 'YOUR_CLIENT_ID';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterFireUIAuth.configureProviders([
    const EmailProviderConfiguration(),
    const GoogleProviderConfiguration(clientId: clientId),
  ]);

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
      home: const LoginPage(), //여기에서 처음에는 로그인 및 회원가입 화면으로, 이후 로그인상태에서는 홈화면으로 이동
    );
  }
}

