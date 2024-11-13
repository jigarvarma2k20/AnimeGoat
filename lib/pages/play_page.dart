import 'package:animegoat/components/episode_button.dart';
import 'package:animegoat/components/head_and_text.dart';
import 'package:animegoat/components/my_text_button.dart';
import 'package:animegoat/components/text_icon_button.dart';
import 'package:animegoat/components/video_player_widget.dart';
import 'package:animegoat/models/anime_data.dart';
import 'package:animegoat/models/stream_data.dart';
import 'package:animegoat/providers/player_provider.dart';
import 'package:animegoat/providers/stream_data_provider.dart';
import 'package:animegoat/styles/custom_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: must_be_immutable
class PlayPage extends ConsumerWidget {
  AnimeData? animeData;
  int currentEp;
  PlayPage({super.key, required this.animeData, this.currentEp = 1});

  late Future<void> getStreamdataFuture;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stream = ref.watch(streamDataProvider);
    if (stream.streamData == null ||
        stream.animeData == null ||
        stream.animeData!.id != animeData!.id ||
        stream.currentEp != currentEp) {
      stream.setData(animeData!, currentEp);
    } else {
      animeData = stream.animeData;
    }
    getStreamdataFuture = stream.getStreamDataList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Play"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Consumer(
              builder: (context, ref, child) {
                final st = ref.watch(streamTrackProvider);

                return st != null
                    ? VideoPlayerWidget(
                        key: ValueKey(st.link),
                        videoUrl: st.link,
                      )
                    : AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(
                            color: Colors.grey.withOpacity(0.5),
                            child: stream.tried && stream.streamData == null
                                ? const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.info,
                                        size: 50,
                                      ),
                                      Text(
                                        "Currently this episode is not available",
                                      )
                                    ],
                                  )
                                : const Center(
                                    child: CircularProgressIndicator(),
                                  )),
                      );
              },
            ),
            const SizedBox(height: 20),
            const Text(
              "You are watching",
              style: smallDescription,
            ),
            const SizedBox(height: 10),
            Text("${animeData?.title} - Episode $currentEp"),
            const SizedBox(height: 10),
            const Text(
              "If current server doesn't work please try other servers beside.",
              style: smallDescription,
            ),
            const SizedBox(height: 20),

            // Build sub and dub buttons row dynmically
            Consumer(
              builder: (context, ref, child) {
                final streamData = stream.streamData;
                if (streamData == null) {
                  return const SizedBox();
                }
                final List<String> availableTracks = [];
                if (streamData.subTracks.isNotEmpty) {
                  availableTracks.add("Sub");
                }
                if (streamData.dubTracks.isNotEmpty) {
                  availableTracks.add("Dub");
                }

                return Column(
                    children: List.generate(availableTracks.length, (index) {
                  List<Widget> widgets = [
                    Icon(availableTracks[index] == "Sub"
                        ? Icons.subtitles_rounded
                        : Icons.mic),
                    Text("${availableTracks[index]}:"),
                    const SizedBox(width: 10)
                  ];
                  for (var value = 0;
                      value <
                          (availableTracks[index] == "Sub"
                                  ? streamData.subTracks
                                  : streamData.dubTracks)
                              .length;
                      value++) {
                    final List<StreamTrack> currentStream =
                        (availableTracks[index] == "Sub"
                            ? streamData.subTracks
                            : streamData.dubTracks);
                    widgets.add(Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: MyTextButton(
                          text: "Server ${value + 1}",
                          isActive: currentStream[value] ==
                              ref.watch(streamTrackProvider),
                          onPressed: () {
                            ref
                                .read(streamTrackProvider.notifier)
                                .setStreamData = currentStream[value];
                          }),
                    ));
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: widgets,
                    ),
                  );
                }));
              },
            ),

            const SizedBox(height: 20),

            // Build episode list

            stream.animeData!.episodes == 1
                ? const SizedBox()
                : Container(
                    width: 300,
                    height: stream.animeData!.episodes < 10
                        ? 42.5 * stream.animeData!.episodes
                        : 300,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(5),
                    child: SingleChildScrollView(
                      child: Column(
                        children: List.generate(stream.animeData?.episodes ?? 1,
                            (index) {
                          return EpisodeButton(
                            episodeId: index + 1,
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PlayPage(
                                    animeData: animeData,
                                    currentEp: index + 1,
                                  ),
                                ),
                              );
                            },
                            isWatching: index + 1 == currentEp,
                          );
                        }),
                      ),
                    ),
                  ),
            const SizedBox(
              height: 20,
            ),
            currentEp < animeData!.episodes
                ? TextIconButton(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlayPage(
                            animeData: animeData,
                            currentEp: currentEp + 1,
                          ),
                        ),
                      );
                    },
                    text: "Next",
                    icon: Icons.arrow_forward_ios_rounded)
                : const SizedBox(),
            const SizedBox(
              height: 20,
            ),
            HeadAndText(
              head: "Description",
              text: animeData!.description,
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
