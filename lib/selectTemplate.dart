import 'package:flutter/material.dart';
import 'package:flutter/src/material/icons.dart';

const basicTemplateList = [
  "Basic 1",
  "Basic 2",
  "Basic 3",
  "Basic 4",
  "Basic 5"
];
const customTemplateList = [
  "Custom 1",
  "Custom 2",
  "Custom 3",
  "Custom 4",
  "Custom 5"
];
const downloadTemplateList = [
  "Download 1",
  "Download 2",
  "Download 3",
  "Download 4",
  "Download 5",
];

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => print("Clicked"),
        ),
      ),
      //BODY - Select Template
      body: ListView(shrinkWrap: true, children: [
        //Basic Template
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
          child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: basicTemplateList.length,
              itemBuilder: ((context, idx) =>
                  _pageComponent(basicTemplateList[idx])),
              separatorBuilder: (context, idx) => const SizedBox(width: 15)),
        ),

        //Custom Template
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
          child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: customTemplateList.length,
              itemBuilder: ((context, idx) =>
                  _pageComponent(customTemplateList[idx])),
              separatorBuilder: (context, idx) => const SizedBox(width: 15)),
        ),

        //DownLoad Template
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
          child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: downloadTemplateList.length,
              itemBuilder: ((context, idx) =>
                  _pageComponent(downloadTemplateList[idx])),
              separatorBuilder: (context, idx) => const SizedBox(width: 15)),
        ),
        const SizedBox(height: 50)
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
