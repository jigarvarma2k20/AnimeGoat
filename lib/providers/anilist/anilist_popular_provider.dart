import 'package:animegoat/models/anime_data.dart';
import 'package:animegoat/providers/anilist/anilist_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final anilistPopularProvider =
    FutureProvider.autoDispose<List<AnimeData>>((ref) async {
  int currentPage = 1;

  try {
    final anilist = ref.read(anilistServiceProvider);
    final data = await anilist.popular(page: currentPage);
    return AnimeData.fromDataJson(data);
  } catch (e) {
    print('Error: $e');
    throw Exception('Failed to fetch popular media');
  }
});
