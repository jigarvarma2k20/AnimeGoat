import 'package:flutter/material.dart';

class OnImageText extends StatelessWidget {
  final String text;
  final Color color;
  final Color bgColor;
  final BorderRadius borderRadius;
  final double bgOpacity;
  final bool boldFont;
  const OnImageText({
    super.key,
    required this.text,
    this.color = Colors.black,
    this.bgColor = Colors.white,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.bgOpacity = 1,
    this.boldFont = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(bgOpacity),
        borderRadius: borderRadius,
      ),
      child: Text(text,
          maxLines: 1,
          style: TextStyle(
            color: color,
            fontWeight: boldFont ? FontWeight.bold : FontWeight.normal,
            overflow: TextOverflow.ellipsis,
          )),
    );
  }
}
