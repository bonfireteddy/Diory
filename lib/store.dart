import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_stickers/image_stickers.dart';
import 'package:image_stickers/image_stickers_controls_style.dart';
import 'package:diory_project/edit_page.dart';
import 'package:diory_project/write_text.dart';
import 'package:flutter/material.dart';

var db = FirebaseFirestore.instance;

class Store {
  static String userId = "YE7Fz6e0BfT6qHqujFuwhZByL5m2";
  static String currentDiaryId = "GrZSSShpj3vLvLstKT3R";
  static Map<String, dynamic> currentDiaryInfo = {"title": "", "pages": []};

  static Map<int, dynamic> temp = {};
  static void setPage(int pageidx, Map items) {
    temp[pageidx] = items;
  }

  static void setDiary() {
    var pages = [];
    for (var item in temp.values) {
      pages.add(item);
    }
    currentDiaryInfo["pages"] = pages;
    updatePost();
  }

  //Firebase
  static void updatePost() {
    var data = currentDiaryInfo;
    db.collection("Diarys").doc(currentDiaryId).update(data);
  }

  static Future getPost() async {
    var data = await db.collection("Diarys").doc(currentDiaryId).get();
    currentDiaryInfo["pages"] = data["pages"];
    drawPage(data);
  }

  /* 데이터베이스에서 페이지 정보 불러옴 */
  static void drawPage(DocumentSnapshot<Map<String, dynamic>> data) {
    List<WriteText> textItems = [];
    List<Sticker> stickerItems = [];
    int i = 0;
    if (data["pages"].length == 0) {
      ItemController.textItems = [];
      ItemController.stickerItems = [];
      return;
    }
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
    db.collection("Diarys").doc(currentDiaryId).get().then((d) {
      currentDiaryInfo["title"] = d["title"];
      currentDiaryInfo["pages"] = d["pages"];
    });
  }

  static void createNewDiary() {
    var emptyDiary = {
      "title": "",
      "coverid": "",
      "pages": [],
      "userid": userId,
      "id": "",
      "index": -1,
      "password": null,
      "bookmarked": false
    };
    db.collection("Diarys").add(emptyDiary).then((value) {
      currentDiaryId = value.id;
      currentDiaryInfo = {"title": "", "pages": []};
      db.collection("Users").doc(userId).update({
        "diarys": FieldValue.arrayUnion([value.id])
      });
    });
  }
}
