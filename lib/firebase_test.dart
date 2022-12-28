import 'package:cloud_firestore/cloud_firestore.dart';

var db = FirebaseFirestore.instance;

void createDoc(int id) {
  final data = <String, dynamic>{
    "first": "Ada",
    "last": "Lovelace",
    "born": 1815
  };
  db.collection("post").doc("1").update(data);
}

void writeDiary() {
  var data = {
    "id": "",
    "userid": "BWBe0HQ2h50rhCCGtW9J",
    "pages": [
      {
        "components": [
          {
            "type": "Text",
            "text": "테스트 텍스트",
            "x": 100,
            "y": 100,
          },
          {
            "type": "Sticker",
            "stickeridx": 0,
            "x": 100,
            "y": 100,
          }
        ],
        "templateid": "tStt41YZpDRin0T4Ijbx"
      }
    ]
  };

  db.collection("Diarys").add(data);
}
