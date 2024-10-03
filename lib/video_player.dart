import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayer extends StatefulWidget {
  final String? videoUrl;
  const VideoPlayer({super.key, this.videoUrl});

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late YoutubePlayerController _youtubePlayerController;
  //https://youtu.be/PJsiUD57gaw?si=uZFZlEM1I9BLAkJZ

//
  List<Map<String, String>> suggestedVideos = [
    {
      "title": "Whats new in flutter",
      "url": 'https://youtu.be/PJsiUD57gaw?si=uZFZlEM1I9BLAkJZ'
    },
  ];
  bool _isEnded = false;
  @override
  void initState() {
    super.initState();
    log("video url ${widget.videoUrl!}");
    _youtubePlayerController = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.videoUrl!)!,
      flags: YoutubePlayerFlags(
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
      appBar: AppBar(
        title: const Text("data"),
      ),
      body: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: AspectRatio(
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
          ),
          _isEnded
              ? Expanded(
                  child: ListView.builder(
                    itemCount: suggestedVideos.length,
                    itemBuilder: (context, index) {
                      final video = suggestedVideos[index];
                      return ListTile(
                        title: Text(video['title']!),
                        onTap: () {
                          // On tap, play the selected video
                          setState(() {
                            _isEnded = false; // Reset the state
                            _youtubePlayerController.load(
                                YoutubePlayer.convertUrlToId(video['url']!)!);
                          });
                        },
                      );
                    },
                  ),
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}
