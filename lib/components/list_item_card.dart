import 'package:animegoat/components/text_with_border.dart';
import 'package:animegoat/models/anime_data.dart';
import 'package:animegoat/pages/anime_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ListItemCard extends StatelessWidget {
  final AnimeData animeData;
  const ListItemCard({
    super.key,
    required this.animeData,
  });

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width * 0.65;
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
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: const Color.fromARGB(207, 0, 0, 0),
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.black,
                blurRadius: 5,
                offset: Offset(0, 2),
              )
            ]),
        padding: const EdgeInsets.all(5),
        height: 130,
        child: Row(
          children: [
            Column(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: animeData.coverImg!.medium!,
                  width: 85,
                  height: 120,
                ),
              ),
            ]),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: maxWidth,
                  child: Text(
                    animeData.title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    animeData.year == "Unknown"
                        ? const SizedBox()
                        : TextWithBorder(
                            text: animeData.year,
                            fontSize: 10,
                            textColor: Colors.grey,
                            backgroundColor:
                                const Color.fromARGB(255, 39, 38, 38),
                            showBorder: false,
                            padding: const EdgeInsets.all(5),
                          ),
                    animeData.year == "Unknown"
                        ? const SizedBox()
                        : const SizedBox(
                            width: 5,
                          ),
                    animeData.genre == "Unknown"
                        ? const SizedBox()
                        : TextWithBorder(
                            text: animeData.genre,
                            fontSize: 10,
                            textColor: Colors.grey,
                            backgroundColor:
                                const Color.fromARGB(255, 39, 38, 38),
                            showBorder: false,
                            padding: const EdgeInsets.all(5),
                          ),
                    animeData.genre == "Unknown"
                        ? const SizedBox()
                        : const SizedBox(
                            width: 5,
                          ),
                    TextWithBorder(
                      text: animeData.type,
                      fontSize: 10,
                      textColor: Colors.grey,
                      backgroundColor: const Color.fromARGB(255, 39, 38, 38),
                      showBorder: false,
                      padding: const EdgeInsets.all(5),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    TextWithBorder(
                      text: animeData.status,
                      fontSize: 10,
                      textColor: Colors.grey,
                      backgroundColor: const Color.fromARGB(255, 39, 38, 38),
                      showBorder: false,
                      padding: const EdgeInsets.all(5),
                    ),
                  ],
                ),
                Text(
                  "Rating: ${animeData.averageScore} / 10",
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
                animeData.episodes == 1
                    ? const SizedBox()
                    : Text(
                        "Episodes: ${animeData.episodes}",
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                SizedBox(
                  width: maxWidth,
                  child: Text(
                    animeData.description,
                    maxLines: animeData.episodes == 1 ? 4 : 3,
                    style: const TextStyle(
                        fontSize: 8.5,
                        overflow: TextOverflow.ellipsis,
                        color: Colors.grey),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
