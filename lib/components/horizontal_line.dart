import 'package:flutter/material.dart';

class HorizontalLine extends StatelessWidget {
  final Color color;
  final double colorOpacity;
  final double height;
  const HorizontalLine({
    super.key,
    this.color = Colors.white,
    this.colorOpacity = 0.7,
    this.height = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: height,
      color: color.withOpacity(colorOpacity),
    );
  }
}
