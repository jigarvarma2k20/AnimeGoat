import 'package:animegoat/models/anime_data.dart';
import 'package:animegoat/providers/anilist/anilist_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final anilistGenreProvider =
    FutureProvider.family<List<AnimeData>, String>((ref, genre) async {
  final anilist = ref.read(anilistServiceProvider);
  final data = await anilist.advanceSearch(genre: genre, page: 1);
  return AnimeData.fromDataJson(data);
});
