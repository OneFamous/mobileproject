import 'package:flutter/material.dart';

class favorite_page extends StatefulWidget {
  const favorite_page({super.key});

  @override
  State<favorite_page> createState() => _favorite_pageState();
}

class _favorite_pageState extends State<favorite_page> {
  @override
  Widget build(BuildContext context) {
    return Center(child: const Text("Favorites"));
  }
}
