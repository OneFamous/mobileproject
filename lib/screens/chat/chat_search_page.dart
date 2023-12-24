import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/chat_model.dart';
import 'chat_private_page.dart';

class ChatSearchPageWidget extends StatefulWidget {
  const ChatSearchPageWidget({Key? key}) : super(key: key);

  @override
  _ChatSearchPageWidgetState createState() => _ChatSearchPageWidgetState();
}

class _ChatSearchPageWidgetState extends State<ChatSearchPageWidget> {
  TextEditingController textController = TextEditingController();
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

  Future<List<ChatPeople>> getUserListByName(String loggedInUserId) async {
    List<ChatPeople> userList = [];

    if (textController.text.isNotEmpty) {
      try {
        QuerySnapshot<Map<String, dynamic>> querySnapshot =
            await FirebaseFirestore.instance.collection('users').get();

        for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot
            in querySnapshot.docs) {
          String userName = documentSnapshot['userName'];

          if (userName.toLowerCase().contains(textController.text.toLowerCase())) {
            String userId = documentSnapshot.id;

            if (userId != _user.uid) {
              bool isAlreadyExists = false;

              QuerySnapshot<Map<String, dynamic>> querySnapshot =
                  await FirebaseFirestore.instance.collection('chats').get();

              for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot2
                  in querySnapshot.docs) {
                List<dynamic> participants = documentSnapshot2['participants'];

                if (participants.contains(loggedInUserId) &&
                    participants.contains(userId)) {
                  userList.add(ChatPeople(
                      lastMessage: MessagesModel(senderId: ' ', text: ' ', timestamp: DateTime.now()),
                      isNewChat: false,
                      chatid: documentSnapshot2.id,
                      userid: userId,
                      username: userName));
                  isAlreadyExists = true;
                  break;
                }
              }
              if (!isAlreadyExists) {
                userList.add(ChatPeople(
                    lastMessage: MessagesModel(senderId: ' ', text: ' ', timestamp: DateTime.now()),
                    isNewChat: true,
                    chatid: '-1',
                    userid: userId,
                    username: userName));
              }
            }
          }
        }
      } catch (e) {
        print('Error: $e');
      }
    }
    return userList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        top: true,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.deepOrange,
                            size: 24,
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: textController,
                          autofocus: true,
                          obscureText: false,
                          decoration: InputDecoration(
                            hintText: 'Enter username',
                            hintStyle: TextStyle(
                              color: Colors.grey[800],
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.transparent,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.transparent,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.transparent,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedErrorBorder: UnderlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.transparent,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {});
                          },
                          onFieldSubmitted: (value) {},
                          onEditingComplete: () {},
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
                        child: Icon(
                          Icons.search_sharp,
                          color: Colors.deepOrange,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      FutureBuilder<List<ChatPeople>>(
                        future: getUserListByName(_user.uid),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Text('This username does not exists!');
                          } else {
                            List<ChatPeople> userList = snapshot.data!;
                            return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: userList.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ChatPrivatePageWidget(
                                                  personToChat:
                                                      userList[index])),
                                    );
                                  },
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 5),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        borderRadius: BorderRadius.circular(20),
                                        shape: BoxShape.rectangle,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    15, 15, 15, 15),
                                            child: Icon(
                                              Icons.person_rounded,
                                              color: Colors.black,
                                              size: 36,
                                            ),
                                          ),
                                          Text(
                                            userList[index].username,
                                            textAlign: TextAlign.start,
                                            style: const TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.black,
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
            ],
          ),
        ),
      ),
    );
  }
}
