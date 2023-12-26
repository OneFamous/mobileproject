import 'package:flutter/material.dart';
import 'package:mobileproject/models/note_model.dart';
import 'package:mobileproject/screens/notes/home_page.dart';
import 'package:mobileproject/utils.dart';
import 'package:mobileproject/widgets/notes/text_form_field.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({Key? key}) : super(key: key);
  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        iconTheme: const IconThemeData(color: Colors.white),
        title:
            const Text("Add a New Note", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AddAndDeleteTextField(
                controller: titleController, labelText: "Title"),
            const SizedBox(height: 16.0),
            Expanded(
              child: AddAndDeleteTextField(
                  controller: descriptionController, labelText: "Description"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        onPressed: () async {
          _addNote();
        },
        child: const Icon(Icons.check, color: Colors.white),
      ),
    );
  }

  Future<void> _addNote() async {
    final title = titleController.text;
    final description = descriptionController.text;

    if (title.isNotEmpty && description.isNotEmpty) {
      final newNote = NoteModel(
        title: title,
        description: description,
        creationDate: DateTime.now(),
        lastModifiedDate: DateTime.now(),
      );

      final box = Boxes.getData();
      box.add(newNote);

      // Navigate back to the previous screen
      // Navigator.pop(context);

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));

      showOperationResultSnackBar(
          context, Colors.green, "Note successfully added.");
    } else {
      // Show an error message if title or description is empty
      showOperationResultSnackBar(
          context, Colors.red, "Please fill in both title and description.");
    }
  }
}
