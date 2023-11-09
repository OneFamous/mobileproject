import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mobileproject/NavBar.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  late CollectionReference usersref;
  final TextEditingController _belgeIdController = TextEditingController();
  late StreamController<DocumentSnapshot?> _streamController;

  late FirebaseFirestore _firestore;
  @override
  void initState() {
    super.initState();
    usersref = FirebaseFirestore.instance.collection('users');
    _streamController = StreamController<DocumentSnapshot?>.broadcast();
    _firestore = FirebaseFirestore.instance;
    // Başlangıçta gösterilecek olan varsayılan değeri ayarla
    _streamController.add(null);
  }

  void _incrementCounter() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    final user = <String, dynamic>{
      "email": "Adasdfa@gmail.com",
      "name": "Berke",
      "password": "313233ads",
      "todos": "",
      "username": "yokedici"
    };

    firestore.collection("users").add(user).then((DocumentReference doc) =>
        print('DocumentSnapshot added with ID: ${doc.id}')); //ekleme komutu

    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            TextField(
              controller: _belgeIdController,
              decoration: InputDecoration(labelText: 'Belge ID Girin'),
            ),
            SizedBox(height: 16),
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
            SizedBox(height: 16),
            StreamBuilder<DocumentSnapshot?>(
              stream: _streamController.stream,
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot?> asyncSnapshot) {
                if (asyncSnapshot.hasError) {
                  return Text('Error: ${asyncSnapshot.error}');
                }

                if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                  return Text('Loading...');
                }

                if (asyncSnapshot.hasData && asyncSnapshot.data!.exists) {
                  final belge = asyncSnapshot.data!.data();
                  return Text('Belge: $belge');
                } else {
                  // Belge bulunamadığında veya henüz belge ID girilmediğinde gösterilecek metin
                  return Text('Bilgiler');
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
    );
  }
}
