import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils.dart';


Future<String> getUserName(String userId) async {
  try {
    DocumentSnapshot<Map<String, dynamic>> userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();
      String userName = userSnapshot.get('userName');
      return userName;
  } catch (e) {
    print('Hata: $e');
    return e.toString(); // Hata durumunda null döndürülebilir.
  }
}

listenChat () {
  late User _user;
  _user = getCurrentUser()!;
      FirebaseFirestore.instance
        .collection('chats')
        .where('participants', arrayContains: _user.uid)
        .snapshots()
      .listen((event) async {
    for (var change in event.docChanges) {
      switch (change.type) {
        case DocumentChangeType.added:
          break;
        case DocumentChangeType.modified:
          print("Modified City:");
          if (change.doc.data()?['messages']?.isNotEmpty ?? false  ) {
            Map<String, dynamic> lastMessage =
                change.doc.data()?['messages']?.last ?? {};
            String senderId = lastMessage['senderid']?.toString() ?? '';
            String text = lastMessage['text']?.toString() ?? '';
            if(senderId != _user.uid){
              AwesomeNotifications().createNotification(
                content: NotificationContent(
                  id: -1,
                  channelKey: 'high_importance_channel',
                  title: await getUserName(senderId),
                  body:text,
                ),
                actionButtons: [
                  NotificationActionButton(
                    key: "ChatPage",
                    label: 'Open',
                  ),
                ],
              );
            }
          }
          break;
        case DocumentChangeType.removed:
          break;
      }
    }
  });
}

