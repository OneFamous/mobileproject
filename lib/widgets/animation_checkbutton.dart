import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class checkButton extends StatefulWidget {
  final DocumentSnapshot document;
  final Map<String, dynamic> data;
  final bool isCompleted;
  const checkButton({super.key, required this.data, required this.isCompleted, required this.document});

  @override
  State<checkButton> createState() => _checkButtonState();
}

class _checkButtonState extends State<checkButton> with SingleTickerProviderStateMixin{

  late final AnimationController _controller;

  void initState(){
    super.initState();
    double value;
    if(widget.isCompleted == false){
      value=0;
    }else{
      value=5;
    }
    _controller = AnimationController(
      value: value,
      vsync: this,
      duration: Duration(seconds: 1),
    );
  }

  @override
  void didUpdateWidget(covariant checkButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(widget.isCompleted == false){
      _controller.value=0;
    }else{
      _controller.value=5;
    }
  }

  void dispose(){
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      width: 35,
      height: 35,
      child: GestureDetector(
        onTap: (){
          setState(() {
            bool bookmark = widget.isCompleted;
            if(bookmark == false){
              bookmark = true;
              _controller.forward();
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Task is completed!"),
                    duration: Duration(milliseconds: 750),
                    backgroundColor: Colors.green,
                  )
              );
            }
            else{
              bookmark = false;
              _controller.reverse();
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Task is removed from completed section!"),
                    duration: Duration(milliseconds: 750),
                  )
              );
            }
            //bool isFavorite = !widget.isFavorite;
            Future.delayed(Duration(milliseconds: 850), (){
              widget.data['isCompleted'] = bookmark;
              FirebaseFirestore.instance.collection('todos').doc(widget.document.id).update(widget.data);
            });
          });
        },
        child: Lottie.asset(
            'images/animation_check2.json',
            controller: _controller,
            fit: BoxFit.cover
        ),
      ),
    );
  }
}
