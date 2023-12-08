import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobileproject/NavBar.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class homePage extends StatelessWidget {
  const homePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  int _counter = 0;
  late CollectionReference usersref;
  final TextEditingController _belgeIdController = TextEditingController();
  late StreamController<DocumentSnapshot?> _streamController;
  late FirebaseFirestore _firestore;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    usersref = FirebaseFirestore.instance.collection('users');
    _streamController = StreamController<DocumentSnapshot?>.broadcast();
    _firestore = FirebaseFirestore.instance;
    // Başlangıçta gösterilecek olan varsayılan değeri ayarla
    _streamController.add(null);
  }

  void _incrementCounter() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    final user = <String, dynamic>{
      "email": "ensar@gmail.com",
      "name": "Ensar",
      "password": "123145345",
      "todos": "",
      "username": "freud"
    }; // kayıt ol ekranındaki işlemlere gidicek olan yer!

    firestore.collection("users").add(user).then((DocumentReference doc) =>
        print('DocumentSnapshot added with ID: ${doc.id}')); // ekleme komutu

    setState(() {
      _counter++;
    });
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
            content: const Text('Uygulamadan çıkış yapmak istediğinize emin misiniz?'),
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
        drawer: const NavBar(),
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'userID, ${_user.uid}!',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              TextField(
                controller: _belgeIdController,
                decoration: const InputDecoration(labelText: 'Belge ID Girin'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _firestore
                        .collection('users')
                        .doc(_belgeIdController.text)
                        .snapshots()
                        .listen((DocumentSnapshot snapshot) {
                      _streamController.add(snapshot);
                    });
                  });
                },
                child: const Text('Belgeyi Getir'),
              ),
              const SizedBox(height: 16),
              StreamBuilder<DocumentSnapshot?>(
                stream: _streamController.stream,
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot?> asyncSnapshot) {
                  if (asyncSnapshot.hasError) {
                    return Text('Error: ${asyncSnapshot.error}');
                  }

                  if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                    return const Text('Loading...');
                  }

                  if (asyncSnapshot.hasData && asyncSnapshot.data!.exists) {
                    final belge = asyncSnapshot.data!.data();
                    return Text('Belge: $belge');
                  } else {
                    // Belge bulunamadığında veya henüz belge ID girilmediğinde gösterilecek metin
                    return const Text('Bilgiler');
                  }
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

