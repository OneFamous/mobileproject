import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  late String uid;
  late String email;
  late String name;
  late String userName;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.userName,
  });

  // Firestore belgesinden UserModel oluşturmak için factory metodu
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      userName: data['userName'] ?? '',
    );
  }

  // UserModel'i Firestore için Map'e çevirmek için metot
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'userName': userName,
    };
  }
}

