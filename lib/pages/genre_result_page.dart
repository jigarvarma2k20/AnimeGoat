import 'package:animegoat/components/list_item_card.dart';
import 'package:animegoat/providers/anilist/anilist_genre_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GenreResultPage extends ConsumerWidget {
  final String genre;
  const GenreResultPage({super.key, required this.genre});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final genreSearch = ref.watch(anilistGenreProvider(genre));
    return Scaffold(
      appBar: AppBar(
        title: Text(genre),
      ),
      body: genreSearch.when(
        data: (data) => SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: List.generate(
                data.length, (index) => ListItemCard(animeData: data[index])),
          ),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}
