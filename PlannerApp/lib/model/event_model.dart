import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_demo/models/event_info.dart';
import 'package:flutter/material.dart';

final CollectionReference mainCollection = FirebaseFirestore.instance.collection('events');
final DocumentReference reference = mainCollection.doc('test');

class Storage {
  Future<void> storeEventData(EventInfo eventInfo) async {
    DocumentReference documentReferencer = reference.collection('events').doc(eventInfo.id);
    Map<String, dynamic> events = eventInfo.toJson();
    print('Get events:\n$events');

    await documentReferencer.set(events).whenComplete(() {
      print("Event added to the database, id: {${eventInfo.id}}");
    }).catchError((e) => print(e));
  }

  //update Google Calendar event
  Future<void> updateEventData(EventInfo eventInfo) async {
    DocumentReference ref = reference.collection('events').doc(eventInfo.id);
    Map<String, dynamic> data = eventInfo.toJson();
    print('Get events:\n$data');

    await ref.update(data).whenComplete(() {
      print("Event updated in the database, id: {${eventInfo.id}}");
    }).catchError((e) => print(e));
  }

  //delete event from Google Calendar
  Future<void> deleteEvent({@required String id}) async {
    DocumentReference ref = reference.collection('events').doc(id);
    print('Event deleted, id: $id');

    await ref.delete().catchError((e) => print(e));
  }

  //get events from firestore
  Stream<QuerySnapshot> retrieveEvents() {
    Stream<QuerySnapshot> eventStream = reference.collection('events').orderBy('start').snapshots();
    return eventStream;
  }
}
