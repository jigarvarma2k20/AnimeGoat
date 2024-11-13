class StreamId {
  final String dub;
  final String sub;

  StreamId({
    required this.dub,
    required this.sub,
  });

  factory StreamId.fromJson(Map<String, dynamic> json) {
    // This is a bit of a hacky way to get the stream id from the json
    Map<String, String> streams = {};
    for (var key in json.keys) {
      if (key.contains("dub")) {
        streams["dub"] = key;
      } else {
        streams["sub"] = key;
      }
    }
    return StreamId(
      dub: streams['dub'] ?? '',
      sub: streams['sub'] ?? '',
    );
  }
}

class SubtitleTrack {
  final String label;
  final String lang;
  final String url;

  SubtitleTrack({
    required this.label,
    required this.lang,
    required this.url,
  });
}

class StreamTrack {
  final String link;
  final String quality;

  StreamTrack({
    required this.link,
    required this.quality,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StreamTrack && link == other.link;
  }

  @override
  int get hashCode => link.hashCode ^ quality.hashCode;
}

class StreamData {
  final List<StreamTrack> subTracks;
  final List<StreamTrack> dubTracks;
  final List<SubtitleTrack> subtitleTracks;

  StreamData({
    required this.subTracks,
    required this.dubTracks,
    required this.subtitleTracks,
  });
}
