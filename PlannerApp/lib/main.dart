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
  String _selectedParam;
  String task;
  int val;

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
                decoration: InputDecoration(
                    hintText: "Reminder title: ", border: OutlineInputBorder()),
                onChanged: (_val) {
                  task = _val;
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DropdownButton(
                  value: _selectedParam,
                  items: [
                    DropdownMenuItem(
                      child: Text("Seconds"),
                      value: "Seconds",
                    ),
                    DropdownMenuItem(
                      child: Text("Minutes"),
                      value: "Minutes",
                    ),
                    DropdownMenuItem(
                      child: Text("Hour"),
                      value: "Hour",
                    ),
                  ],
                  hint: Text(
                    "Select Your Field.",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  onChanged: (_val) {
                    setState(() {
                      _selectedParam = _val;
                    });
                  },
                ),
                // DropdownButton(
                //   value: val,
                //   items: [
                //     DropdownMenuItem(
                //       child: Text("1"),
                //       value: 1,
                //     ),
                //     DropdownMenuItem(
                //       child: Text("2"),
                //       value: 2,
                //     ),
                //     DropdownMenuItem(
                //       child: Text("3"),
                //       value: 3,
                //     ),
                //     DropdownMenuItem(
                //       child: Text("4"),
                //       value: 4,
                //     ),
                //     DropdownMenuItem(
                //       child: Text("5"),
                //       value: 5,
                //     ),
                //     DropdownMenuItem(
                //       child: Text("6"),
                //       value: 6,
                //     ),
                //     DropdownMenuItem(
                //       child: Text("7"),
                //       value: 7,
                //     ),
                //     DropdownMenuItem(
                //       child: Text("8"),
                //       value: 8,
                //     ),
                //     DropdownMenuItem(
                //       child: Text("9"),
                //       value: 9,
                //     ),
                //     DropdownMenuItem(
                //       child: Text("10"),
                //       value: 10,
                //     ),
                //     DropdownMenuItem(
                //       child: Text("11"),
                //       value: 11,
                //     ),
                //     DropdownMenuItem(
                //       child: Text("12"),
                //       value: 12,
                //     ),
                //     DropdownMenuItem(
                //       child: Text("13"),
                //       value: 13,
                //     ),
                //     DropdownMenuItem(
                //       child: Text("14"),
                //       value: 14,
                //     ),
                //     DropdownMenuItem(
                //       child: Text("15"),
                //       value: 15,
                //     ),
                //     DropdownMenuItem(
                //       child: Text("16"),
                //       value: 16,
                //     ),
                //     DropdownMenuItem(
                //       child: Text("17"),
                //       value: 17,
                //     ),
                //     DropdownMenuItem(
                //       child: Text("18"),
                //       value: 18,
                //     ),
                //     DropdownMenuItem(
                //       child: Text("19"),
                //       value: 19,
                //     ),
                //     DropdownMenuItem(
                //       child: Text("20"),
                //       value: 20,
                //     ),
                //     DropdownMenuItem(
                //       child: Text("21"),
                //       value: 21,
                //     ),
                //     DropdownMenuItem(
                //       child: Text("22"),
                //       value: 22,
                //     ),
                //     DropdownMenuItem(
                //       child: Text("23"),
                //       value: 23,
                //     ),
                //     DropdownMenuItem(
                //       child: Text("24"),
                //       value: 24,
                //     ),
                //     DropdownMenuItem(
                //       child: Text("25"),
                //       value: 25,
                //     ),
                //     DropdownMenuItem(
                //       child: Text("26"),
                //       value: 26,
                //     ),
                //     DropdownMenuItem(
                //       child: Text("27"),
                //       value: 27,
                //     ),
                //     DropdownMenuItem(
                //       child: Text("28"),
                //       value: 28,
                //     ),
                //     DropdownMenuItem(
                //       child: Text("29"),
                //       value: 29,
                //     ),
                //     DropdownMenuItem(
                //       child: Text("30"),
                //       value: 30,
                //     ),
                //     DropdownMenuItem(
                //       child: Text("31"),
                //       value: 31,
                //     ),
                //     DropdownMenuItem(
                //       child: Text("32"),
                //       value: 32,
                //     ),
                //     DropdownMenuItem(
                //       child: Text("33"),
                //       value: 33,
                //     ),
                //     DropdownMenuItem(
                //       child: Text("34"),
                //       value: 34,
                //     ),
                //     DropdownMenuItem(
                //       child: Text("35"),
                //       value: 35,
                //     ),
                //     DropdownMenuItem(
                //       child: Text("36"),
                //       value: 36,
                //     ),
                //     DropdownMenuItem(
                //       child: Text("37"),
                //       value: 37,
                //     ),
                //     DropdownMenuItem(
                //       child: Text("39"),
                //       value: 39,
                //     ),
                //     DropdownMenuItem(
                //       child: Text("40"),
                //       value: 40,
                //     ),
                //     DropdownMenuItem(
                //       child: Text("41"),
                //       value: 41,
                //     ),
                //     DropdownMenuItem(
                //       child: Text("42"),
                //       value: 42,
                //     ),
                //     DropdownMenuItem(
                //       child: Text("43"),
                //       value: 43,
                //     ),
                //     DropdownMenuItem(
                //       child: Text("44"),
                //       value: 44,
                //     ),
                //     DropdownMenuItem(
                //       child: Text("45"),
                //       value: 45,
                //     ),
                //     DropdownMenuItem(
                //       child: Text("46"),
                //       value: 46,
                //     ),
                //     DropdownMenuItem(
                //       child: Text("47"),
                //       value: 47,
                //     ),
                //     DropdownMenuItem(
                //       child: Text("48"),
                //       value: 48,
                //     ),
                //     DropdownMenuItem(
                //       child: Text("49"),
                //       value: 49,
                //     ),
                //     DropdownMenuItem(
                //       child: Text("50"),
                //       value: 50,
                //     ),
                //     DropdownMenuItem(
                //       child: Text("51"),
                //       value: 51,
                //     ),
                //     DropdownMenuItem(
                //       child: Text("52"),
                //       value: 52,
                //     ),
                //     DropdownMenuItem(
                //       child: Text("53"),
                //       value: 53,
                //     ),
                //     DropdownMenuItem(
                //       child: Text("54"),
                //       value: 54,
                //     ),
                //     DropdownMenuItem(
                //       child: Text("55"),
                //       value: 55,
                //     ),
                //     DropdownMenuItem(
                //       child: Text("56"),
                //       value: 56,
                //     ),
                //     DropdownMenuItem(
                //       child: Text("57"),
                //       value: 57,
                //     ),
                //     DropdownMenuItem(
                //       child: Text("58"),
                //       value: 58,
                //     ),
                //     DropdownMenuItem(
                //       child: Text("59"),
                //       value: 59,
                //     ),
                //   ],
                //   hint: Text(
                //     "Select Value",
                //     style: TextStyle(
                //       color: Colors.black,
                //     ),
                //   ),
                //   onChanged: (_val) {
                //     setState(() {
                //       val = _val;
                //     });
                //   },
                // ),
                SizedBox(
                    width: 100.0,
                    height: 50.0,
                    child: CupertinoPicker(
                      itemExtent: 30,
                      onSelectedItemChanged: (int index) {
                        val = index + 1;
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

    if (_selectedParam == "Seconds") {
      scheduledTime = DateTime.now().add(Duration(seconds: val));
    } else if (_selectedParam == "Minute") {
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
