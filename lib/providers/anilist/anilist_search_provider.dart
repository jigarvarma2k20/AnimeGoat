import 'package:animegoat/models/anime_data.dart';
import 'package:animegoat/providers/anilist/anilist_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnilistSearchNotifier extends StateNotifier<List<AnimeData>> {
  Ref ref;
  int currentPage = 1;
  AnilistSearchNotifier({required this.ref}) : super([]);

  void clear() {
    state = [];
  }

  Future<void> search(String query) async {
    if (query.isEmpty || query.length < 3) {
      return;
    }

    try {
      final anilist = ref.read(anilistServiceProvider);
      final data = await anilist.advanceSearch(query: query, page: currentPage);
      state = AnimeData.fromDataJson(data);
    } catch (e) {
      print('Error: $e');
    }
  }
}

final anilistSearchProvider =
    StateNotifierProvider<AnilistSearchNotifier, List<AnimeData>>((ref) {
  return AnilistSearchNotifier(ref: ref);
});
