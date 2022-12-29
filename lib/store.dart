import 'package:cloud_firestore/cloud_firestore.dart';

var db = FirebaseFirestore.instance;

class Store {
  static String token = "";
  static String userId = "";

  static String currentDiaryId = "";
  static var currentDiaryInfo = {
    "id": currentDiaryId,
    "userid": userId,
    "pages": []
  };

  static Map<int, dynamic> temp = {};
  static void setPage(int pageidx, Map items) {
    temp[pageidx] = items;
  }

  static void setDiary() {
    var pages = [];
    print(temp);
    for (var item in temp.values) {
      pages.add(item);
    }
    currentDiaryInfo["pages"] = pages;
    createPost();
  }

  //Firebase
  static void createPost() {
    String diaryId = "GrZSSShpj3vLvLstKT3R";
    var data = currentDiaryInfo;
    db.collection("Diarys").doc(diaryId).update(data);
  }

  static void getPost() async {
    String diaryId = "GrZSSShpj3vLvLstKT3R";
    var data = currentDiaryInfo;
    // db.collection("Diarys").where(diaryId).get().then((value) => print(value));
    db.collection("Diarys").doc(diaryId).get().then((d) {
      print(d.data());
    });
  }
}