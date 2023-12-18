import 'package:flutter/material.dart';
import 'package:mobileproject/models/note_model.dart';
import 'package:mobileproject/utils.dart';
import 'package:mobileproject/widgets/notes/confirm_dialog.dart';
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
        title: Text(noteModel.title,
            style: const TextStyle(fontWeight: FontWeight.bold)),
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
              final isDelete = await showConfirmDialog(
                  context,
                  "Please Confirm",
                  "Are you sure to delete this note ?\n${noteModel.title}");

              if (isDelete != null && isDelete == true) {
                delete(noteModel);
                if (context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                  );
                }
              }
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
        child: Column(
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
    );
  }
}
