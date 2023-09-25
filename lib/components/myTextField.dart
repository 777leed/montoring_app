import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final bool obs;
  final TextEditingController controller;
  final String hint;
  const MyTextField(
      {super.key,
      required this.obs,
      required this.controller,
      required this.hint});

  @override
  Widget build(BuildContext context) {
    return TextField(
        obscureText: obs,
        controller: controller,
        decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.all(14),
            hintText: hint,
            fillColor: Colors.grey.shade50,
            filled: true,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.grey.shade400)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.black))));
  }
}
