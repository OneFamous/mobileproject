import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../controllers/todo_controller.dart';


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
                      return CheckboxListTile(
                          value: isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              data['isCompleted'] = value!;
                              FirebaseFirestore.instance.collection('todos').doc(document.id).update(data);
                            });
                          },
                          title: Container(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right:30),
                                    child: GestureDetector(
                                      onTap: (){},
                                      child: Icon(Icons.star_border_outlined),
                                    ),
                                  ),
                                  Expanded(child: Text(todoText)),
                                ],
                              )
                          )
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
