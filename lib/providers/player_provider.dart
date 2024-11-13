import 'package:animegoat/models/stream_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StreamTrackNotifier extends StateNotifier<StreamTrack?> {
  StreamTrackNotifier() : super(null);

  set setStreamData(StreamTrack? streamTrack) => state = streamTrack;
}

final streamTrackProvider =
    StateNotifierProvider<StreamTrackNotifier, StreamTrack?>((ref) {
  return StreamTrackNotifier();
});
