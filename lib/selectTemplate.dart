import 'package:flutter/material.dart';

class SelectTemplatePage extends StatefulWidget {
  const SelectTemplatePage({super.key});
  @override
  State<SelectTemplatePage> createState() => _SelectTemplatePageState();
}

class _SelectTemplatePageState extends State<SelectTemplatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        title: const Text('템플릿 선택 화면',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            )),
        leading: null,
      ),
      //BODY - Select Template
      body: ListView(shrinkWrap: true, children: [
        Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: const Text(
            "기본 템플릿",
            style: TextStyle(fontSize: 30),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: 190.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              _pageComponent("111"),
              const SizedBox(width: 15),
              _pageComponent("222"),
              const SizedBox(width: 15),
              _pageComponent("333"),
              const SizedBox(width: 15),
              _pageComponent("111"),
              const SizedBox(width: 15),
              _pageComponent("222"),
              const SizedBox(width: 15),
              _pageComponent("333"),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(20, 50, 20, 10),
          child: const Text(
            "커스텀 템플릿",
            style: TextStyle(fontSize: 30),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: 190.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              _pageComponent("111"),
              const SizedBox(width: 15),
              _pageComponent("222"),
              const SizedBox(width: 15),
              _pageComponent("333"),
              const SizedBox(width: 15),
              _pageComponent("111"),
              const SizedBox(width: 15),
              _pageComponent("222"),
              const SizedBox(width: 15),
              _pageComponent("333"),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(20, 50, 20, 10),
          child: const Text(
            "다운로드 템플릿",
            style: TextStyle(fontSize: 30),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: 190.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              _pageComponent("111"),
              const SizedBox(width: 15),
              _pageComponent("222"),
              const SizedBox(width: 15),
              _pageComponent("333"),
              const SizedBox(width: 15),
              _pageComponent("111"),
              const SizedBox(width: 15),
              _pageComponent("222"),
              const SizedBox(width: 15),
              _pageComponent("333"),
            ],
          ),
        )
      ]),
    );
  }

  _pageComponent(String text) {
    return Container(
      height: 190,
      width: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(124, 221, 221, 221),
      ),
      child: Column(
        children: [
          Container(
            height: 160,
            width: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(124, 169, 169, 169),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            text,
            style: const TextStyle(fontSize: 14),
          )
        ],
      ),
    );
  }
}
