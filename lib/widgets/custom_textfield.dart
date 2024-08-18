import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  const CustomTextfield(
      {super.key,
      required this.onPressed,
      required this.color,
      required this.textLabel});
  final TextEditingController? onPressed;
  final Color color;
  final Text textLabel;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: onPressed,
      decoration: InputDecoration(
        labelText: textLabel.data!,
        labelStyle: TextStyle(color: color),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(10.0),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      ),
      style: TextStyle(color: color),
    );
  }
}
