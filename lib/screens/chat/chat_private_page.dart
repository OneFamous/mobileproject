import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobileproject/models/chat_model.dart';

import '../../utils.dart';

class ChatPrivatePageWidget extends StatefulWidget {
  const ChatPrivatePageWidget({super.key, required this.personToChat});

  final ChatPeople personToChat;

  @override
  _ChatPrivateWidgetState createState() => _ChatPrivateWidgetState();
}

class _ChatPrivateWidgetState extends State<ChatPrivatePageWidget> {
  late User _user;
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Stream<List<MessagesModel>> getMessages() {
    return FirebaseFirestore.instance.collection('chats').doc(widget.personToChat.chatid)
        .snapshots()
        .map((doc) {
      List<MessagesModel> result = [];
      for (Map<String, dynamic> x in doc['messages']) {
        result.add(MessagesModel(
          senderId: x['senderid'],
          text: x['text'],
          timestamp: (x['timestamp'] as Timestamp?)!.toDate(),
        ));
      }
      return result;
    });
  }

  Future<void> sendMessage(String text) async {
    if(widget.personToChat.isNewChat){
      CollectionReference<Map<String, dynamic>> col = FirebaseFirestore.instance.collection('chats');
      List<String> participants = [_user.uid, widget.personToChat.userid];

      DateTime now = DateTime.now();
      List<Map<String, dynamic>> message = [MessagesModel(senderId: _user.uid, text: textController.text, timestamp: now).toMap()];
      await col.add({
        'participants': participants,
        'messages': message,
        widget.personToChat.userid: 'false',
        _user.uid: 'false',
      });

      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance.collection('chats').get();
      widget.personToChat.isNewChat = false;
      for(var documentSnapshot in querySnapshot.docs){
        List<dynamic> participants = documentSnapshot['participants'];

        if (participants.contains(_user.uid) && participants.contains(widget.personToChat.userid)) {
          widget.personToChat.chatid = documentSnapshot.id;
          setState(() {

          });
          break;
        }
      }
    }
    else{
      DocumentReference<Map<String, dynamic>> doc = FirebaseFirestore.instance.collection('chats').doc(widget.personToChat.chatid);
      DateTime now = DateTime.now();
      await doc.update({
        'messages': FieldValue.arrayUnion(
            [MessagesModel(
              senderId: _user.uid,
              text: text,
              timestamp: now,
            ).toMap()]
        ),
        widget.personToChat.userid: 'false',
        _user.uid: 'false',
      });
    }
  }

  TextStyle myAppbarStyle = textStyle(25, Colors.black, FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text(widget.personToChat.username, style: myAppbarStyle),
        centerTitle: true,
      ),
      body: SafeArea(
        top: true,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  reverse: true,
                  child: Column(
                    children: [
                      StreamBuilder<List<MessagesModel>>(
                        stream: getMessages(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator()
                            );
                          } else if (snapshot.hasError && snapshot.error != null) {
                            if(snapshot.error.toString().contains('DocumentSnapshotPlatform')){
                              return const Center(
                                child: Text('Send a message to start chatting'),
                              );
                            }
                            else{
                              return Text('Error: ${snapshot.error}');
                            }
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Text('You have no Chats!');
                          } else {
                            List<MessagesModel> messages = snapshot.data!;
                            return ListView.builder(
                              itemCount: messages.length,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                return (index == 0 || messages[index].timestamp.year != messages[index-1].timestamp.year ||
                                      messages[index].timestamp.month != messages[index-1].timestamp.month ||
                                      messages[index].timestamp.day != messages[index-1].timestamp.day
                                    ?

                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Center(
                                        child: Text(
                                            '${messages[index].timestamp.day.toString().padLeft(2,'0')}-${messages[index].timestamp.month.toString().padLeft(2,'0')}-${messages[index].timestamp.year.toString()}'
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: (_user.uid == messages[index].senderId ? MainAxisAlignment.end : MainAxisAlignment.start),
                                        children: [
                                          Container(
                                            constraints: BoxConstraints(
                                              maxWidth: MediaQuery.sizeOf(context).width * 0.8,
                                              maxHeight: MediaQuery.sizeOf(context).height * 1,
                                            ),
                                            decoration: BoxDecoration(
                                              color: (_user.uid == messages[index].senderId ? Colors.deepOrange : Theme.of(context).colorScheme.secondary),
                                              borderRadius: BorderRadius.circular(35),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 15),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                    messages[index].text,
                                                  ),
                                                  Text(
                                                    style: const TextStyle(
                                                      color: Colors.black45,
                                                    ),
                                                    '${messages[index].timestamp.hour.toString().padLeft(2,'0')}:${messages[index].timestamp.minute.toString().padLeft(2,'0')}',
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ]
                                  ),
                                )
                                    :
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: (_user.uid == messages[index].senderId ? MainAxisAlignment.end : MainAxisAlignment.start),
                                    children: [
                                      Container(
                                        constraints: BoxConstraints(
                                          maxWidth: MediaQuery.sizeOf(context).width * 0.8,
                                          maxHeight: MediaQuery.sizeOf(context).height * 1,
                                        ),
                                        decoration: BoxDecoration(
                                          color: (_user.uid == messages[index].senderId ? Colors.deepOrange : Theme.of(context).colorScheme.secondary),
                                          borderRadius: BorderRadius.circular(35),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 15),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                ),
                                                messages[index].text,
                                              ),
                                              Text(
                                                style: const TextStyle(
                                                  color: Colors.black45,
                                                ),
                                                '${messages[index].timestamp.hour.toString().padLeft(2,'0')}:${messages[index].timestamp.minute.toString().padLeft(2,'0')}',
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ));
                              },
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
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
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 15, 0),
                          child:TextFormField(
                            controller: textController,
                            autofocus: false,
                            obscureText: false,
                            decoration: InputDecoration(
                              hintText: 'Enter message',
                              hintStyle: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
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
                            onFieldSubmitted: (value) async {
                              if (value.isNotEmpty) {
                                await sendMessage(value);
                                textController.clear();
                              }
                            },
                            onEditingComplete: () {},
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 15, 0),
                        child: GestureDetector(
                          onTap: () async {
                            String enteredText = textController.text;
                            if (enteredText.isNotEmpty) {
                              await sendMessage(enteredText);
                              textController.clear();
                            }
                          },
                          child: const Icon(
                            Icons.arrow_forward,
                            color: Colors.deepOrange,
                            size: 24,
                          ),
                        ),
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
