import 'package:animegoat/providers/selected_index.dart';
import 'package:animegoat/pages/genre_page.dart';
import 'package:animegoat/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() => runApp(ProviderScope(child: MyApp()));

class MyApp extends ConsumerWidget {
  MyApp({super.key});

  final List<Widget> screens = [
    const HomePage(),
    GenrePage(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      //ToDo: Add custom colorScheme and theme
      theme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: screens[ref.watch(selectedIndexProvider)],
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: "Genres",
            ),
          ],
          onTap: (index) {
            ref.read(selectedIndexProvider.notifier).selectedIndex = index;
          },
          currentIndex: ref.read(selectedIndexProvider),
        ),
      ),
    );
  }
}
