import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:promiloassignment/models/suggestedVideoModel.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayer extends StatefulWidget {
  final Map<String, dynamic>? data;
  const VideoPlayer({super.key, this.data});

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late YoutubePlayerController _youtubePlayerController;

  List<SuggestedVideo> suggestedVideos = [
    SuggestedVideo(
        title: "Whats new in flutter",
        url: "https://youtu.be/PJsiUD57gaw?si=uZFZlEM1I9BLAkJZa",
        publishedBy: "RS media",
        publishedOn: "10-Oct-2023"),
    SuggestedVideo(
        title: "3D in FLutter",
        url: "https://youtu.be/6t7To8HLn3A?si=jwUCiga26K5RylN6",
        publishedBy: "CodeX",
        publishedOn: "20-Jan-2023"),
  ];
  bool _isEnded = false;
  @override
  void initState() {
    super.initState();
    log("video url ${widget.data!["videoUrl"]}");
    _youtubePlayerController = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.data!["videoUrl"]!)!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
      ),
    )..addListener(listener);
  }

  void listener() {
    if (_youtubePlayerController.value.playerState == PlayerState.ended) {
      log("player ended");

      setState(() {
        _isEnded = true;
      });
    } else {
      setState(() {
        _isEnded = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _youtubePlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: YoutubePlayer(
              controller: _youtubePlayerController,
              showVideoProgressIndicator: true,
              onReady: () {
                //
                log("on ready called");
              },
            ),
          ),
          _isEnded
              ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Suggested Videos"),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: suggestedVideos.length,
                          itemBuilder: (context, index) {
                            final video = suggestedVideos[index];

                            final videoID =
                                YoutubePlayer.convertUrlToId(video.url!);
                            return _youtubePlayerController.metadata.videoId ==
                                    videoID
                                ? const SizedBox.shrink()
                                : InkWell(
                                    onTap: () {
                                      setState(() {
                                        _isEnded = false;
                                      });
                                      _youtubePlayerController.load(
                                          YoutubePlayer.convertUrlToId(
                                              video.url!)!);
                                    },
                                    child: Card(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  height: 100,
                                                  width: double.infinity,
                                                  child: Center(
                                                    child: Image.network(
                                                      YoutubePlayer
                                                          .getThumbnail(
                                                              videoId:
                                                                  videoID!),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(video.title!),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                        "published by : ${video.publishedBy!}"),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                        "published on:${video.publishedOn!}"),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                          },
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}
