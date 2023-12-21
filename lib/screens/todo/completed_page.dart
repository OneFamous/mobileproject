import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
                      String todoText = data['todo'];
                      bool isChecked = data['isCompleted'];
                      return ListTile(
                          trailing: checkButton(data: data, isCompleted: isChecked, document: document),
                          title: GestureDetector(
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
            )
        )
      ],
    );
  }
}
