import 'package:animegoat/components/on_image_text.dart';
import 'package:animegoat/models/anime_data.dart';
import 'package:animegoat/styles/custom_styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SlidingCard extends StatelessWidget {
  final AnimeData? animeData;
  final int index;

  const SlidingCard({
    super.key,
    required this.animeData,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 3,
            spreadRadius: 3,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: animeData == null
          ? const Center(
              child: SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(),
              ),
            )
          : Stack(
              alignment: Alignment.topLeft,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: animeData!.bannerUrl.isNotEmpty
                        ? animeData!.bannerUrl
                        : animeData!.coverImg!.extraLarge ?? "",
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "#$index Spotlight",
                        style: const TextStyle(color: Colors.white),
                      ),
                      Text(
                        animeData!.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const SizedBox(
                            width: 5,
                          ),
                          const Icon(Icons.play_circle_fill),
                          Text(animeData!.type, style: whiteTextOnimage),
                          const SizedBox(width: 10),
                          const Icon(Icons.calendar_month),
                          Text(animeData!.status, style: whiteTextOnimage),
                          const SizedBox(width: 10),
                          OnImageText(
                            text: animeData!.genre,
                            bgColor: Colors.white,
                            color: const Color.fromARGB(255, 54, 54, 54),
                            bgOpacity: 0.7,
                            boldFont: false,
                          ),
                        ],
                      ),
                      Text(
                        animeData!.description,
                        maxLines: 3,
                        style: whiteTextOnimage.copyWith(
                          color: Colors.white,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
