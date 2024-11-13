import 'package:animegoat/styles/custom_styles.dart';
import 'package:flutter/material.dart';

class HeadAndText extends StatelessWidget {
  final String head;
  final String text;
  const HeadAndText({
    super.key,
    required this.head,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 15, right: 20),
      child: Text.rich(
        overflow: TextOverflow.ellipsis,
        maxLines: 4,
        TextSpan(
          children: [
            TextSpan(
              text: "$head : ",
              style: headLine.copyWith(fontSize: 14),
            ),
            TextSpan(
              text: text,
            ),
          ],
        ),
      ),
    );
  }
}
