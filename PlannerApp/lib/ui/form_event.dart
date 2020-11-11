import 'package:flutter/material.dart';

class _eventForm extends StatefulWidget {
  final String eventId;
  final String calendarId;
  final String title;
  final String description;
  final DateTime start;
  final DateTime end;
  final String location;
  final List<Attendee> attendees;

  _eventForm({Key key,
    this.eventId,
    this.calendarId,
    this.title,
    this.description,
    this.start,
    this.end,
    this.location,
    this.attendees,
  });

  @override
  EventPage createState() => EventPage();
}

class EventPage extends State<_eventForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Modify Event")),
      body: ,
    );
  }
}