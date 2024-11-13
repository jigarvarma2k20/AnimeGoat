import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageFrame extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final Color frameColor;
  const ImageFrame({
    super.key,
    required this.imageUrl,
    this.width = 200,
    this.height = 300,
    this.frameColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                width: width,
                height: height,
              ),
            ),
          ],
        ));
  }
}
