import 'package:flutter/material.dart';

const TextStyle whiteTextOnimage = TextStyle(
  color: Colors.white,
  fontSize: 12,
  fontWeight: FontWeight.bold,
);

const TextStyle headLine = TextStyle(
  color: Colors.white,
  fontSize: 24,
  fontWeight: FontWeight.bold,
  shadows: [
    Shadow(
      color: Colors.black,
      offset: Offset(1, 1),
      blurRadius: 5,
    ),
  ],
  overflow: TextOverflow.ellipsis,
);

const TextStyle smallDescription =
    TextStyle(fontSize: 12, overflow: TextOverflow.ellipsis);
