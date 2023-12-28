
import 'package:flutter/material.dart';

import '../controllers/todo_controller.dart';

class openAlertDialog extends StatefulWidget {
  const openAlertDialog({super.key});
  @override
  State<openAlertDialog> createState() => _openAlertDialogState();
}

class _openAlertDialogState extends State<openAlertDialog> {
  DateTime? _date = DateTime(2001) ;
  final fireStore database = fireStore();
  final TextEditingController descController  = TextEditingController();
  final TextEditingController textController  = TextEditingController();

  void addTodo(){
    if(textController.text.isNotEmpty){
      database.addTodo(textController.text, descController.text, _date);
      textController.clear();
      descController.clear();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            child: TextField(
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                labelText: "Task Title",
                border: OutlineInputBorder(),
              ),
              controller:textController,
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
          Container(
            margin: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(onPressed: () {
                  showDatePicker(
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: ThemeData(
                          primarySwatch: Colors.deepOrange,
                        ),
                        child: child!,
                      );
                    },
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate:DateTime.now(),
                    lastDate:DateTime(2026),
                  ).then((value){
                    _date = value;
                    if(_date != null){
                      showTimePicker(context: context,
                          builder: (BuildContext context, Widget? child) {
                            return Theme(
                              data: ThemeData(
                                primarySwatch: Colors.deepOrange,
                              ),
                              child: child!,
                            );
                          },
                          initialTime: TimeOfDay(hour: 5, minute: 30)).then((value) {
                            if(value != null){
                              _date = DateTime(_date!.year, _date!.month, _date!.day, value.hour, value.minute);
                            }
                            else{
                              _date = DateTime(2001);
                            }
                      });
                    }
                  });

                },
                  child: Text("Reminder", style: TextStyle(color: Colors.black),),
                  style: ButtonStyle(backgroundColor:MaterialStateProperty.all<Color?>(Colors.deepOrange[200]) ),
                ),
                ElevatedButton(onPressed: addTodo, child: Text("Add", style: TextStyle(color: Colors.black)), style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color?>(Colors.deepOrange[200])),),
              ],
            ),
          )
        ],
      )
    );
  }
}
