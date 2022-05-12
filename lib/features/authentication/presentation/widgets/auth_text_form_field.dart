import 'package:flutter/material.dart';

class AuthTextFormField extends StatelessWidget {
  final String hint;
  final bool obscureText;
  final Widget icon;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  const AuthTextFormField({
    Key? key,
    required this.hint,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    required this.icon,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Center(
        child: TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter your $hint';
            }
            return null;
          },
          keyboardType: keyboardType,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            prefixIcon: icon,
            focusedErrorBorder: InputBorder.none,
            errorBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
