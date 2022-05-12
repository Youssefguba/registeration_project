import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final Color color;
  final String text;
  final VoidCallback onPressed;

  const AuthButton({
    Key? key,
    required this.color,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: color,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              offset: const Offset(0, 6),
              blurRadius: 10,
              spreadRadius: 1
            )
          ],
        ),
        child: Center(
          child: Text(
            text,
            textScaleFactor: 1.2,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
