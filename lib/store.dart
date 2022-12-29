import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_stickers/image_stickers.dart';
import 'package:image_stickers/image_stickers_controls_style.dart';
import 'package:diory_project/edit_page.dart';
import 'package:diory_project/write_text.dart';
import 'package:flutter/material.dart';

var db = FirebaseFirestore.instance;

class Store {
  static String userId = "YE7Fz6e0BfT6qHqujFuwhZByL5m2";
  static String currentDiaryId = "edyDuhGPSK7pHvsJOms1";
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
    drawPage(data, 0);
  }

  static void drawPage(data, pageIdx) {
    List<WriteText> textItems = [];
    List<UISticker> stickerItems = [];
    int i = 0;
    if (data["pages"].length == 0) {
      ItemController.textItems = [];
      ItemController.stickerItems = [];
      return;
    }
    for (var page in data["pages"][pageIdx]["components"]) {
      if (page["type"] == "Text") {
        textItems.add(WriteText(
            id: i++, text: page["text"], dx: page["x"], dy: page["y"]));
      } else if (page["type"] == "Sticker") {
        stickerItems.add(UISticker(
            imageProvider: AssetImage(page["stickerId"]),
            x: page["x"],
            y: page["y"],
            size: page["size"],
            angle: page["angle"],
            editable: false));
      }
    }
    ItemController.textItems = textItems;
    ItemController.stickerItems = stickerItems;
  }

  static bool getDiaryPages() {
    db.collection("Diarys").doc(currentDiaryId).get().then((d) {
      currentDiaryInfo["title"] = d["title"];
      currentDiaryInfo["pages"] = d["pages"];
    });
    return true;
  }

  static Future<int> createNewDiary(title, cover, password) async {
    int newIndex = 0;
    await db.collection("Diarys").get().then((value) {
      newIndex = value.docs
          .map((e) => e.data())
          .where((element) => element['userId'] == Store.userId)
          .length;
      print(newIndex);
    });
    var emptyDiary = {
      "title": title,
      "cover": cover,
      "pages": [],
      "userId": userId,
      "index": newIndex,
      "password": password,
      "bookmarked": false
    };
    db.collection("Diarys").add(emptyDiary).then((value) {
      currentDiaryId = value.id;
      currentDiaryInfo = {"title": "", "pages": []};
      db.collection("Users").doc(userId).update({
        "diarys": FieldValue.arrayUnion([value.id])
      });
    });
    return newIndex;
  }
}
