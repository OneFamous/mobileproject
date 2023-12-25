import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:mobileproject/screens/todo/taskdetail_page.dart';
import 'package:mobileproject/widgets/alert_dialog.dart';
import 'package:mobileproject/widgets/animation_star.dart';

import '../../controllers/todo_controller.dart';
import '../../widgets/animation_checkbutton.dart';


class taskPage extends StatefulWidget {
  const taskPage({super.key});

  @override
  State<taskPage> createState() => _taskPageState();
}

class _taskPageState extends State<taskPage> {
  final fireStore database = fireStore();
  final TextEditingController textController  = TextEditingController();
  final TextEditingController editController  = TextEditingController();

  void openDialog (){
    AwesomeDialog(
      context: context,
      dismissOnTouchOutside: true,
      dialogType: DialogType.noHeader,
      animType: AnimType.scale,
      showCloseIcon: true,
      body: openAlertDialog(),
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: database.getTodoStream(),
            builder: (context1, snapshot){
              if(snapshot.hasData){
                List todoList = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: todoList.length,
                  itemBuilder: (context2, index){
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
                                      dialogType: DialogType.info,
                                      animType: AnimType.topSlide,
                                      showCloseIcon: true,
                                      title: "Warning",
                                      desc: "You are about to delete the task. Are you sure?",
                                      btnCancelOnPress: (){},
                                      btnOkOnPress: (){
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text("Task is deleted!"),
                                              duration: Duration(seconds: 1),
                                              backgroundColor: Colors.red,
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
                          builder: (context) => taskDetail(text: data['todo'], detail: data['detail'], date: date,)));
                        },
                        child: ListTile(
                          leading:  favoriteButton(data: data, isFavorite: data['isFavorited'], document: document,),
                          trailing: checkButton(data: data, isCompleted: data['isCompleted'], document: document),
                          title:Expanded(
                            child:  Column(
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

        Container(
          margin: EdgeInsets.only(right: 20, bottom: 15, top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                onPressed: openDialog,
                backgroundColor: Colors.deepOrange,
                child: Center(
                  child: Icon(Icons.add),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
