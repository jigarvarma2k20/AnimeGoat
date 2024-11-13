import 'dart:ui';

import 'package:animegoat/components/circle_dot.dart';
import 'package:animegoat/components/head_and_text.dart';
import 'package:animegoat/components/horizontal_line.dart';
import 'package:animegoat/components/image_frame.dart';
import 'package:animegoat/components/text_icon_button.dart';
import 'package:animegoat/components/text_with_border.dart';
import 'package:animegoat/components/title_view_all.dart';
import 'package:animegoat/models/anime_data.dart';
import 'package:animegoat/pages/play_page.dart';
import 'package:animegoat/styles/custom_styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnimePage extends ConsumerWidget {
  final AnimeData? animeData;
  const AnimePage({super.key, required this.animeData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AnimeGoat"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                //Blurred Image
                ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: CachedNetworkImage(
                    imageUrl:
                        animeData!.coverImg!.large ?? animeData!.bannerUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                Column(
                  children: [
                    ImageFrame(
                        imageUrl:
                            animeData!.coverImg!.large ?? animeData!.bannerUrl),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: Text(
                        animeData!.title,
                        maxLines: 1,
                        style: headLine,
                      ),
                    ),

                    //Tags and Ratings
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextWithBorder(text: animeData!.genre),
                        const CircleDot(),
                        TextWithBorder(text: animeData!.type),
                        const CircleDot(),
                        TextWithBorder(text: '${animeData!.averageScore}/10'),
                        const CircleDot(),
                        TextWithBorder(text: animeData!.status),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextIconButton(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PlayPage(
                                      animeData: animeData,
                                    )));
                      },
                      text: "Watch Now",
                      icon: Icons.play_arrow,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 50),
            // HeadAndText(
            //   head: "Name",
            //   text: animeData!.title,
            // ),
            HeadAndText(
              head: "Overview",
              text: animeData!.description,
            ),
            HeadAndText(
              head: "Other Names",
              text: animeData!.allTitles.join(", "),
            ),
            HeadAndText(
              head: "Episodes",
              text: animeData!.episodes.toString(),
            ),
            HeadAndText(
              head: "Release Year",
              text: animeData!.year.toString(),
            ),
            HeadAndText(
              head: "Type",
              text: animeData!.type,
            ),
            HeadAndText(
              head: "Status",
              text: animeData!.status,
            ),
            HeadAndText(
              head: "Studios",
              text: animeData!.studios.join(", "),
            ),
            HeadAndText(
              head: "Genres",
              text: animeData!.genres.join(", "),
            ),
            const SizedBox(height: 10),
            const HorizontalLine(),
            const TitleViewAll(title: "Recent Release"),
          ],
        ),
      ),
    );
  }
}
