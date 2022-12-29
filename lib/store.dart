import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_stickers/image_stickers.dart';
import 'package:image_stickers/image_stickers_controls_style.dart';
import 'package:diory_project/edit_page.dart';
import 'package:diory_project/write_text.dart';
import 'package:flutter/material.dart';

var db = FirebaseFirestore.instance;

class Store {
  static String token = "";
  static String userId = "BWBe0HQ2h50rhCCGtW9J";
  static String currentDiaryId = "";

  static var currentDiaryInfo = {
    "title": "",
    "coverid": 0,
    "pages": [],
    "userid": userId,
    "id": currentDiaryId,
    "index": -1,
    "password": null,
    "bookmarked": false
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
    var data = await db.collection("Diarys").doc(diaryId).get();
    currentDiaryInfo["pages"] = data["pages"];
    drawPage(data);
  }

  /* 데이터베이스에서 페이지 정보 불러옴 */
  static void drawPage(DocumentSnapshot<Map<String, dynamic>> data) {
    List<WriteText> textItems = [];
    List<Sticker> stickerItems = [];
    int i = 0;
    for (var page in data["pages"][0]["components"]) {
      if (page["type"] == "Text") {
        textItems.add(WriteText(
            id: i++, text: page["text"], dx: page["x"], dy: page["y"]));
      } else if (page["type"] == "Sticker") {
        stickerItems.add(Sticker(
            id: i++,
            uiSticker: (UISticker(
                imageProvider: AssetImage(page["stickerId"]),
                x: page["x"],
                y: page["y"],
                size: page["size"],
                angle: page["angle"],
                editable: false))));
      }
    }
    ItemController.textItems = textItems;
    ItemController.stickerItems = stickerItems;
  }

  /* 데이터베이스에서 다이어리의 모든 페이지 정보 불러옴 -> 현재님이 다 했을 때 homepage.dart와 연결할 것 */
  static void getDiaryPages() {
    String diaryId = "GrZSSShpj3vLvLstKT3R";
    var pages = []; // 하나의 다이어리의 모든 페이지
    db.collection("Diarys").doc(diaryId).get().then((d) {
      for (var page in d["pages"]) {
        for (var component in page["components"]) {
          pages.add(component);
        }
      }
      currentDiaryInfo["pages"] = pages;
      print(currentDiaryInfo["pages"]);
    });
  }

  /* 새로운 다이어리 생성 -> 현재님이 다 했을 때 homepage.dart와 연결할 것 */
  static void createNewDiary(String title) {
    currentDiaryInfo["title"] = title;
    currentDiaryInfo["userid"] = userId;
    db.collection("Diarys").add(currentDiaryInfo).then((value) {
      token = value.id;
      db.collection("Users").doc(userId).update({
        "diarys": FieldValue.arrayUnion([token])
      });
    });
  }
}
