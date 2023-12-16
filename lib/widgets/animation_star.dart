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
  bool bookmark =false;

  void initState(){
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

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
            if(bookmark == false){
              bookmark = true;
              _controller.forward();
            }
            else{
              bookmark = false;
              _controller.reverse();
            }
            bool isFavorite = !widget.isFavorite;
            widget.data['isFavorited'] = isFavorite;
            FirebaseFirestore.instance.collection('todos').doc(widget.document.id).update(widget.data);
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