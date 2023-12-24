import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:mobileproject/screens/todo/taskdetail_page.dart';
import 'package:mobileproject/widgets/animation_star.dart';


import '../../controllers/todo_controller.dart';
import '../../widgets/animation_checkbutton.dart';


class favorite_page extends StatefulWidget {
  const favorite_page({super.key});

  @override
  State<favorite_page> createState() => _taskPageState();
}

class _taskPageState extends State<favorite_page> {
  final fireStore database = fireStore();
  final TextEditingController textController  = TextEditingController();
  final TextEditingController editController  = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: database.getFavoriteTodo(),
            builder: (context, snapshot){
              if(snapshot.hasError){
                return Text('Error: ${snapshot.error}');
              }
              if(snapshot.hasData){
                List todoList = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: todoList.length,
                  itemBuilder: (context, index){
                    DocumentSnapshot document = todoList[index];
                    Map<String, dynamic> data  = document.data() as Map<String, dynamic>;
                    String todo = data['todo'];
                    DateTime date = data['dueTo'].toDate();
                    String formattedDate = DateFormat('dd-MM-yyyy').format(date);
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
                      startActionPane: ActionPane(
                        motion: StretchMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context4){
                              setState(() {
                                AwesomeDialog(
                                    context: context,
                                    btnOkOnPress: () {
                                      if (editController.text.isNotEmpty) {
                                        setState(() {
                                          data['todo'] = editController.text;
                                          FirebaseFirestore.instance.collection(
                                              'todos').doc(document.id).update(
                                              data);
                                          editController.clear();
                                        });
                                      }
                                    },
                                    btnCancelOnPress: (){},
                                    body: Container(
                                      margin: EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          Container(child: Text("You are editing: $todo "), padding: EdgeInsets.all(10),),
                                          TextField(
                                            controller: editController,
                                            decoration: InputDecoration(
                                              labelText: "New Task Title",
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                ).show();
                              });
                            },
                            label: "Edit",
                            icon: Icons.edit,
                            backgroundColor: Colors.green,
                          )
                        ],
                      ),
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => taskDetail(text: todo, detail: data['detail'],)));
                        },
                        child: ListTile(
                            leading:  favoriteButton(data: data, isFavorite: data['isFavorited'], document: document,),
                            trailing: checkButton(data: data, isCompleted: data['isCompleted'], document: document),
                            title: Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(data['todo']),
                                  Visibility(
                                    visible: formattedDate != "01-01-2001",
                                    child: Container(
                                      decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(10)),
                                      padding: EdgeInsets.all(5),
                                      child: Text(formattedDate),
                                    ),
                                  ),
                                ],
                              ),
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
          ),
        ),
      ],
    );
  }
}
