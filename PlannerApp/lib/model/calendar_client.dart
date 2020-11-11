import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart';

class CalendarClient {
  static var calendar;  //communicates with google calendar

  Future<Map<String, String>> modify({
    String id,
    @required String title,
    @required String description,
    @required String location,
    @required List<EventAttendee> attendeeEmailList,
    @required bool shouldNotifyAttendees,
    @required DateTime startTime,
    @required DateTime endTime,

  }) async {
    String calendarID = "primary";
    Map<String, String> eventData;
    Event event = Event();

    event.summary = title;
    event.description = description;
    event.attendees = attendeeEmailList;
    event.location = location;

    EventDateTime start = new EventDateTime();
    start.dateTime = startTime;
    start.timeZone = DateTime.now().timeZoneName;
    event.start = start;

    EventDateTime end = new EventDateTime();
    end.timeZone = DateTime.now().timeZoneName;
    end.dateTime = endTime;
    event.end = end;

    //add event to calendar
    if (id.isEmpty) {
      try {
        await calendar.events.insert(event, calendarID).then((value) {
          print("Event Status: ${value.status}");

          if (value.status == "confirmed") {
            String eventID = value.id;
            eventData = {'id': eventID};

            print('Event added to Google Calendar');
          } else {
            print("Unable to add event to Google Calendar");
          }
        });
      } catch (e) {
        print('Error creating event $e');
      }

    //edit event based on id
    } else {
      try {
        await calendar.events.patch(event, calendarID, id).then((value) {
          print("Event Status: ${value.status}");
          if (value.status == "confirmed") {
            String eventId = value.id;
            eventData = {'id': eventId};

            print('Event updated in google calendar');
          } else {
            print("Unable to update event in google calendar");
          }
        });
      } catch (e) {
        print('Error updating event $e');
      }
    }

    return eventData;
  }

  //delete event based on id
  Future<void> delete(String eventId, bool shouldNotify) async {
    String calendarID = "primary";

    try {
      await calendar.events.delete(calendarID, eventId, sendUpdates: shouldNotify? "all" : "none").then((value) {
        print('Event deleted from Google Calendar');
      });
    } catch (e) {
      print('Error deleting event: $e');
    }
  }
}
