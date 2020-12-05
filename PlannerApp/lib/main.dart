import 'package:PlannerApp/model/event/form_event.dart';
import 'package:PlannerApp/model/todo/addtodopage.dart';
import 'package:PlannerApp/model/todo/assignedtable.dart';
import 'package:PlannerApp/model/todo/assignedtodopage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'model/event/list_event.dart';
import 'model/todo/edittodopage.dart';
import 'helper/utilities.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'ui/tab_page.dart';

GetIt  locator = GetIt();

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
              '/utilities': (BuildContext context) => todolistpage(title: "My Todo list"),
              '/addtodopage': (BuildContext context) => addtodo(title: "Add todo"),
              '/assignedtable': (BuildContext context) => assigneddatatable(title: "Assigned task list"),
              '/assignedtodopage': (BuildContext context) => assignedadd(),
              '/edittodopage': (BuildContext context) => edittodo(title: "Edit todo",id:0),
            }
          );
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
  String val;

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
              });
            },
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                title: Text("Todo list"),
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.alarm), title: Text("Alarm"))
            ]),
      ),
    );
  }

  Future<void> _gototodolistPage(context) async {
    await Navigator.pushNamed(context, '/utilities');
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
                decoration: InputDecoration(border: OutlineInputBorder()),
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

                DropdownButton(
                  value: val,
                  items: [
                    DropdownMenuItem(
                      child: Text("1"),
                      value: 1,
                    ),
                    DropdownMenuItem(
                      child: Text("2"),
                      value: 2,
                    ),
                    DropdownMenuItem(
                      child: Text("3"),
                      value: 3,
                    ),
                    DropdownMenuItem(
                      child: Text("4"),
                      value: 4,
                    ),
                  ],
                  hint: Text(
                    "Select Value",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  onChanged: (_val) {
                    setState(() {
                      val = _val;
                    });
                  },
                ),
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
      scheduledTime = DateTime.now().add(Duration(seconds: 3));
    } else if (_selectedParam == "Minute") {
      scheduledTime = DateTime.now().add(Duration(minutes: 1));
    } else {
      //slected hour
      scheduledTime = DateTime.now().add(Duration(hours: 1));
    }

    // var scheduledTime = DateTime.now().add(Duration(seconds: 5));

    flutterNotif.schedule(
        1, "Time Reached", task, scheduledTime, generalNotificationDetails);
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
