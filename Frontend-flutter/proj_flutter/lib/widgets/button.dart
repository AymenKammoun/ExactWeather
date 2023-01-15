import 'package:flutter/material.dart';

Widget Button(
    {required String? title,
    required Function onPressed,
    double fontSize = 24.0}) {
  return Container(
    height: 50,
    width: 200,
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 169, 204, 227),
      borderRadius: BorderRadius.circular(15),
    ),
    child: TextButton(
      onPressed: () => onPressed(),
      child: Text(
        title!,
        style: TextStyle(
            color: const Color.fromARGB(255, 3, 5, 65), fontSize: fontSize),
      ),
    ),
  );
}
