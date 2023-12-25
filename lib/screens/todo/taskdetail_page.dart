import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class taskDetail extends StatefulWidget {
  final String text;
  final String detail;
  final DateTime date;
  const taskDetail({super.key, required this.text, required this.detail, required this.date});

  @override
  State<taskDetail> createState() => _taskDetailState();
}

class _taskDetailState extends State<taskDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.calendar_month)),
        ],
        centerTitle: true,
        title: Text("TO-DO LIST"),
        backgroundColor: Colors.deepOrange,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text(widget.text, style: TextStyle(fontSize:30),),
            Divider(thickness: 2,),
            Wrap(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(widget.detail, style: TextStyle(fontSize: 20),),
                ),
              ],
            ),

            Divider(thickness: 2,),
            Visibility(visible:DateFormat('dd-MM-yyyy').format(widget.date) != "01-01-2001" ,child: Text("Due To: "+DateFormat('dd-MM-yyyy').format(widget.date), style: TextStyle(fontSize:20),)),
          ],
        ),
      )
    );
  }
}
