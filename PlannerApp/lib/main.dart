import 'package:PlannerApp/model/Speech/EditSpeech.dart';
import 'package:PlannerApp/model/todo/addtodopage.dart';
import 'package:PlannerApp/model/todo/assignedtable.dart';
import 'package:PlannerApp/model/todo/assignedtodopage.dart';
import 'package:PlannerApp/model/Speech/SpeechToText.dart';
import 'package:flutter/material.dart';
import 'model/todo/edittodopage.dart';
import 'model/todo/utilities.dart';
import 'package:firebase_core/firebase_core.dart';
import 'model/event/list_event.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'ui/tab_page.dart';
import 'package:PlannerApp/model/alarm.dart';
import 'package:flutter/cupertino.dart';

GetIt locator = GetIt();

void setupLocator() => locator.registerSingleton(CallsAndMessagesService());
void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        //handle connection error
        if (snapshot.hasError) {
          print("Error initializing database");
          return Text("Error initializing database");
        }

        //handle connection success
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
              title: 'App Planner',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                brightness: Brightness.light,
                primarySwatch: Colors.blue,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              darkTheme: ThemeData(
                brightness: Brightness.dark,
                primarySwatch: Colors.blue,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              themeMode: ThemeMode.system,
              home: MainPage(title: 'Home Page'),
              routes: <String, WidgetBuilder>{
                '/utilities': (BuildContext context) =>
                    todolistpage(title: "My Todo list"),
                '/addtodopage': (BuildContext context) =>
                    addtodo(title: "Add todo"),
                '/assignedtable': (BuildContext context) =>
                    assigneddatatable(title: "Assigned task list"),
                '/assignedtodopage': (BuildContext context) => assignedadd(),
                '/SpeechToText': (BuildContext context) =>
                    SpeechText(title: "Speech to Text"),
                '/edittodopage': (BuildContext context) =>
                    edittodo(title: "Edit todo", id: 0),
                '/EditSpeech': (BuildContext context) =>
                    edit_speech(texttoedit: " "),
                '/alarm': (BuildContext context) => alarm(),
              });
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  FlutterLocalNotificationsPlugin flutterNotif;
  String task;
  int _selectedParam;
  int val;
  var _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    var androidInitialize = new AndroidInitializationSettings('app_icon');
    var iOSinitialize = new IOSInitializationSettings();
    var initializationsSettings =
        new InitializationSettings(androidInitialize, iOSinitialize);
    flutterNotif = new FlutterLocalNotificationsPlugin();
    flutterNotif.initialize(initializationsSettings,
        onSelectNotification: notificationSelected);
  }

  @override
  Widget build(BuildContext context) {
    List<LayoutExample> options = <LayoutExample>[
      LayoutExample(
        title: 'Reminders',
        icon: Icons.add_alert,
        builder: buildColumnWidget,
      ),
      LayoutExample(
        title: 'Events',
        icon: Icons.event,
        builder: listEvents,
      ),
    ];

    return DefaultTabController(
      length: options.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          bottom: buildTabBar(options),
        ),
        body: buildTabBarView(options),
        bottomNavigationBar: BottomNavigationBar(
            onTap: (int index) {
              setState(() {
                if (index == 0) {
                  _gototodolistPage(context);
                }
                if (index == 2) {
                  _gotoalarmPage(context);
                }
                if (index == 1) {
                  _gotospeechtextPage(context);
                }
              });
            },
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                title: Text("Task manager"),
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.record_voice_over),
                  title: Text("Speech to text")),
              BottomNavigationBarItem(
                  icon: Icon(Icons.alarm), title: Text("Alarm"))
            ]),
      ),
    );
  }

  Future<void> _gototodolistPage(context) async {
    await Navigator.pushNamed(context, '/utilities');
  }

  Future<void> _gotospeechtextPage(context) async {
    await Navigator.pushNamed(context, '/SpeechToText');
  }

  Future<void> _gotoalarmPage(context) async {
    await Navigator.pushNamed(context, '/alarm');
  }

  Widget listEvents() {
    return CalendarEvents();
  }

  Widget buildColumnWidget() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Reminder title: ",
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: () => _controller.clear(),
                    icon: Icon(Icons.clear),
                  ),
                ),
                onChanged: (_val) {
                  task = _val;
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                    width: 100.0,
                    height: 60.0,
                    child: CupertinoPicker(
                      itemExtent: 30,
                      onSelectedItemChanged: (int index) {
                        _selectedParam = index;
                        print(_selectedParam);
                      },
                      children: <Widget>[
                        Text("Seconds",
                            style: TextStyle(
                                color: Colors.black,
                                decoration: TextDecoration.none)),
                        Text("Minutes",
                            style: TextStyle(
                                color: Colors.black,
                                decoration: TextDecoration.none)),
                        Text("Hours",
                            style: TextStyle(
                                color: Colors.black,
                                decoration: TextDecoration.none)),
                      ],
                    )),
                SizedBox(
                    width: 100.0,
                    height: 60.0,
                    child: CupertinoPicker(
                      itemExtent: 30,
                      onSelectedItemChanged: (int index) {
                        val = index + 1;
                        print(val);
                      },
                      children: <Widget>[
                        Text("1",
                            style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.none)),
                        Text("2",
                            style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.none)),
                        Text("3",
                            style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.none)),
                        Text("4",
                            style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.none)),
                        Text("5",
                            style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.none)),
                      ],
                    )),
              ],
            ),
            RaisedButton(
              onPressed: _showNotification,
              child: new Text('Set Reminder With Notification'),
            )
          ],
        ),
      ),
    );
  }

  Future _showNotification() async {
    var androidDetails = new AndroidNotificationDetails(
        "Project ID", "Group Project", "text...",
        importance: Importance.Max);
    var IOSDetails = new IOSNotificationDetails();
    var generalNotificationDetails =
        new NotificationDetails(androidDetails, IOSDetails);

    var scheduledTime;

    if (_selectedParam == 0) {
      scheduledTime = DateTime.now().add(Duration(seconds: val));
    } else if (_selectedParam == 1) {
      scheduledTime = DateTime.now().add(Duration(minutes: val));
    } else {
      //slected hour
      scheduledTime = DateTime.now().add(Duration(hours: val));
    }

    // var scheduledTime = DateTime.now().add(Duration(seconds: 5));

    flutterNotif.schedule(
        1, "Time Reached ", task, scheduledTime, generalNotificationDetails);
  }

  Future notificationSelected(String payload) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("$payload Notification Acknowledged"),
      ),
    );
  }
}
