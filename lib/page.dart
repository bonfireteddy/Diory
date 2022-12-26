import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'APP',
        home: Scaffold(
          appBar: AppBar(
            title: const Text('App Practice'),
          ),
          drawer: Drawer(
              backgroundColor: Colors.teal,
              child: Column(children: [
                Container(
                  padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
                  child: Column(
                      children: textMap(["내 정보", "템플릿 스토어", "구매 내역", "판매 내역"])
                          .toList()),
                )
              ])),
          body: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                  children: textMap([
                "2022년 12월 26일 월요일 \n\n 일기도 '글'이므로 '글감' 즉 '소잿거리'가 필요하다. 그런데 하루하루가 쳇바퀴 같아서 쓸 게 도저히 없는 경우가 있다. 그 '쳇바퀴'를 일일이 적는 것도 낭비로 느껴질 것이다.",
                "일기는 '하루의 기록'이다. 단순히 그날 한 일을 적으면 된다. ",
                "그리고 일기를 저녁이나 잠 자기 전에 쓰라는 법은 없다. ",
                "그냥 학교 출석하자마자 일기장 펴고 매 시간 강의 내용 혹은 평가(?)를 요약해 놓는 등 그때그때 마다 문장을 추가로 적어주는 것도 일기다."
              ]).toList())),
          bottomNavigationBar: NavigationBar(
              height: 70,
              destinations: ["Menu", "Home", "Back"]
                  .map((text) => Padding(
                      padding: EdgeInsets.all(10),
                      child: ElevatedButton(
                          onPressed: () => print("$text Clicked"),
                          child: Text(
                            text,
                            style: TextStyle(fontSize: 20),
                          ))))
                  .toList()),
        ));
  }

  textMap(List<String> texts) => texts.map((text) => Center(
      child: Padding(
          padding: EdgeInsets.all(5),
          child: Text(
            text,
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 25),
          ))));
}
