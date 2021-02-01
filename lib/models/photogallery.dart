import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Photogallery {
    int album;
    String title;
    String cover;
    List<String> photos;

  Photogallery({
        this.album,
        this.title,
        this.cover,
        this.photos,
  });

  //String get fullLogoUrl => 'https://oilgasconference.az/css/oilgasconference/logo-site.png?v=2020.11.07$';

  Map<String, dynamic> toMap() {
    return {
      'album': album,
      'title': title,
      'cover': cover,
      'photos': List<dynamic>.from(photos.map((x) => x)),
    };
  }

  factory Photogallery.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Photogallery(
      album: map['album'],
      title: map['title'],
      cover: map['cover'],
      photos: List<String>.from(map['photos'].map((x) => x)).toList(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Photogallery.fromJson(String source) => Photogallery.fromMap(json.decode(source));
}
