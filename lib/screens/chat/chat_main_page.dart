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
    await for (QuerySnapshot<Map<String, dynamic>> querySnapshot in FirebaseFirestore.instance.collection('chats').snapshots()) {
      List<ChatPeople> chatList = [];

      for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot in querySnapshot.docs) {
        List<dynamic> participants = documentSnapshot['participants'];

        if (participants.contains(loggedInUserId)) {
          String otherUserId = participants.firstWhere((userId) => userId != loggedInUserId);
          String chatId = documentSnapshot.id;

          DocumentSnapshot<Map<String, dynamic>> documentSnapshot2 = await FirebaseFirestore.instance.collection('users').doc(otherUserId).get();
          String username = documentSnapshot2['userName'];

          chatList.add(ChatPeople(isNewChat: false, chatid: chatId, userid: otherUserId, username: username));
        }
      }

      yield chatList;
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
            MaterialPageRoute(builder: (context) => const ChatSearchPageWidget()),
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
                      return const Center(
                          child: CircularProgressIndicator()
                      );
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
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ChatPrivatePageWidget(personToChat : chatParticipants[index])),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.secondary,
                                  borderRadius: BorderRadius.circular(20),
                                  shape: BoxShape.rectangle,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(15, 15, 15, 15),
                                      child: Icon(
                                        color: Colors.black,
                                        Icons.person_rounded,
                                        size: 36,
                                      ),
                                    ),
                                    Text(
                                      chatParticipants[index].username,
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18.0,
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