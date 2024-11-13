import 'package:flutter/material.dart';

class TextIconButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function onTap;
  const TextIconButton({
    super.key,
    required this.onTap,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
            width: 1.2,
          ),
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon),
            const SizedBox(width: 5),
            Text(text),
            const SizedBox(width: 5)
          ],
        ),
      ),
    );
  }
}
