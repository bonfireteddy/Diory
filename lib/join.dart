import 'package:diory_project/setProfile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JoinPage extends StatefulWidget {
  const JoinPage({Key? key}) : super(key: key);

  @override
  State<JoinPage> createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController(); //입력되는 값을 제어
  final TextEditingController _passwordController = TextEditingController();

  Widget _userIdWidget(){
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        contentPadding: const EdgeInsets.only(left: 30.0, right: 30.0),
        labelText: 'Email',
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
      validator: (String? value){
        if (value!.isEmpty) {// == null or isEmpty
          return '이메일을 입력해주세요.';
        }
        return null;
      },
    );
  }

  Widget _passwordWidget(){
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        contentPadding: const EdgeInsets.only(left: 30.0, right: 30.0),
        labelText: 'Password',
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
      validator: (String? value){
        if (value!.isEmpty) {// == null or isEmpty
          return '비밀번호를 입력해주세요.';
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Register"),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 20.0),
              _userIdWidget(),
              const SizedBox(height: 20.0),
              _passwordWidget(),
              Container(
                height: 70,
                padding: const EdgeInsets.only(top: 20.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    primary: Colors.yellow[600],
                  ),
                    onPressed: () => _join(),
                    child: const Text("register")
                ),
              ),
              const SizedBox(height: 20.0),
              //GestureDetector(
              //child: const Text('회원가입'),
              //onTap: (){
              //Get.to(() => const JoinPage());
              //},
              //),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    //해당 클래스가 호출되었을떄
    super.initState();
  }
  @override
  void dispose() {
    // 해당 클래스가 사라질떄
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  _join() async {
    //키보드 숨기기
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).requestFocus(FocusNode());

      // Firebase 사용자 인증, 사용자 등록
      try {
        final r = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text
        );

        await FirebaseFirestore.instance.collection('Users').doc(r.user!.uid).set({
          'email': r.user!.email,
          'username' : null,
        });

        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SetProfile()),
        );

        //Get.offAll(() => const MarketPage());
      } catch (e) {
        print(e);
      }

    }
  }
}

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

// users collection을 변수로 만들어줄게요.
  final CollectionReference userCollection =
  FirebaseFirestore.instance.collection('users');

//회원가입시 사용자가 입력한 email, password를 받아서
  Future updateUserData(
      String _email,
      String _password,
      ) async {
//users 컬렉션에서 고유한 uid document를 만들고 그 안에 email, password 필드값을 채워넣어요.
    return await userCollection.doc(uid).set({
      'email': _email,
      'password': _password,
    });
  }
}