import 'package:animegoat/components/circle_dot.dart';
import 'package:animegoat/components/on_image_text.dart';
import 'package:animegoat/models/anime_data.dart';
import 'package:animegoat/pages/anime_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  final AnimeData animeData;
  const ItemCard({super.key, required this.animeData});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.5;
    double height = width * 1.7;
    height = height > 210 ? 210 : height;
    width = width > 145 ? 145 : width;
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AnimePage(
                      animeData: animeData,
                    )));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color.fromARGB(255, 68, 68, 62),
        ),
        height: height,
        width: width,
        margin: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Align(
                    alignment: Alignment.center,
                    heightFactor: 0.8,
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: animeData.coverImg?.large ??
                          animeData.coverImg?.medium ??
                          "",
                      width: width,
                      height: height - 15,
                    ),
                  ),
                  //Show the rating and epsiode count in the bottom of the image
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OnImageText(
                        text: "${animeData.averageScore}/10",
                        color: Colors.pink,
                        bgOpacity: 0.7,
                      ),
                      OnImageText(
                        text: "Ep ${animeData.episodes}",
                        bgOpacity: 0.7,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5, top: 5),
              child: Text(
                animeData.title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5, top: 8),
              child: Row(
                children: [
                  Text(animeData.type,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      )),
                  const CircleDot(),
                  Text(animeData.status,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      )),
                  //   const CircleDot(),
                  //   Text(animeData.year,
                  //       style: const TextStyle(
                  //         color: Colors.white,
                  //         fontSize: 10,
                  //       )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
