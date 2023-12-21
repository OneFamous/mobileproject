import 'package:flutter/material.dart';
import 'package:mobileproject/NavBar.dart';

class taskDetail extends StatefulWidget {
  final String text;
  const taskDetail({super.key, required this.text});

  @override
  State<taskDetail> createState() => _taskDetailState();
}

class _taskDetailState extends State<taskDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("TO-DO LIST"),
        backgroundColor: Colors.deepOrange,
      ),
      drawer: NavBar(),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Text(widget.text),
      ),
    );
  }
}
