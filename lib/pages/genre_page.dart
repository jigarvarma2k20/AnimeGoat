import 'package:animegoat/pages/genre_result_page.dart';
import 'package:flutter/material.dart';

class GenrePage extends StatelessWidget {
  //Todo: Add thumbnail for each genre and create custom card
  final List<String> genres = [
    "Action",
    "Adventure",
    "Comedy",
    "Drama",
    "Ecchi",
    "Fantasy",
    "Horror",
    "Mahou Shoujo",
    "Mecha",
    "Music",
    "Mystery",
    "Psychological",
    "Romance",
    "Sci-Fi",
    "Slice of Life",
    "Sports",
    "Supernatural",
    "Thriller",
  ];
  GenrePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.category),
        title: const Text('Genres'),
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: genres.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(genres[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GenreResultPage(genre: genres[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
