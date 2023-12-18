import 'package:flutter/material.dart';

class AddAndDeleteTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;

  const AddAndDeleteTextField({
    Key? key,
    required this.controller,
    required this.labelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).colorScheme.secondary,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 3.0),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 3.0),
        ),
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.black),
      ),
      maxLines: null,
    );
  }
}
