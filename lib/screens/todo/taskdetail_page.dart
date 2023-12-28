import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobileproject/screens/todo/todo_main.dart';


class taskDetail extends StatefulWidget {
  final DocumentSnapshot document;
  final Map<String, dynamic> data;
  final String text;
  final String detail;
  final DateTime date;
  const taskDetail({super.key, required this.text, required this.detail, required this.date, required this.data, required this.document});

  @override
  State<taskDetail> createState() => _taskDetailState();
}

class _taskDetailState extends State<taskDetail> {
  final TextEditingController editController  = TextEditingController();
  final TextEditingController descController  = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
            AwesomeDialog(
                context: context,
                btnOkOnPress: () {
                  if (editController.text.isNotEmpty || descController.text.isNotEmpty) {
                    setState(() {
                      if(editController.text.isNotEmpty ){
                        widget.data['todo'] = editController.text;
                      }
                      if(descController.text.isNotEmpty) {
                        widget.data['detail'] = descController.text;
                      }
                      FirebaseFirestore.instance.collection(
                          'todos').doc(widget.document.id).update(
                          widget.data);
                      editController.clear();
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Task is edited!"),
                        )
                    );
                    Navigator.push(context, MaterialPageRoute(builder: (context) => homePageTodo()));
                  }
                },
                btnCancelOnPress: (){},
                body: Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Container(child: Text("You are editing:  "), padding: EdgeInsets.all(10),),
                      Container(
                        margin: EdgeInsets.all(10),
                        child: TextField(
                          controller: editController,
                          decoration: InputDecoration(
                            labelText: "New Task Title",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        child: TextFormField(
                          controller: descController,
                          maxLines: null,
                          decoration: InputDecoration(
                            labelText: "Task Details",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
            ).show();
          }, icon: Icon(Icons.edit)),
        ],
        centerTitle: true,
        title: Text("TO-DO LIST"),
        backgroundColor: Colors.deepOrange,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.text, style: TextStyle(fontSize:30),),
            Divider(thickness: 2,),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(widget.detail, style: TextStyle(fontSize: 20),),
                    ),
                  ],
                ),
              ),
            ),

            Divider(thickness: 2,),
            Visibility(visible:DateFormat('dd-MM-yyyy').format(widget.date) != "01-01-2001" ,child: Text("Due To: "+DateFormat('dd-MM-yyyy').format(widget.date), style: TextStyle(fontSize:20),)),
          ],
        ),
      )
    );
  }
}
