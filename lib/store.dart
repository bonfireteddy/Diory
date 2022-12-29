import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diory_project/edit_page.dart';
import 'package:diory_project/write_text.dart';

var db = FirebaseFirestore.instance;

class Store {
  static String token = "";
  static String userId = "";

  static String currentDiaryId = "";
  static var currentDiaryInfo = {
    "id": currentDiaryId,
    "userid": userId,
    "pages": [],
    "password": null,
    "coverid": 0
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
    db.collection("Diarys").doc(diaryId).set(data);
  }

  static Future getPost() async {
    String diaryId = "GrZSSShpj3vLvLstKT3R";
    var d = await db.collection("Diarys").doc(diaryId).get();
    currentDiaryInfo["pages"] = d["pages"];
    Test(d);
  }

  static void Test(DocumentSnapshot<Map<String, dynamic>> data) {
    List<WriteText> pageItems = [];
    int i = 0;
    for (var page in data["pages"][0]["components"]) {
      pageItems.add(
          WriteText(id: i++, text: page["text"], dx: page["x"], dy: page["y"]));
      print(page);
    }
    ItemController.items = pageItems;
  }
}
