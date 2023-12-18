import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobileproject/NavBar.dart';
import 'package:mobileproject/utils.dart';
import 'package:provider/provider.dart';

//import 'package:firebase_auth/firebase_auth.dart';

import 'chat/chat_main_page.dart';
import 'currency_page.dart';
import 'notes/home_page.dart';
import 'todo/todo_main.dart';

class homePage extends StatelessWidget {
  const homePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: const MyHomePage(title: ''),
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
  //late User _user;

  late CollectionReference usersref;
  //final TextEditingController _belgeIdController = TextEditingController();
  late StreamController<DocumentSnapshot?> _streamController;
  //late FirebaseFirestore _firestore;

  @override
  void initState() {
    super.initState();
    //_user = FirebaseAuth.instance.currentUser!;
    usersref = FirebaseFirestore.instance.collection('users');
    _streamController = StreamController<DocumentSnapshot?>.broadcast();
    //_firestore = FirebaseFirestore.instance;
    // Başlangıçta gösterilecek olan varsayılan değeri ayarla
    _streamController.add(null);
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
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Expanded(
            child: ListView(
              children: [
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          "Welcome, ",
                          style: TextStyle(fontSize: 25),
                        ),
                        padding: EdgeInsets.only(bottom: 10),
                      ),
                      Container(
                        child: Divider(
                          thickness: 2,
                        ),
                        padding: EdgeInsets.only(bottom: 10),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ChatHomePageWidget()));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 10),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 40),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    //Image"
                                    Container(
                                      child: Image.asset('images/chatIcon.png'),
                                      padding: EdgeInsets.only(bottom: 20),
                                    ),
                                    //Text
                                    Text(
                                      "Chat",
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            homePageTodo()));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 10),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 40),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    //Image
                                    Container(
                                      child: Image.asset('images/todoIcon.png'),
                                      padding: EdgeInsets.only(bottom: 20),
                                    ),
                                    //Text
                                    Text(
                                      "Tasks",
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HomeScreen()));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 10),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 40),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    //Image
                                    Container(
                                      child:
                                          Image.asset('images/notesIcon.png'),
                                      padding: EdgeInsets.only(bottom: 20),
                                    ),
                                    //Text
                                    Text(
                                      "Notes",
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CurrencyPage()));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 10),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 40),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    //Image
                                    Container(
                                      child: Image.asset(
                                          'images/currencyIcon.png'),
                                      padding: EdgeInsets.only(bottom: 20),
                                    ),
                                    //Text
                                    Text(
                                      "Currency",
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
