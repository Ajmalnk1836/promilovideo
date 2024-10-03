import 'dart:math';

import 'package:flutter/material.dart';

class SuggestedVideo {
  String? id;
  final String? title;
  final String? url;
  final String? publishedBy;
  final String? publishedOn;
  SuggestedVideo({this.title, this.url, this.publishedBy, this.publishedOn})
      : id = _generateId();

  // Generate a unique ID using DateTime and Random
  static String _generateId() {
    var timestamp = DateTime.now().millisecondsSinceEpoch;
    var random =
        Random().nextInt(10000); // Add a random element to avoid collisions
    return '$timestamp-$random';
  }

  @override
  String toString() {
    return 'SuggestedVideo{id: $id, title: $title, url: $url, publishedBy: $publishedBy, publishedOn: $publishedOn}';
  }
}
