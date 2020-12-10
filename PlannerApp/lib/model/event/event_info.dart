import 'package:cloud_firestore/cloud_firestore.dart';

class EventInfo {
  DocumentReference reference;
  String name;
  String date;
  String startTime;
  String endTime;
  String description;
  String location;

  EventInfo({this.reference,
    this.name,
    this.date,
    this.startTime,
    this.endTime,
    this.description,
    this.location,
  });

  //get an event from map
  EventInfo.fromMap(Map<String, dynamic> snapshot, {this.reference}) {
    this.name = snapshot['name'];
    this.date = snapshot['date'];
    this.startTime = snapshot['start'];
    this.endTime = snapshot['end'];
    this.description = snapshot['desc'];
    this.location = snapshot['loc'];
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
    };
  }
}
