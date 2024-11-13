import 'package:animegoat/components/list_item_card.dart';
import 'package:animegoat/providers/anilist/anilist_search_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchPage extends ConsumerWidget {
  SearchPage({super.key});
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          onChanged: (value) {
            if (value.isEmpty || value.length < 3) {
              return;
            }
            ref.read(anilistSearchProvider.notifier).search(value);
          },
          decoration: InputDecoration(
            // prefixIcon: const Icon(Icons.search),
            suffixIcon: GestureDetector(
              onTap: () {
                _searchController.clear();
                ref.read(anilistSearchProvider.notifier).clear();
              },
              child: const Icon(Icons.clear),
            ),
            hintText: "Search Anime",
            border: const UnderlineInputBorder(),
          ),
        ),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final searchItems = ref.watch(anilistSearchProvider);
          return searchItems.isEmpty
              ? const Center(
                  child: Text(
                    "Type the name of the anime you want to search",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                )
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: List.generate(searchItems.length,
                        (index) => ListItemCard(animeData: searchItems[index])),
                  ),
                );
        },
      ),
    );
  }
}
