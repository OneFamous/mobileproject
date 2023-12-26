import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:mobileproject/models/note_model.dart';
import 'package:mobileproject/utils.dart';
import 'home_page.dart';
import 'note_edit_page.dart';

class NoteDetailScreen extends StatelessWidget {
  final NoteModel noteModel;

  const NoteDetailScreen({Key? key, required this.noteModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //lMDaS : lastModifiedDate as String
    String lMDaS = formatLastModifiedDate(noteModel.lastModifiedDate);
    //cDaS : creationDate as String
    String cDaS = formatCreationDate(noteModel.creationDate);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.tertiary),
        title: Text(noteModel.title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.tertiary)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            color: Colors.green,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteEditScreen(noteModel: noteModel),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            color: Colors.red,
            onPressed: () async {
              AwesomeDialog(
                dismissOnTouchOutside: true,
                context: context,
                dialogType: DialogType.info,
                animType: AnimType.topSlide,
                showCloseIcon: true,
                title: "Warning",
                desc: "You are about to delete the task. Are you sure?",
                btnCancelOnPress: () {},
                btnOkOnPress: () async {
                  showOperationResultSnackBar(
                      context, Colors.red, "Note successfully deleted.");
                  await noteModel.delete();
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                    showOperationResultSnackBar(
                        context, Colors.red, "Note successfully deleted.");
                  }
                },
              ).show();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            noteModel.description,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: Colors.deepOrange,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.08,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Creation Date: $cDaS",
                style: const TextStyle(fontSize: 16, color: Color(0xFFE0E0E0)),
              ),
              Text(
                "Last Modified: $lMDaS",
                style: const TextStyle(fontSize: 16, color: Color(0xFFE0E0E0)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
