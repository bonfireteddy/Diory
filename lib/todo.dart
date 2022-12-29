import 'package:cloud_firestore/cloud_firestore.dart';

class ToDo {

      /*var result;
        final firestore = FirebaseFirestore.instance;
        getData() async {
        result = await firestore.collection('todo').doc('EDOPelBiJxbkZINj1RFY').get();
        print(result);

        }*/

      String? id;
      String? todoText;
      bool isDone;

      ToDo({
      required this.id,
      required this.todoText,
      this.isDone = false,
      });

      static List<ToDo> todoList() {
      return [
        ToDo(id: '01', todoText: '밥 먹기', isDone: true ),
        ToDo(id: '02', todoText: '산책하기', isDone: true ),
        ToDo(id: '03', todoText: '이메일 보내기', ),
        ToDo(id: '04', todoText: '회의', ),
      ];
      }
}