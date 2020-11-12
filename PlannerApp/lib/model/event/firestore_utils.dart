import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:PlannerApp/model/event/event_info.dart';
import 'package:flutter/material.dart';

//initialize Firebase
final String collectionPath = "events";
final String collectionDoc = "calendar";
final CollectionReference mainCollection = FirebaseFirestore.instance.collection(collectionPath);
final DocumentReference reference = mainCollection.doc(collectionDoc);

class FirestoreUtils {
  //add event to Firestore
  Future<void> storeEventData(EventInfo eventInfo) async {
    DocumentReference documentReferencer = reference.collection(collectionPath).doc(eventInfo.id);
    Map<String, dynamic> events = eventInfo.toJson();
    print('Get events:\n$events');

    await documentReferencer.set(events).whenComplete(() {
      print("Event added to the database, id: {${eventInfo.id}}");
    }).catchError((e) => print(e));
  }

  //update event in Firestore
  Future<void> updateEventData(EventInfo eventInfo) async {
    DocumentReference ref = reference.collection(collectionPath).doc(eventInfo.id);
    Map<String, dynamic> data = eventInfo.toJson();
    print('Get events:\n$data');

    await ref.update(data).whenComplete(() {
      print("Event updated in the database, id: {${eventInfo.id}}");
    }).catchError((e) => print(e));
  }

  //delete event from Firestore
  Future<void> deleteEvent({@required String id}) async {
    DocumentReference ref = reference.collection(collectionPath).doc(id);
    print('Event deleted, id: $id');

    await ref.delete().catchError((e) => print(e));
  }

  //get events from Firestore
  Stream<QuerySnapshot> retrieveEvents() {
    Stream<QuerySnapshot> eventStream = reference.collection(collectionPath).orderBy('date').snapshots();
    return eventStream;
  }
}
