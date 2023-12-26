import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mobileproject/NavBar.dart';
import 'package:mobileproject/models/note_model.dart';
import 'package:mobileproject/utils.dart';
import 'package:mobileproject/widgets/notes/search_box.dart';
import 'package:multi_value_listenable_builder/multi_value_listenable_builder.dart';
import 'note_add_page.dart';
import 'note_detail_page.dart';
import 'note_edit_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  final ValueNotifier<TextEditingValue> searchControllerNotifier =
      ValueNotifier<TextEditingValue>(TextEditingValue.empty);

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      searchControllerNotifier.value = searchController.value;
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    searchControllerNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      drawer: const NavBar(),
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: const Text("Notes", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Column(
            children: [
              SearchBox(controller: searchController),
              const SizedBox(height: 4.0),
              MultiValueListenableBuilder(
                valueListenables: [
                  Boxes.getData().listenable(),
                  searchControllerNotifier,
                ],
                builder: (context, values, _) {
                  List<NoteModel> data = values.elementAt(0).values.toList();

                  data = data
                      .where((note) => note.title
                          .toLowerCase()
                          .startsWith(values.elementAt(1).text.toLowerCase()))
                      .toList();

                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.length,
                    reverse: true,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      String lMDaS =
                          formatLastModifiedDate(data[index].lastModifiedDate);

                      String cDaS =
                          formatCreationDate(data[index].creationDate);

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  NoteDetailScreen(noteModel: data[index]),
                            ),
                          );
                        },
                        child: SizedBox(
                          height: 70,
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                            color: Theme.of(context).colorScheme.background,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          data[index].title.toString(),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Spacer(),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  NoteEditScreen(
                                                      noteModel: data[index]),
                                            ),
                                          );
                                        },
                                        child: const Icon(
                                          Icons.edit,
                                          color: Colors.green,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          AwesomeDialog(
                                            dismissOnTouchOutside: true,
                                            context: context,
                                            dialogType: DialogType.info,
                                            animType: AnimType.topSlide,
                                            showCloseIcon: true,
                                            title: "Warning",
                                            desc:
                                                "You are about to delete the task. Are you sure?",
                                            btnCancelOnPress: () {},
                                            btnOkOnPress: () async {
                                              showOperationResultSnackBar(
                                                  context,
                                                  Colors.red,
                                                  "Note successfully deleted.");
                                              await data[index].delete();
                                            },
                                          ).show();
                                        },
                                        child: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.event),
                                      Text(
                                        cDaS,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const Spacer(),
                                      const Icon(Icons.update),
                                      Text(
                                        lMDaS,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddNoteScreen(),
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
