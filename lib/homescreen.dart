import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:promiloassignment/video_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List?> fetchVideos() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('videos').get();
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      log("e -issue  ${e.toString()}");
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
        title: const Text("Homescreen"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: fetchVideos(),
            builder: (context, snapshot) {
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
              return Card(
                child: ListTile(
                  title: Text(snapshot.data!.first["channelName"]),
                  leading: const CircleAvatar(),
                  titleAlignment: ListTileTitleAlignment.center,
                  subtitle: Text(snapshot.data!.first["title"]),
                  trailing: GestureDetector(
                      onTap: () {
                        // /VideoPlayer
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoPlayer(
                                videoUrl: snapshot.data!.first['videoUrl'],
                              ),
                            ));
                      },
                      child: const Text("Go to video")),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
