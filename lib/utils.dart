import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

import 'models/note_model.dart';

TextStyle textStyle(double size, Color color, FontWeight fw) {
  return GoogleFonts.montserrat(fontSize: size, color: color, fontWeight: fw);
}

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Colors.grey.shade400,
    primary: Colors.grey.shade300,
    secondary: Colors.grey.shade200,
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: Colors.grey.shade900,
    primary: Colors.grey.shade800,
    secondary: Colors.grey.shade700,
  ),
);

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightMode;

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

void delete(NoteModel notesModel) async {
  await notesModel.delete();
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
