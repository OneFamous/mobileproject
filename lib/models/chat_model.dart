import 'package:cloud_firestore/cloud_firestore.dart';

class ChatsModel{
  late String chatsId;
  late List<String> participants;
  late List<MessagesModel> messages;

  ChatsModel({
    required this.chatsId,
    required this.participants,
    required this.messages,
  });

  //çalışmıyor !!!!!!!!!!!!!!!!
  factory ChatsModel.fromFirebase(DocumentSnapshot<Map<String, dynamic>> doc){
    Map<String, dynamic> data = doc.data() ?? {};

    return ChatsModel(
      chatsId: doc.id,
      participants: List<String>.from(data['participants'] ?? []),
      messages: List<MessagesModel>.from((data['messages'] as List? ?? []).map((msg) =>
          MessagesModel(
            senderId: msg['senderId'],
            text: msg['text'],
            timestamp: (msg['timestamp'] as Timestamp?)!.toDate(),
          ),
      )),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'participants': participants,
      'messages': messages.map((msg) => msg.toMap()).toList(),
    };
  }
}

class MessagesModel{
  late String senderId;
  late String text;
  late DateTime timestamp;

  MessagesModel({
    required this.senderId,
    required this.text,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'content': text,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}

class ChatPeople{
  late String userid;
  late String chatid;
  late String username;

  ChatPeople({
    required this.chatid,
    required this.userid,
    required this.username,
  });
}