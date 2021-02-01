import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Event {
  int projectID;
  String project;
  String type;
  // String hasDelegates;
  String short_title;
  String short_title_text;
  String short_title_year;
  String title;
  String description;
  String website;
  String country;
  String image_profile;
  String logo;
  DateTime beginDate;
  String beginTime;
  DateTime endDate;
  String endTime;
  String address;
  String location;
  String latitude;
  String longitude;
  String programme;

  Event({
    this.projectID,
    this.project,
    this.type,
    // this.hasDelegates,
    this.short_title,
    this.short_title_text,
    this.short_title_year,
    this.title,
    this.description,
    this.website,
    this.country,
    this.image_profile,
    this.logo,
    this.beginDate,
    this.beginTime,
    this.endDate,
    this.endTime,
    this.address,
    this.location,
    this.latitude,
    this.longitude,
    this.programme,
  });

  //String get fullLogoUrl => 'https://oilgasconference.az/css/oilgasconference/logo-site.png?v=2020.11.07$';

  Map<String, dynamic> toMap() {
    return {
      'projectID': projectID,
      'project': project,
      'type': type,
      // 'hasDelegates': hasDelegates,
      'short_title': short_title,
      'short_title_text': short_title_text,
      'short_title_year': short_title_year,
      'title': title,
      'description': description,
      'website': website,
      'country ': country,
      'image_profile': image_profile,
      'logo': logo,
      'beginDate': beginDate,
      'beginTime': beginTime,
      'endDate': endDate,
      'endTime': endTime,
      'address': address,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'programme': programme,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Event(
      projectID: map['projectID'],
      project: map['project'],
      type: map['type'],
      // hasDelegates: map['hasDelegates'],
      short_title: map['short_title'],
      short_title_text: map['short_title_text'],
      short_title_year: map['short_title_year'],
      title: map['title'],
      description: map['description'],
      website: map['website'],
      country: map['country '],
      image_profile: map['image_profile'],
      logo: map['logo'],
      beginDate: DateTime.tryParse(map['beginDate']),
      beginTime: map['beginTime'],
      endDate: DateTime.tryParse(map['endDate']),
      endTime: map['endTime'],
      address: map['address'],
      location: map['location'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      programme: map['programme'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Event.fromJson(String source) => Event.fromMap(json.decode(source));
}
