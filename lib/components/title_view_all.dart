import 'package:flutter/material.dart';

class TitleViewAll extends StatelessWidget {
  final String title;
  final EdgeInsets padding;

  const TitleViewAll(
      {super.key,
      required this.title,
      this.padding = const EdgeInsets.only(left: 10, right: 10, top: 10)});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          const Text("View All",
              style: TextStyle(color: Color.fromARGB(255, 74, 37, 209))),
        ],
      ),
    );
  }
}
