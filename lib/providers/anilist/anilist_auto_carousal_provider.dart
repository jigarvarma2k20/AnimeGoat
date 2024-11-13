import 'dart:async';
import 'package:animegoat/models/anime_data.dart';
import 'package:animegoat/providers/anilist/anilist_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnilistAutoCarousal extends StateNotifier<AnimeData?> {
  AnilistAutoCarousal(super._state, this.ref) {
    fetchTrending();
    _autoNext();
  }

  final Ref ref;
  int _currentIndex = 0;
  final List<AnimeData> _data = [];
  late Timer _timer;

  int get currentIndex => _currentIndex + 1;

  Future<void> fetchTrending() async {
    if (_data.isEmpty) {
      final data = await ref.read(anilistServiceProvider).trending();
      final List media = data['Page']['media'];
      _data.addAll(media.map((e) => AnimeData.fromJson(e)));
      state =
          _data.isNotEmpty ? _data[_currentIndex] : null; // Set initial state
    }
  }

  void next() {
    if (_data.isEmpty) return;
    _currentIndex = (_currentIndex + 1) % 10;
    state = _data[_currentIndex];
  }

  void previous() {
    if (_data.isEmpty) return;
    _currentIndex = (_currentIndex - 1) % 10;
    state = _data[_currentIndex];
  }

  void _autoNext() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      next();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }
}

final anilistAutoCarousalProvider =
    StateNotifierProvider.autoDispose<AnilistAutoCarousal, AnimeData?>(
        (ref) => AnilistAutoCarousal(null, ref));
