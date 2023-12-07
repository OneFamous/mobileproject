import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  late String uid;
  late String email;
  late String name;
  late String userName;
  late List<TodoModel> todos;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.userName,
    required this.todos,
  });

  // Firestore belgesinden UserModel oluşturmak için factory metodu
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      userName: data['userName'] ?? '',
      todos: List<TodoModel>.from((data['todos'] ?? []).map((todo) => TodoModel.fromJson(todo))),
    );
  }

  // UserModel'i Firestore için Map'e çevirmek için metot
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'userName': userName,
      'todos': todos.map((todo) => todo.toJson()).toList(),
    };
  }
}

class TodoModel {
  late String description;
  late DateTime dueDate;
  late bool isCompleted;
  late String title;

  TodoModel({
    required this.description,
    required this.dueDate,
    required this.isCompleted,
    required this.title,
  });

  // JSON'dan TodoModel oluşturmak için factory metodu
  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      description: json['description'] ?? '',
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : DateTime.now(),
      isCompleted: json['isCompleted'] ?? false,
      title: json['title'] ?? '',
    );
  }

  // TodoModel'i JSON için Map'e çevirmek için metot
  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'dueDate': dueDate.toUtc().toIso8601String(),
      'isCompleted': isCompleted,
      'title': title,
    };
  }
}
