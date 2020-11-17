import 'package:PlannerApp/model/event/event_info.dart';
import 'package:PlannerApp/model/event/firestore_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarEvents extends StatefulWidget {
  CalendarEvents({Key key, this.title}): super(key: key);
  final String title;

  @override
  EventsPage createState() => EventsPage();
}

class EventsPage extends State<CalendarEvents> {
  final db = FirestoreUtils();
  final String collectionPath = "events";
  EventInfo _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: buildList(),
      floatingActionButton: new FloatingActionButton(
        tooltip: "Add event",
        child: const Icon(Icons.add),
        onPressed: () {
          print("Add event");
          _startForm(context);
        }
      ),
    );
  }

  Widget buildList() {
    return StreamBuilder<QuerySnapshot>(
      stream: db.retrieveEvents(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        } else {
          return ListView(
            children: snapshot.data.docs.map((DocumentSnapshot snapshot) => _buildEvent(context, snapshot)).toList(),
          );
        }
      },
    );
  }

  Widget _buildEvent(BuildContext context, DocumentSnapshot documentData) {
    final event = EventInfo.fromMap(documentData.data());

    return Card(
      elevation: 2.0,
      child: ListTile(
        title: Text("${event.date}\n${event.name}"),
        subtitle: Text(_buildSubtitle(event)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.delete),
              onPressed: () => db.deleteEvent(id: event.id),
            ),
          ],
        ),

        selected: event == _selected,
        onTap: () => setState(() {
          _selected = event;
          _startForm(context, _selected);
        }),
      ),
    );
  }

  //build subtitle for event
  String _buildSubtitle(EventInfo event) {
    String subtitle = "${event.startTime} to ${event.endTime}";

    //add to subtitle
    if (event.description.isNotEmpty) {
      subtitle += "\n${event.description}";
    } else if (event.location.isNotEmpty) {
      subtitle += "\nat ${event.location}";
    }

    return subtitle;
  }

  void _startForm(BuildContext context, [EventInfo eventInfo]) async {
    await Navigator.of(context).push(new MaterialPageRoute(
      builder: (BuildContext context) => new CalendarForm(event: eventInfo),
    ));

    _selected = null;
  }
}


class CalendarForm extends StatefulWidget {
  final EventInfo event;
  CalendarForm({Key key, this.event});

  @override
  FormPage createState() => FormPage();
}

class FormPage extends State<CalendarForm> {
  final db = FirestoreUtils();

  final _name = TextEditingController();
  final _description = TextEditingController();
  final _location = TextEditingController();

  DateTime _date = DateTime.now();
  TimeOfDay _start = TimeOfDay.now();
  TimeOfDay _end = TimeOfDay(hour: TimeOfDay.now().hour + 1, minute: TimeOfDay.now().minute);

  String date;
  bool notify = false;

  
  Future<void> selectDate(BuildContext context) async {
    print("Select date");

    //pick a date
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050),
    );

    if (picked != null) {
      setState(() {
        _date = picked;
        date = DateFormat.yMd().format(_date);
      });
    }
  }

  Future<void> selectTime(BuildContext context, TimeOfDay which) async {
    print("Select time");

    //pick a time
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: which,
    );

    if (picked != null) {
      setState(() => which = picked);
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _location.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Modify Event")),
      body: new ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          //name textfield
          TextField(
            controller: _name..text = widget.event.name,
            decoration: const InputDecoration(
              icon: const Icon(Icons.event),
              labelText: "Name of Event",
            ),
          ),

          //select date row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Select Date:"), SizedBox(width: 20.0),
              FlatButton(
                color: Colors.blue,
                textColor: Colors.white,
                child: Text("${_date.toLocal()}".split(' ')[0]),
                onPressed: () => selectDate(context),
              ),
            ],
          ),

          //select time row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //start time
              Text("Time:"), SizedBox(width: 20.0),
              FlatButton(
                color: Colors.blue,
                textColor: Colors.white,
                child: Text(_start.format(context)),
                onPressed: () => selectTime(context, _start),
              ), SizedBox(width: 5.0),

              //end time
              Text("to"), SizedBox(width: 5.0),
              FlatButton(
                color: Colors.blue,
                textColor: Colors.white,
                child: Text(_end.format(context)),
                onPressed: () => selectTime(context, _end),
              ),
            ],
          ),

          //description textfield
          TextField(
            controller: _description..text = widget.event.description,
            decoration: const InputDecoration(
              icon: const Icon(Icons.list),
              labelText: "Event Description",
            ),
          ),

          //location textfield
          TextField(
            controller: _location..text = widget.event.location,
            decoration: const InputDecoration(
              icon: const Icon(Icons.location_on),
              labelText: "Location",
            ),
          ),

          //notification switch
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Send notifications?"), SizedBox(width: 10),
              Switch(
                activeTrackColor: Colors.lightBlue,
                activeColor: Colors.blue,
                value: notify,
                onChanged: (value) {
                  setState(() => notify = value);
                },
              )
            ],
          )
        ],
      ),

      floatingActionButton: new FloatingActionButton(
        tooltip: "Save event",
        child: const Icon(Icons.save),
        onPressed: () {
          String name = _name.text;
          String description = _description.text;
          String location = _location.text;

          if (name.isNotEmpty && description.isNotEmpty) {
            if (widget.event.id.isEmpty)
              _createEvent(name, description, location);
            else
              _updateEvent(name, description, location);

            Navigator.pop(context);
          }
        }
      ),
    );
  }
  
  
  //add event to Firestore
  void _createEvent(String name, String desc, String loc) {
    EventInfo event = new EventInfo(
      name: name,
      date: date,
      startTime: _start.format(context),
      endTime: _end.format(context),
      description: desc,
      location: loc,
      shouldNotify: notify,
    );

    db.storeEventData(event);
  }

  //update event in Firestore
  void _updateEvent(String name, String desc, String loc) {
    EventInfo event = new EventInfo(
      name: name,
      date: date,
      startTime: _start.format(context),
      endTime: _end.format(context),
      description: desc,
      location: loc,
      shouldNotify: notify,
    );

    db.updateEventData(event);
  }
}