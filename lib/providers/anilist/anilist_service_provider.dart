import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

// A simple cache manager
class CacheManager {
  static final Map<String, dynamic> _cache = {};

  static dynamic get(String key) => _cache[key];

  static void set(String key, dynamic value) {
    _cache[key] = value;
  }

  static void remove(String key) {
    _cache.remove(key);
  }
}

class AnilistService {
  http.Client client = http.Client();
  final String graphqlUrl = "https://graphql.anilist.co";

  // GraphQL queries
  final String advanceSearchQuery = '''
  query (\$page: Int, \$id: Int, \$type: MediaType, \$isAdult: Boolean, \$search: String, \$format: [MediaFormat], \$status: MediaStatus, \$size: Int, \$countryOfOrigin: CountryCode, \$source: MediaSource, \$season: MediaSeason, \$seasonYear: Int, \$year: String, \$onList: Boolean, \$yearLesser: FuzzyDateInt, \$yearGreater: FuzzyDateInt, \$episodeLesser: Int, \$episodeGreater: Int, \$durationLesser: Int, \$durationGreater: Int, \$chapterLesser: Int, \$chapterGreater: Int, \$volumeLesser: Int, \$volumeGreater: Int, \$licensedBy: [String], \$isLicensed: Boolean, \$genres: [String], \$excludedGenres: [String], \$tags: [String], \$excludedTags: [String], \$minimumTagRank: Int, \$sort: [MediaSort]) {
    Page(page: \$page, perPage: \$size) {
      pageInfo {
        total
        perPage
        currentPage
        lastPage
        hasNextPage
      }
      media(id: \$id, type: \$type, season: \$season, format_in: \$format, status: \$status, countryOfOrigin: \$countryOfOrigin, source: \$source, search: \$search, onList: \$onList, seasonYear: \$seasonYear, startDate_like: \$year, startDate_lesser: \$yearLesser, startDate_greater: \$yearGreater, episodes_lesser: \$episodeLesser, episodes_greater: \$episodeGreater, duration_lesser: \$durationLesser, duration_greater: \$durationGreater, chapters_lesser: \$chapterLesser, chapters_greater: \$chapterGreater, volumes_lesser: \$volumeLesser, volumes_greater: \$volumeGreater, licensedBy_in: \$licensedBy, isLicensed: \$isLicensed, genre_in: \$genres, genre_not_in: \$excludedGenres, tag_in: \$tags, tag_not_in: \$excludedTags, minimumTagRank: \$minimumTagRank, sort: \$sort, isAdult: \$isAdult) {
       id
        idMal
        status(version: 2)
        title {
          userPreferred
          romaji
          english
          native
        }
        genres
        description
        format
        bannerImage
        coverImage {
          extraLarge
          large
          medium
          color
        }
        episodes
        meanScore
        duration
        season
        seasonYear
        averageScore
        nextAiringEpisode {
          airingAt
          timeUntilAiring
          episode
        }
        airingSchedule{
            edges {
                node {
                episode
                airingAt
                }
            }
            }
        studios {
          edges {
            isMain
            node {
              id
              name
            }
          }
        }
      }
    }
  }
  ''';

  // Get season based on current month (similar to the Python code)
  String getSeason({bool future = false}) {
    DateTime now = DateTime.now();
    int month = now.month;

    if (future) {
      month = month + 3;
    }

    int year = now.year;
    if (month > 12) {
      month -= 12;
      year += 1;
    }

    if (month == 1 || month == 2 || month == 3) {
      return "WINTER,$year";
    } else if (month == 4 || month == 5 || month == 6) {
      return "SPRING,$year";
    } else if (month == 7 || month == 8 || month == 9) {
      return "SUMMER,$year";
    } else {
      return "FALL,$year";
    }
  }

  // Perform GraphQL query
  Future<Map<String, dynamic>> _queryGraphQL(
      String query, Map<String, dynamic> variables) async {
    final response = await client.post(
      Uri.parse(graphqlUrl),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({
        'query': query,
        'variables': variables,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  // Perform advance search
  Future<Map<String, dynamic>> advanceSearch(
      {String? query = "",
      String genre = "",
      String type = 'ANIME',
      int page = 1,
      int limit = 30}) async {
    final cacheKey = '$query$genre$type$page$limit';
    if (CacheManager.get(cacheKey) != null) {
      return CacheManager.get(cacheKey);
    }

    final variables = {
      'page': page,
      'size': limit,
      'type': type,
    };

    if (query!.isNotEmpty) {
      variables['search'] = query;
    }

    if (genre.isNotEmpty) {
      variables['genres'] = [genre];
    }

    final data = await _queryGraphQL(advanceSearchQuery, variables);
    CacheManager.set(cacheKey, data);
    return data;
  }

  // Fetch trending media
  Future<Map<String, dynamic>> trending({int page = 1, int limit = 10}) async {
    final cacheKey = 'trending$page$limit';
    if (CacheManager.get(cacheKey) != null) {
      return CacheManager.get(cacheKey);
    }

    // final seasonData = getSeason();
    final variables = {
      'page': page,
      'sort': ["TRENDING_DESC", "POPULARITY_DESC"],
      'type': 'ANIME',
    };

    final data = await _queryGraphQL(advanceSearchQuery, variables);
    CacheManager.set(cacheKey, data);
    return data;
  }

  // Fetch popular media
  Future<Map<String, dynamic>> popular({int page = 1, int limit = 25}) async {
    final cacheKey = 'popular$page$limit';
    if (CacheManager.get(cacheKey) != null) {
      return CacheManager.get(cacheKey);
    }

    final currentSeason = getSeason();
    final data = await _queryGraphQL(advanceSearchQuery, {
      'page': page,
      'size': limit,
      'season': currentSeason.split(',')[0],
      'seasonYear': currentSeason.split(',')[1],
    });

    CacheManager.set(cacheKey, data);
    return data;
  }

  Future<Map<String, dynamic>> recent({int page = 1, int limit = 25}) async {
    final cacheKey = 'recent$page$limit';
    if (CacheManager.get(cacheKey) != null) {
      return CacheManager.get(cacheKey);
    }

    final data = await _queryGraphQL(advanceSearchQuery, {
      'page': page,
      'size': limit,
      'sort': ['UPDATED_AT_DESC'],
    });

    CacheManager.set(cacheKey, data);
    return data;
  }
}

final anilistServiceProvider = Provider((ref) => AnilistService());
