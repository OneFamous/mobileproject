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
      'senderid': senderId,
      'text': text,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}

class ChatPeople{
  late bool isNewChat;
  late String userid;
  late String chatid;
  late String username;

  ChatPeople({
    required this.isNewChat,
    required this.chatid,
    required this.userid,
    required this.username,
  });
}