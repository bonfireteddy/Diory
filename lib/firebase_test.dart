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
