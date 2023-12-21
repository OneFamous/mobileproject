import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:mobileproject/screens/todo/taskdetail_page.dart';
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

  void addTodo(){
    if(textController.text.isNotEmpty){
      database.addTodo(textController.text);
    }
    textController.clear();
  }

  void openDialog (){
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: TextField(
            controller: textController,
          ),
          actions: [
            ElevatedButton(
              onPressed: addTodo,
              child: Text("Add"),
            )
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: database.getTodoStream(),
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
                    String todoText = data['todo'];
                    bool isChecked = data['isCompleted'];
                    bool isFavorite = data['isFavorited'];
                    return ListTile(
                      leading:  favoriteButton(data: data, isFavorite: isFavorite, document: document,),
                      trailing: checkButton(data: data, isCompleted: isChecked, document: document),
                      title:GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => taskDetail(text: todoText,)));
                        },
                        child: Expanded(
                          child:  Container(
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
          ),
        ),

        Container(
          margin: EdgeInsets.only(right: 20, bottom: 15, top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                onPressed: openDialog,
                backgroundColor: Colors.orange,
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
