import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class favoriteButton extends StatefulWidget {
  final DocumentSnapshot document;
  final Map<String, dynamic> data;
  final bool isFavorite;
  const favoriteButton({super.key, required this.data, required this.isFavorite, required this.document});

  @override
  State<favoriteButton> createState() => _favoriteButtonState();
}

class _favoriteButtonState extends State<favoriteButton> with SingleTickerProviderStateMixin{

  late final AnimationController _controller;

  void initState(){
    super.initState();
    double value;
    if(widget.isFavorite == false){
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
  void didUpdateWidget(covariant favoriteButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(widget.isFavorite == false){
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
            bool bookmark = widget.isFavorite;
            if(bookmark == false){
              bookmark = true;
              _controller.forward();
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Task is added to the favorites!"),
                    duration: Duration(milliseconds: 750),
                  )
              );
            }
            else{
              bookmark = false;
              _controller.reverse();
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Task is removed from the favorites section!"),
                    duration: Duration(milliseconds: 750),
                  )
              );
            }
            //bool isFavorite = !widget.isFavorite;
            Future.delayed(Duration(milliseconds: 850), (){
              widget.data['isFavorited'] = bookmark;
              FirebaseFirestore.instance.collection('todos').doc(widget.document.id).update(widget.data);
            });
          });
        },
        child: Lottie.asset(
            'images/animation2.json',
            controller: _controller,
            fit: BoxFit.cover
        ),
      ),
    );
  }
}
