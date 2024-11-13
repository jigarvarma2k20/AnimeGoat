import 'package:animegoat/components/item_card.dart';
import 'package:animegoat/components/sliding_card.dart';
import 'package:animegoat/components/title_view_all.dart';
import 'package:animegoat/pages/anime_page.dart';
import 'package:animegoat/pages/search_page.dart';
import 'package:animegoat/providers/anilist/anilist_auto_carousal_provider.dart';
import 'package:animegoat/providers/anilist/anilist_popular_provider.dart';
import 'package:animegoat/providers/anilist/anilist_recents_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
          title: const Text("AnimeGoat"),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchPage(),
                  ),
                );
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Consumer(
                builder: (context, ref, child) {
                  final carouselAnimeRead =
                      ref.read(anilistAutoCarousalProvider.notifier);
                  final carouselAnime = ref.watch(anilistAutoCarousalProvider);
                  return Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AnimePage(
                                        animeData: carouselAnime,
                                      )));
                        },
                        onHorizontalDragEnd: (details) {
                          if (details.primaryVelocity! > 0) {
                            carouselAnimeRead.previous();
                          } else {
                            carouselAnimeRead.next();
                          }
                        },
                        child: SlidingCard(
                          animeData: carouselAnime,
                          index: carouselAnimeRead.currentIndex,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => ref
                                .read(anilistAutoCarousalProvider.notifier)
                                .previous(),
                            child: const Icon(
                              Icons.navigate_before,
                              size: 60,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => ref
                                .read(anilistAutoCarousalProvider.notifier)
                                .next(),
                            child: const Icon(
                              Icons.navigate_next,
                              size: 60,
                            ),
                          ),
                        ],
                      )
                    ],
                  );
                },
              ),
              const TitleViewAll(title: "Popular Anime"),
              Consumer(builder: (context, ref, child) {
                final popular = ref.watch(anilistPopularProvider);
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: popular.when(
                    data: (data) => Row(
                      children: List.generate(
                          data.length,
                          (index) => ItemCard(
                                animeData: data[index],
                              )),
                    ),
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    error: (error, stack) => Center(
                      child: Text(error.toString()),
                    ),
                  ),
                );
              }),
              const TitleViewAll(title: "Recent Release"),
              Consumer(builder: (context, ref, child) {
                final recents = ref.watch(anilistRecentsProvider);
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: recents.when(
                    data: (data) => Row(
                      children: List.generate(
                          data.length,
                          (index) => ItemCard(
                                animeData: data[index],
                              )),
                    ),
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    error: (error, stack) => Center(
                      child: Text(error.toString()),
                    ),
                  ),
                );
              }),
            ],
          ),
        ));
  }
}
