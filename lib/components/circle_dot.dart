import 'package:flutter/material.dart';

class CircleDot extends StatelessWidget {
  final double size;
  final Color color;
  final double horizontalPadding;
  const CircleDot({
    super.key,
    this.size = 5,
    this.color = Colors.white,
    this.horizontalPadding = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Icon(Icons.circle_sharp, color: color, size: size),
    );
  }
}
