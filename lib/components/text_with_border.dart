import 'package:flutter/material.dart';

class TextWithBorder extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color backgroundColor;
  final bool showBorder;
  final double fontSize;
  final EdgeInsetsGeometry padding;

  const TextWithBorder({
    super.key,
    required this.text,
    this.textColor = Colors.white,
    this.backgroundColor = Colors.transparent,
    this.showBorder = true,
    this.fontSize = 12,
    this.padding = const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: showBorder
            ? Border.all(
                color: Colors.white,
                width: 1.5,
              )
            : null,
        color: backgroundColor,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
