import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mobileproject/screens/todo/taskdetail_page.dart';
import '../../controllers/todo_controller.dart';
import '../../widgets/animation_checkbutton.dart';


class completedPage extends StatefulWidget {
  const completedPage({super.key});

  @override
  State<completedPage> createState() => _completedPageState();
}

class _completedPageState extends State<completedPage> {
  final fireStore database = fireStore();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: database.getCompletedTodo(),
              builder: (context, snapshot){
                if(snapshot.hasData){
                  List todoList = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: todoList.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot document = todoList[index];
                      Map<String, dynamic> data  = document.data() as Map<String, dynamic>;
                      String detail = data['detail'];
                      String todoText = data['todo'];
                      bool isChecked = data['isCompleted'];
                      return Slidable(
                        endActionPane: ActionPane(
                          motion: StretchMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context3){
                                AwesomeDialog(
                                  dismissOnTouchOutside: true,
                                  context: context,
                                  dialogType: DialogType.question,
                                  animType: AnimType.topSlide,
                                  showCloseIcon: true,
                                  title: "Warning",
                                  desc: "You are about to delete the task. Are you sure?",
                                  btnCancelOnPress: (){},
                                  btnOkOnPress: (){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text("Task is deleted!"),
                                        )
                                    );
                                    FirebaseFirestore.instance.collection('todos').doc(document.id).delete();
                                  },
                                ).show();
                              },
                              backgroundColor: Colors.red,
                              label: "Delete",
                              icon: Icons.delete,
                            )
                          ],
                        ),
                        child: ListTile(
                            trailing: checkButton(data: data, isCompleted: isChecked, document: document),
                            title: GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => taskDetail(text: todoText, detail: detail, date: data['dueTo'].toDate(), data: data, document: document,)));
                              },
                              child: Container(
                                child: Text(todoText),
                              ),
                            ),
                        ),
                      );
                    },
                  );
                }
                else{
                  return Text("There are no tasks");
                }
              },
            )
        )
      ],
    );
  }
}
