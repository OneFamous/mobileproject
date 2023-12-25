import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class fireStore {

  User? user = FirebaseAuth.instance.currentUser;

  final CollectionReference todos = FirebaseFirestore.instance.collection("todos");

  Future<void> addTodo(String todo, String desc, DateTime? date) {
    bool isFavorited = false;
    bool isCompleted = false;
    date ??= DateTime(2001,01,01);
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: -1,
        channelKey: 'high_importance_channel',
        title: "Reminder for: $todo",
        body: "This is a reminder from AIOP",
      ),
      schedule:NotificationCalendar.fromDate(date: date),
    );
    return todos.add({
      "userid": user!.uid,
      "todo": todo,
      "timestamp": Timestamp.now(),
      "isFavorited" : isFavorited,
      "isCompleted" : isCompleted,
      "detail" : desc,
      "dueTo" : date,
    });
  }

  Stream<QuerySnapshot> getTodoStream (){
    String currentUserid = user!.uid;
    final todoStream = FirebaseFirestore.instance
        .collection("todos")
        //.orderBy("timestamp", descending: true,)
        .where("userid", isEqualTo: currentUserid)
        .where("isCompleted", isEqualTo: false)
        .snapshots();
    return todoStream;
  }

  Stream<QuerySnapshot> getCompletedTodo(){
    String currentUserid = user!.uid;
    final completedTodoStream = FirebaseFirestore.instance
        .collection("todos")
        .where("isCompleted", isEqualTo: true)
        .where("userid", isEqualTo: currentUserid)
        .snapshots();
    return completedTodoStream;
  }

  Stream<QuerySnapshot> getFavoriteTodo(){
    String currentUserid = user!.uid;
    final completedTodoStream = FirebaseFirestore.instance
        .collection("todos")
        .where("isCompleted", isEqualTo: false)
        .where("isFavorited", isEqualTo: true)
        .where("userid", isEqualTo: currentUserid)
        .snapshots();
    return completedTodoStream;
  }
}