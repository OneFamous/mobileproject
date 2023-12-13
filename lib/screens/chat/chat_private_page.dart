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

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
  }

  @override
  void dispose() {
    super.dispose();
  }
/*
  Future<List<MessagesModel>> getMessages() async {
    DocumentSnapshot<Map<String, dynamic>> a = await FirebaseFirestore.instance.collection('chats').doc(widget.personToChat.chatid).get();
    List<MessagesModel> result = [];
    for(Map<String, dynamic> x in a['messages']){
      result.add(MessagesModel(senderId: x['senderid'], text: x['text'], timestamp: (x['timestamp'] as Timestamp?)!.toDate()));
    }
    return result;
  }
*/
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

  TextStyle myAppbarStyle = textStyle(25, Colors.black, FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
              StreamBuilder<List<MessagesModel>>(
                stream: getMessages(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator()
                    );
                  } else if (snapshot.hasError && snapshot.error != null) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('You have no Chats!');
                  } else {
                    List<MessagesModel> messages = snapshot.data!;
                    return ListView.builder(
                      itemCount: messages.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return Padding(
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
                                  color: Colors.lightBlueAccent,
                                  borderRadius: BorderRadius.circular(35),
                                ),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 15),
                                  child: Text(
                                    messages[index].text,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.circular(35),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextFormField(/*
                        controller: _model.textController,
                        focusNode: _model.textFieldFocusNode,
                        autofocus: true,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Label here...',
                          labelStyle: FlutterFlowTheme.of(context).bodyMedium,
                          hintStyle: FlutterFlowTheme.of(context).labelMedium,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).alternate,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).primary,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedErrorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium,
                        validator: _model.textControllerValidator
                            .asValidator(context),*/
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward,
                      color: Colors.black,
                      size: 24,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
