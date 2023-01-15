import 'package:flutter/material.dart';

Widget Input(
    {TextEditingController? controller,
    required String title,
    String? errorText,
    bool password = false,
    bool enabled = true,
    bool isObscure = false,
    Function? onShow,
    Widget? prefixIcon}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    child: TextField(
      enabled: enabled,
      obscureText: isObscure,
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: password
            ? IconButton(
                onPressed: () {
                  onShow!();
                },
                icon: Icon(isObscure ? Icons.visibility : Icons.visibility_off))
            : null,
        filled: true,
        fillColor: const Color.fromARGB(255, 240, 240, 242),
        border: const OutlineInputBorder(
            borderSide: BorderSide(style: BorderStyle.none),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          backgroundColor: Color.fromARGB(255, 240, 240, 242),
        ),
        hintText: title,
        errorText: errorText,
      ),
    ),
  );
}
