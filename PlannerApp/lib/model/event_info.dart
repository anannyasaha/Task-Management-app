import 'package:flutter/material.dart';

class EventInfo {
  final String id;
  final String name;
  final String description;
  final String location;
  final List<dynamic> attendees;
  final bool notifyAttendees;
  final int startTime;
  final int endTime;

  EventInfo({
    @required this.id,
    @required this.name,
    this.description,
    this.location,
    this.attendees,
    @required this.notifyAttendees,
    @required this.startTime,
    @required this.endTime,
  });

  //get an event
  EventInfo.fromMap(Map<String, dynamic> snapshot):
    id = snapshot['id'] ?? '',
    name = snapshot['name'] ?? '',
    description = snapshot['desc'],
    location = snapshot['loc'],
    attendees = snapshot['emails'] ?? '',
    notifyAttendees = snapshot['should_notify'],
    startTime = snapshot['start'],
    endTime = snapshot['end'];

  //add event as JSON
  toJson() {
    return {
      'id': id,
      'name': name,
      'desc': description,
      'loc': location,
      'emails': attendees,
      'should_notify': notifyAttendees,
      'start': startTime,
      'end': endTime,
    };
  }
}
