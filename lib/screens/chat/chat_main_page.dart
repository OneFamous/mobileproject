import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobileproject/screens/chat/chat_private_page.dart';
import 'package:mobileproject/screens/chat/chat_search_page.dart';

import '../../NavBar.dart';
import '../../models/chat_model.dart';
import '../../utils.dart';

class ChatHomePageWidget extends StatefulWidget {
  const ChatHomePageWidget({Key? key}) : super(key: key);

  @override
  _ChatHomePageWidgetState createState() => _ChatHomePageWidgetState();
}

class _ChatHomePageWidgetState extends State<ChatHomePageWidget> {
  late User _user;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Stream<List<ChatPeople>> getChatParticipants(String loggedInUserId) async* {
    await for (QuerySnapshot<Map<String, dynamic>> querySnapshot
        in FirebaseFirestore.instance.collection('chats').snapshots()) {
      List<ChatPeople> chatList = [];

      for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot
          in querySnapshot.docs) {
        List<dynamic> participants = documentSnapshot['participants'];

        if (participants.contains(loggedInUserId)) {
          String isDeletedByMe = documentSnapshot[loggedInUserId];

          if (isDeletedByMe == 'false') {
            String otherUserId =
                participants.firstWhere((userId) => userId != loggedInUserId);
            String chatId = documentSnapshot.id;
            List<dynamic> messages = documentSnapshot['messages'];
            MessagesModel lastMessage = MessagesModel(
                senderId: messages.last['senderid'],
                text: messages.last['text'],
                timestamp:
                    (messages.last['timestamp'] as Timestamp?)!.toDate());

            DocumentSnapshot<Map<String, dynamic>> documentSnapshot2 =
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(otherUserId)
                    .get();
            String username = documentSnapshot2['userName'];

            chatList.add(ChatPeople(
                lastMessage: lastMessage,
                isNewChat: false,
                chatid: chatId,
                userid: otherUserId,
                username: username));
          }
        }
      }

      chatList.sort(
          (a, b) => b.lastMessage.timestamp.compareTo(a.lastMessage.timestamp));
      yield chatList;
    }
  }

  Future<void> deleteChat(String chatId, String userId) async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await FirebaseFirestore.instance.collection('chats').doc(chatId).get();
    DocumentReference<Map<String, dynamic>> doc =
        FirebaseFirestore.instance.collection('chats').doc(chatId);

    if (documentSnapshot[userId] == 'true') {
      await doc.delete();
    } else {
      await doc.update({
        _user.uid: 'true',
      });
    }
  }

  TextStyle myAppbarStyle = textStyle(25, Colors.black, FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        onPressed: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ChatSearchPageWidget()),
          )
        },
        tooltip: 'Add New',
        child: const Icon(Icons.add),
      ),
      drawer: const NavBar(),
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text('CHAT', style: myAppbarStyle),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
        child: Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                StreamBuilder<List<ChatPeople>>(
                  stream: getChatParticipants(_user.uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text('You have no Chats!');
                    } else {
                      List<ChatPeople> chatParticipants = snapshot.data!;
                      return ListView.builder(
                        itemCount: chatParticipants.length,
                        scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatPrivatePageWidget(
                                        personToChat: chatParticipants[index])),
                              );
                            },
                            onLongPress: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      10, 20, 10, 20),
                                  child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Are you sure you want to delete chat with ${chatParticipants[index].username}?',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                        TextButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.red),
                                          ),
                                          onPressed: () {
                                            deleteChat(
                                                chatParticipants[index].chatid,
                                                chatParticipants[index].userid);
                                            Navigator.pop(context);
                                            showOperationResultSnackBar(
                                                context,
                                                Colors.green,
                                                'Chat successfully deleted!');
                                          },
                                          child: const Text(
                                            'Delete',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                        ),
                                      ]),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 0, 5),
                              child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0)),
                                color: Theme.of(context).colorScheme.background,
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          15, 15, 15, 15),
                                      child: Icon(
                                        color: Colors.black,
                                        Icons.person_rounded,
                                        size: 36,
                                      ),
                                    ),
                                    Flexible(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 0, 15, 0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  chatParticipants[index]
                                                      .username,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18.0,
                                                  ),
                                                ),
                                                Text(
                                                  '${chatParticipants[index].lastMessage.timestamp.day.toString().padLeft(2, '0')}-${chatParticipants[index].lastMessage.timestamp.month.toString().padLeft(2, '0')}-${chatParticipants[index].lastMessage.timestamp.year.toString()} ${chatParticipants[index].lastMessage.timestamp.hour.toString().padLeft(2, '0')}:${chatParticipants[index].lastMessage.timestamp.minute.toString().padLeft(2, '0')}',
                                                  style: const TextStyle(
                                                    color: Colors.black45,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                (chatParticipants[index]
                                                            .lastMessage
                                                            .text
                                                            .length >
                                                        33
                                                    ? '${chatParticipants[index].lastMessage.text.substring(0, 30)}...'
                                                    : chatParticipants[index]
                                                        .lastMessage
                                                        .text),
                                                style: const TextStyle(
                                                  color: Colors.black45,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
