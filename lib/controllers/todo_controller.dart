import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class fireStore {

  User? user = FirebaseAuth.instance.currentUser;

  final CollectionReference todos = FirebaseFirestore.instance.collection("todos");

  Future<void> addTodo(String todo) {
    bool isFavorited = false;
    bool isCompleted = false;
    return todos.add({
      "userid": user!.uid,
      "todo": todo,
      "timestamp": Timestamp.now(),
      "isFavorited" : isFavorited,
      "isCompleted" : isCompleted,
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
}