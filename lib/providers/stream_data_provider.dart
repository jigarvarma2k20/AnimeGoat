import 'dart:convert';

import 'package:animegoat/models/anime_data.dart';
import 'package:animegoat/models/stream_data.dart';
import 'package:animegoat/providers/player_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

//Todo: rewrite this provider using StateNotifier
class StreamDataNotifier extends ChangeNotifier {
  final String streamApi = "https://api-amvstr-me.vercel.app";
  final String malSyncApi = "https://api.malsync.moe";
  final http.Client client = http.Client();
  int _currentEp = 1;
  bool _tried = true;
  bool isLoaded = false;
  StreamId? _streamId;
  AnimeData? _animeData;
  StreamData? _streamData;

  AnimeData? get animeData => _animeData;
  StreamData? get streamData => _streamData;
  int get currentEp => _currentEp;
  bool get tried => _tried;

  late Ref ref;

  StreamDataNotifier({required this.ref});

  Future<void> setData(AnimeData animeData, int currentEp) async {
    _animeData = animeData;
    _currentEp = currentEp;
    _streamId = _animeData!.streamId;
    if (_streamId == null) {
      await getMalSyncData();
    }
    isLoaded = false;
    _tried = false;
    notifyListeners();
  }

  Future<Map<String, dynamic>> getJsonData(String url) async {
    final response = await client.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return {};
  }

  Future<void> getMalSyncData() async {
    if (_animeData == null) throw "Anime data is null";
    final response =
        await getJsonData("$malSyncApi/mal/anime/${_animeData?.idMal}");
    if (response.isEmpty) return;
    if (response.keys.contains("code")) throw "Error: ${response['message']}";
    if (!response["Sites"].containsKey("Gogoanime")) return;
    _streamId = StreamId.fromJson(response["Sites"]["Gogoanime"]);
  }

  Future<List<StreamTrack>?> getStreamData({bool getDub = false}) async {
    if (_streamId == null || (getDub && _streamId!.dub.isEmpty)) return null;
    final response = await getJsonData(
        "$streamApi/api/v2/stream/${getDub ? _streamId?.dub : _streamId?.sub}-episode-$_currentEp");
    if (response.isEmpty) return null;
    if (response.keys.contains("error")) return null;
    List<StreamTrack> tracks = [];
    response["stream"]["multi"].forEach((key, value) {
      if (value["url"].isNotEmpty) {
        tracks.add(StreamTrack(link: value["url"], quality: value["quality"]));
      }
    });
    return tracks;
  }

  Future<void> getStreamDataList() async {
    if (_streamId != null && !isLoaded) {}
    {
      final subTracks = await getStreamData();
      final dubTracks = await getStreamData(getDub: true);

      _streamData = StreamData(
        subTracks: subTracks ?? [],
        dubTracks: dubTracks ?? [],
        subtitleTracks: [], // TODO: Add external subtitle tracks
      );
      _animeData = _animeData!.copyWith(streamId: _streamId);
      if (_streamData?.subTracks.isNotEmpty ?? false) {
        ref.read(streamTrackProvider.notifier).setStreamData =
            (_streamData?.subTracks[0]);
      } else if (_streamData?.dubTracks.isNotEmpty ?? false) {
        ref.read(streamTrackProvider.notifier).setStreamData =
            (_streamData?.dubTracks[0]);
      } else {
        ref.read(streamTrackProvider.notifier).setStreamData = null;
      }
      //   isLoaded = true;
    }
    // Just to make sure if no stream data is found, it will not try again to get the data
    _tried = true;
    if (isLoaded) {
      return;
    }
    if (_streamData != null && !isLoaded) {
      isLoaded = true;
    }

    notifyListeners();
  }
}

final streamDataProvider = ChangeNotifierProvider<StreamDataNotifier>((ref) {
  return StreamDataNotifier(ref: ref);
});
