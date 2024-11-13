import 'package:animegoat/models/stream_data.dart';

class CoverImage {
  final String? large;
  final String? medium;
  final String? extraLarge;

  CoverImage({this.large, this.medium, this.extraLarge});

  factory CoverImage.fromJson(Map<String, dynamic> json) {
    return CoverImage(
      large: json['large'] ?? "",
      medium: json['medium'] ?? "",
      extraLarge: json['extraLarge'] ?? "",
    );
  }
}

class AnimeData {
  final String id;
  final String idMal;
  final String title;
  final List<String> allTitles;
  CoverImage? coverImg;
  final String bannerUrl;
  final String description;
  final String season;
  final String year;
  final String type;
  final String status;
  final int episodes;
  final String genre;
  final List<String> genres;
  final String averageScore;
  final List<String> studios;
  StreamId? streamId;

  AnimeData({
    required this.id,
    required this.idMal,
    required this.title,
    required this.allTitles,
    CoverImage? coverImg,
    required this.bannerUrl,
    required this.description,
    required this.season,
    required this.year,
    required this.type,
    required this.status,
    required this.episodes,
    required this.genre,
    required this.genres,
    required this.averageScore,
    required this.studios,
    StreamId? streamId,
  }) : coverImg = coverImg ?? CoverImage();

  factory AnimeData.fromJson(Map<String, dynamic> json) {
    return AnimeData(
      id: json['id'].toString(),
      idMal: json['idMal'].toString(),
      title: json['title']['english'] ??
          json['title']['romaji'] ??
          json['title']['userPreferred'],
      allTitles: List<String>.from([
        json['title']['english'] ?? "",
        json['title']['romaji'] ?? "",
        json['title']['userPreferred'] ?? "",
      ].where((e) => e.isNotEmpty).toList()),
      coverImg: CoverImage.fromJson(json['coverImage']),
      bannerUrl: json['bannerImage'] ?? "",
      description: removeHtmlTags(json['description'] ?? "No description"),
      season: json['season'] ?? "WINTER",
      year: json['seasonYear'].toString() != 'null'
          ? json['seasonYear'].toString()
          : "Unknown",
      type: json['format'].toString() == "null" ? "TV" : json['format'],
      status: json['status'],
      episodes: episodesCount(json),
      genre: json['genres'].isNotEmpty ? json['genres'][0] : "Unknown",
      genres: List<String>.from(json['genres'] ?? ["Unknown"]),
      averageScore: json['averageScore'].toString() == "null"
          ? "?"
          : (json['averageScore'] / 10).toString(),
      studios: json['studios']['edges'].isNotEmpty
          ? List<String>.from(
              json['studios']['edges'].map((e) => e['node']['name']).toList())
          : <String>["Unknown"],
      streamId: null,
    );
  }

  static int episodesCount(Map<String, dynamic> data) {
    // Check if 'episodes' exists and return it
    if (data.containsKey('episodes') && data['episodes'] != null) {
      return data['episodes'];
    }

    // Check if 'totalEpisodes' exists and return it
    if (data.containsKey('totalEpisodes') && data['totalEpisodes'] != null) {
      return data['totalEpisodes'];
    }

    // Check if 'nextAiringEpisode' exists and has a valid 'episode' field
    if (data.containsKey('nextAiringEpisode') &&
        data['nextAiringEpisode'] != null) {
      var nextAiringEpisode = data['nextAiringEpisode'];
      if (nextAiringEpisode.containsKey('episode') &&
          nextAiringEpisode['episode'] != null) {
        return nextAiringEpisode['episode'] - 1;
      }
    }

    // Check if 'nextair' exists and has a valid 'episode' field
    if (data.containsKey('nextair') && data['nextair'] != null) {
      var nextair = data['nextair'];
      if (nextair.containsKey('episode') && nextair['episode'] != null) {
        return nextair['episode'] - 1;
      }
    }

    // If none of the above keys exist or are valid, return 0
    if (data.containsKey('airingSchedule') &&
        data['airingSchedule'].isNotEmpty) {
      return data['airingSchedule']["edges"].isNotEmpty
          ? data['airingSchedule']["edges"][0]["node"]["episode"]
          : 0;
    }
    return 0;
  }

  static List<AnimeData> fromDataJson(Map<String, dynamic> json) {
    final List media = json['Page']['media'];
    final List<AnimeData> mediaData = [];
    mediaData.addAll(media.map((e) => AnimeData.fromJson(e)));
    if (mediaData.isNotEmpty) {
      return mediaData.where((element) => element.episodes >= 1).toList();
    } else {
      throw Exception('No media found');
    }
  }

  AnimeData copyWith({required StreamId? streamId}) {
    return AnimeData(
      id: id,
      idMal: idMal,
      title: title,
      allTitles: allTitles,
      coverImg: coverImg,
      bannerUrl: bannerUrl,
      description: description,
      season: season,
      year: year,
      type: type,
      status: status,
      episodes: episodes,
      genre: genre,
      genres: genres,
      averageScore: averageScore,
      studios: studios,
      streamId: streamId,
    );
  }

  static String removeHtmlTags(String htmlText) {
    final RegExp exp = RegExp(r'<[^>]*>');
    return htmlText.replaceAll(exp, '').trim();
  }

  @override
  String toString() {
    return 'AnimeData{id: $id, title: $title, genres: $genres, status: $status}';
  }
}
