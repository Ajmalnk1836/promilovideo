import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:promiloassignment/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //fetch firebase videos
  Future<List?> fetchVideos() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('videos').get();
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      log("issue  ${e.toString()}");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("VIDEO LISTS"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: fetchVideos(),
            builder: (context, snapshot) {
              final videoID = YoutubePlayer.convertUrlToId(
                  snapshot.data!.first['videoUrl'].toString());
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text("Error found"),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text("No video found"),
                );
              }
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoPlayer(
                            data: snapshot.data!.first,
                          ),
                        ),
                      );
                    },
                    child: SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: Card(
                          child: Image.network(
                        YoutubePlayer.getThumbnail(videoId: videoID!),
                        fit: BoxFit.cover,
                      )),
                    ),
                  ),
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
