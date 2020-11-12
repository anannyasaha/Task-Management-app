import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EventInfo {
  String id;
  String name;
  String date;
  String startTime;
  String endTime;
  String description;
  String location;
  bool shouldNotify;

  EventInfo({this.id,
    @required this.name,
    @required this.date,
    @required this.startTime,
    @required this.endTime,
    @required this.description,
    @required this.location,
    @required this.shouldNotify,
  });

  //get an event from map
  EventInfo.fromMap(Map<String, dynamic> snapshot) {
    this.name = snapshot['name'];
    this.date = snapshot['date'];
    this.startTime = snapshot['start'];
    this.endTime = snapshot['end'];
    this.description = snapshot['desc'];
    this.location = snapshot['loc'];
    this.shouldNotify = snapshot['notify'];
  }

  //add event as JSON
  toJson() {
    return {
      'name': name,
      'date': date,
      'start': startTime,
      'end': endTime,
      'desc': description,
      'loc': location,
      'notify': shouldNotify,
    };
  }
}
