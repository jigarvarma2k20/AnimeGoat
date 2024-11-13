import 'package:flutter/material.dart';

class EpisodeButton extends StatelessWidget {
  final int episodeId;
  final Function() onTap;
  final bool isWatching;

  const EpisodeButton({
    super.key,
    required this.episodeId,
    required this.onTap,
    this.isWatching = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: isWatching ? Colors.blue.withOpacity(0.5) : Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
        ),
        height: 40,
        width: double.infinity,
        padding: const EdgeInsets.all(5),
        alignment: Alignment.center,
        child: Text("Episode $episodeId"),
      ),
    );
  }
}
