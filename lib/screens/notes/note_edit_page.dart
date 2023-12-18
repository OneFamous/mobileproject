import 'package:flutter/material.dart';
import 'package:mobileproject/models/note_model.dart';
import 'package:mobileproject/widgets/notes/text_form_field.dart';
import 'home_page.dart';

class NoteEditScreen extends StatefulWidget {
  final NoteModel noteModel;
  const NoteEditScreen({Key? key, required this.noteModel}) : super(key: key);
  @override
  State<NoteEditScreen> createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.noteModel.title;
    descriptionController.text = widget.noteModel.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Edit", style: TextStyle(color: Colors.white)),
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
          _saveChanges();
        },
        child: const Icon(Icons.check, color: Colors.white),
      ),
    );
  }

  Future<void> _saveChanges() async {
    widget.noteModel.title = titleController.text.toString();
    widget.noteModel.description = descriptionController.text.toString();
    widget.noteModel.lastModifiedDate = DateTime.now();

    widget.noteModel.save();
    titleController.clear();
    descriptionController.clear();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }
}
