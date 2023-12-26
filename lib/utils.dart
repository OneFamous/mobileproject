import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

import 'controllers/coin_controller.dart';
import 'models/note_model.dart';

TextStyle textStyle(double size, Color color, FontWeight fw) {
  return GoogleFonts.lato(fontSize: size, color: color, fontWeight: fw);
}

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Colors.grey.shade200,
    primary: Colors.grey.shade300,
    secondary: Colors.grey.shade400,
    tertiary: Colors.black, //Note detail page
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: Colors.grey.shade900,
    primary: Colors.grey.shade800,
    secondary: Colors.grey.shade700,
    tertiary: Colors.white, //Note detail page
  ),
);

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightMode;
  ThemeProvider(this._themeData);

  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}

//Notes module utils
class Boxes {
  static Box<NoteModel> getData() => Hive.box<NoteModel>("notes");
}

Future<void> showOperationResultSnackBar(
    BuildContext context, Color color, String message) async {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: color,
      content: Text(message),
    ),
  );
}

String formatLastModifiedDate(DateTime lastModifiedDate) {
  String formattedDate =
      '${lastModifiedDate.hour < 10 ? '0${lastModifiedDate.hour}' : lastModifiedDate.hour}:${lastModifiedDate.minute < 10 ? '0${lastModifiedDate.minute}' : lastModifiedDate.minute}';
  int daysDifference = DateTime.now().difference(lastModifiedDate).inDays;

  if (daysDifference == 0) {
    formattedDate = 'Today, $formattedDate';
  } else if (daysDifference == 1) {
    formattedDate = 'Yesterday, $formattedDate';
  } else {
    formattedDate = '$daysDifference days ago, $formattedDate';
  }
  return formattedDate;
}

String formatCreationDate(DateTime creationDate) {
  return '${creationDate.day < 10 ? '0${creationDate.day}' : creationDate.day}.${creationDate.month < 10 ? '0${creationDate.month}' : creationDate.month}.${creationDate.year}';
}

//Home Page utils
//get currentUser or null: General solution
User? getCurrentUser() {
  return FirebaseAuth.instance.currentUser;
}

//get currentUser's field value or null: General solution
Future<String?> getUserInfo(String fieldName) async {
  User? user = getCurrentUser();
  if (user == null) {
    return null;
  } else {
    DocumentSnapshot<Map<String, dynamic>> userSnapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
    return userSnapshot[fieldName];
  }
}

//get note info that is going to display at home page
List<String> getHomePageNoteInfo() {
  List<NoteModel> notes = Boxes.getData().values.toList();
  if (notes.isEmpty) {
    return [
      'You have no notes!',
      'Click on this card to write your first note.',
      'Creation Date',
      'Last Modified Date'
    ];
  } else {
    NoteModel note = notes[notes.length - 1];
    //0:title, 1:description, 2:creationDate, 3:lastModifiedDate
    List<String> noteInfo = [
      note.title,
      note.description,
      formatCreationDate(note.creationDate),
      formatLastModifiedDate(note.lastModifiedDate)
    ];
    return noteInfo;
  }
}

List<String> getHomePageCoinInfo() {
  CoinController coins = Get.put(CoinController());
  //0:image, 1:name, 2:priceChangePercentage24H, 3:currentPrice, 4:symbol
  List<String> coinInfo = [
    coins.coinsList[0].image,
    coins.coinsList[0].name,
    '${coins.coinsList[0].priceChangePercentage24H.toStringAsFixed(2)}%',
    '\$ ${coins.coinsList[0].currentPrice.round()}',
    coins.coinsList[0].symbol.toUpperCase()
  ];
  return coinInfo;
}

Future<List<String>?> getHomePageToDoInfo() async {
  User? user = getCurrentUser();
  QueryDocumentSnapshot<Map<String, dynamic>> recentToDoDocument;
  Duration recentToDo, difference;
  List<String> toDoInfo = [
    'You have no to-do!',
    'Click on this card to write your to-do.',
    'Due to Date'
  ];

  if (user == null) {
    return null;
  } else {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('todos')
        .where('userid', isEqualTo: user.uid)
        .where('isCompleted', isEqualTo: false)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      //Initialization before loop
      recentToDoDocument = querySnapshot.docs.elementAt(0);
      recentToDo = (recentToDoDocument['dueTo'] as Timestamp)
          .toDate()
          .difference(DateTime.now());

      for (QueryDocumentSnapshot<Map<String, dynamic>> toDoDocument
          in querySnapshot.docs) {
        difference = (toDoDocument['dueTo'] as Timestamp)
            .toDate()
            .difference(DateTime.now());

        if (difference < recentToDo) {
          recentToDo = difference;
          recentToDoDocument = toDoDocument;
        }
      }

      toDoInfo = [
        recentToDoDocument['todo'],
        recentToDoDocument['detail'],
        formatCreationDate((recentToDoDocument['dueTo'] as Timestamp).toDate())
      ];
    }
  }
  return toDoInfo;
}

Future<List<String>?> getHomePageChatInfo() async {
  User? user = getCurrentUser();
  QueryDocumentSnapshot<Map<String, dynamic>> recentChatDocument;
  Duration recentChat, difference;
  List<String> chatInfo = [
    'Sender',
    'Receiver',
    'Click on this card to start your first chat.',
    'Time of Shipment'
  ];
  List<dynamic> messages;

  if (user == null) {
    return null;
  } else {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('chats')
        .where('participants', arrayContains: user.uid)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      //Initialization before loop
      recentChatDocument = querySnapshot.docs.elementAt(0);
      messages = recentChatDocument.data()['messages'];

      recentChat = DateTime.now().difference(
          (messages[messages.length - 1]['timestamp'] as Timestamp).toDate());

      for (QueryDocumentSnapshot<Map<String, dynamic>> chatDocument
          in querySnapshot.docs) {
        messages = chatDocument.data()['messages'];

        difference = DateTime.now().difference(
            (messages[messages.length - 1]['timestamp'] as Timestamp).toDate());

        //print('chatDocument text : ${messages[messages.length - 1]['text']}'); Output: Random chat order

        if (difference < recentChat) {
          recentChat = difference;
          recentChatDocument = chatDocument;
        }
      }

      messages = recentChatDocument.data()['messages'];
      List<dynamic> participants = recentChatDocument['participants'];

      String senderUserId = messages[messages.length - 1]['senderid'];
      String receiverUserId =
          participants[0] == senderUserId ? participants[1] : participants[0];

      DocumentSnapshot<Map<String, dynamic>> senderSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(senderUserId)
              .get();
      String senderUserName = senderSnapshot['userName'];

      DocumentSnapshot<Map<String, dynamic>> receiverSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(receiverUserId)
              .get();
      String receiverUserName = receiverSnapshot['userName'];

      //0:sender username, 1:receiver username, 2:message, 3:time
      chatInfo = [
        senderUserName,
        receiverUserName,
        messages[messages.length - 1]['text'],
        formatLastModifiedDate(
            (messages[messages.length - 1]['timestamp'] as Timestamp).toDate())
      ];
    }
  }

  return chatInfo;
}
