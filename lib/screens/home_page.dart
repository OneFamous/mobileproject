import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mobileproject/NavBar.dart';
import 'package:provider/provider.dart';

import '../controllers/coin_controller.dart';
import '../utils.dart';
import 'chat/chat_main_page.dart';
import 'currency_page.dart';
import 'notes/home_page.dart';
import 'notes/note_add_page.dart';
import 'todo/todo_main.dart';

class homePage extends StatelessWidget {
  const homePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: const MyHomePage(title: 'AIOP'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late User _user;

  late CollectionReference usersref;
  //final TextEditingController _belgeIdController = TextEditingController();
  late StreamController<DocumentSnapshot?> _streamController;
  //late FirebaseFirestore _firestore;

  @override
  void initState() {
    super.initState();
    _user = getCurrentUser()!;
    //usersref = FirebaseFirestore.instance.collection('users');
    //_streamController = StreamController<DocumentSnapshot?>.broadcast();
    //_streamController.add(null);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Geri tuşuna basıldığında uygulamadan çıkış yap
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Uygulamadan Çıkış Yap'),
            content: const Text(
                'Uygulamadan çıkış yapmak istediğinize emin misiniz?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Hayır'),
              ),
              TextButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: const Text('Evet'),
              ),
            ],
          ),
        );
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        drawer: const NavBar(),
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          title: Text(widget.title),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  FutureBuilder<String?>(
                    future: getUserInfo('userName'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Hata: ${snapshot.error}');
                      } else {
                        String? userName = snapshot.data;
                        return Container(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            "Welcome, $userName",
                            style: TextStyle(fontSize: 25),
                          ),
                        );
                      }
                    },
                  ),
                  Container(
                    child: Divider(
                      thickness: 2,
                    ),
                    padding: EdgeInsets.only(bottom: 10),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatHomePageWidget()));
                    },
                    child: FutureBuilder<List<String>?>(
                      future: getHomePageChatInfo(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          List<String> chatInfo = snapshot.data!;

                          return Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                            color: Theme.of(context).colorScheme.background,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  contentPadding: EdgeInsets.all(20.0),
                                  leading: Image.asset(
                                    'images/chatIcon.png',
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                  title: Row(
                                    children: [
                                      Text(chatInfo[0]),
                                      Icon(Icons.arrow_forward_sharp),
                                      Text(chatInfo[1]),
                                    ],
                                  ),
                                  subtitle: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              chatInfo[2],
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Icon(Icons.access_time),
                                          Text(chatInfo[3]),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  Container(
                    child: Divider(
                      thickness: 2,
                    ),
                    padding: EdgeInsets.only(bottom: 10),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => homePageTodo()));
                    },
                    child: FutureBuilder<List<String>?>(
                      future: getHomePageToDoInfo(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          List<String> toDoInfo = snapshot.data!;

                          return Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                            color: Theme.of(context).colorScheme.background,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  contentPadding: EdgeInsets.all(20.0),
                                  leading: Image.asset(
                                    'images/todoIcon.png',
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                  title: Text(
                                    toDoInfo[0],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              toDoInfo[1],
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Icon(Icons.event_note_outlined),
                                          Text(toDoInfo[2]),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  Container(
                    child: Divider(
                      thickness: 2,
                    ),
                    padding: EdgeInsets.only(bottom: 10),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Boxes.getData().values.toList().isEmpty
                                      ? const AddNoteScreen()
                                      : const HomeScreen()));
                    },
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                      color: Theme.of(context).colorScheme.background,
                      child: Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Builder(builder: (context) {
                              List<String> noteInfo = getHomePageNoteInfo();
                              return ListTile(
                                contentPadding: EdgeInsets.all(20.0),
                                leading: Image.asset(
                                  'images/notesIcon.png',
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                                title: Text(
                                  noteInfo[0],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            noteInfo[1],
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Icon(Icons.event_note_outlined),
                                        Text(noteInfo[3]),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Divider(
                      thickness: 2,
                    ),
                    padding: EdgeInsets.only(bottom: 10),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CurrencyPage()));
                    },
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                      color: Theme.of(context).colorScheme.background,
                      child: Obx(
                        () => Get.put(CoinController()).isLoading.value
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    contentPadding: EdgeInsets.all(20.0),
                                    leading: Image.asset(
                                      'images/currencyIcon.png',
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                    ),
                                    title: Row(
                                      children: [
                                        Text(getHomePageCoinInfo()[1]),
                                        Spacer(),
                                        Text(getHomePageCoinInfo()[3]),
                                      ],
                                    ),
                                    subtitle: Row(
                                      children: [
                                        Text(getHomePageCoinInfo()[2]),
                                        Spacer(),
                                        Text(getHomePageCoinInfo()[4]),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ])),
          ),
        ),
      ),
    );
  }
}
