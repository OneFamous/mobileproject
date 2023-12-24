import 'package:flutter/material.dart';


class taskDetail extends StatefulWidget {
  final String text;
  final String detail;
  const taskDetail({super.key, required this.text, required this.detail});

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
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Text(widget.text + widget.detail),
      ),
    );
  }
}
