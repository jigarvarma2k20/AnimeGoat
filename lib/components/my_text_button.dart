import 'package:flutter/material.dart';

class MyTextButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;
  final Color color;
  final Color activeColor;
  final Color textColor;
  final Color activeTextColor;
  final bool isActive;
  const MyTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = Colors.grey,
    this.activeColor = Colors.blue,
    this.textColor = Colors.black,
    this.activeTextColor = Colors.white,
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isActive ? activeColor : color,
        ),
        child: Text(
          text,
          overflow: TextOverflow.fade,
          style: TextStyle(
            color: isActive ? activeTextColor : textColor,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
