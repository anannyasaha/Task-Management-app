import 'package:PlannerApp/model/Speech/EditSpeech.dart';
import 'package:PlannerApp/model/todo/addtodopage.dart';
import 'package:PlannerApp/model/todo/assignedtable.dart';
import 'package:PlannerApp/model/todo/assignedtodopage.dart';
import 'package:PlannerApp/model/Speech/SpeechToText.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'model/Speech/speechgridview.dart';
import 'model/todo/edittodopage.dart';
import 'model/todo/utilities.dart';
import 'package:firebase_core/firebase_core.dart';
import 'model/event/list_event.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'ui/tab_page.dart';
import 'model/mapwork/map_view.dart';
import 'package:PlannerApp/model/mapwork/map_view.dart';
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
                    todolistpage(title: "Task list"),
                '/addtodopage': (BuildContext context) =>
                    addtodo(title: "Add task"),
                '/assignedtable': (BuildContext context) =>
                    assigneddatatable(title: "Assigned task list"),
                '/assignedtodopage': (BuildContext context) => assignedadd(),
                '/SpeechToText': (BuildContext context) =>
                    SpeechText(title: "Speech to Text"),
                '/edittodopage': (BuildContext context) =>
                    edittodo(title: "Edit task", id: 0),
                '/EditSpeech': (BuildContext context) => edit_speech(texttoedit: " "),
                '/speechgridview': (BuildContext context) => speechlist(),
                '/mapviewpage': (BuildContext context) =>
                    MapView(title: 'Location'),

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

  int hrs, mins, sec;

  var _controller = TextEditingController();
  var bright;

  @override
  void initState() {
    super.initState();

    //initialize notifications
    var androidInitialize = new AndroidInitializationSettings('app_icon');
    var iOSinitialize = new IOSInitializationSettings();
    var initializationsSettings =
        new InitializationSettings(androidInitialize, iOSinitialize);
    flutterNotif = new FlutterLocalNotificationsPlugin();
    flutterNotif.initialize(initializationsSettings,
        onSelectNotification: notificationSelected);

    //initialize cupertino themes
    bright = SchedulerBinding.instance.window.platformBrightness;
  }

  @override
  Widget build(BuildContext context) {
    List<LayoutExample> options = <LayoutExample>[
      LayoutExample(
        title: 'Reminder',
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
                  _gotomapviewPage(context);
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
                  icon: Icon(Icons.map), title: Text("Location"))
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

  Future<void> _gotomapviewPage(context) async {
    await Navigator.pushNamed(context, '/mapviewpage');
  }

  Widget listEvents() {
    return CalendarEvents();
  }

  Widget buildColumnWidget() {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.lightBlue, width: 3.0),
              ),
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
          ), SizedBox(height: 30.0),

          CupertinoTheme(
            data: CupertinoThemeData(
              textTheme: CupertinoTextThemeData(
                dateTimePickerTextStyle: TextStyle(
                  color: bright == Brightness.dark? Colors.white : Colors.black45,
                ),
              ),
            ),

            child: CupertinoTimerPicker(
              mode: CupertinoTimerPickerMode.hms,
              minuteInterval: 1,
              secondInterval: 1,
              initialTimerDuration: new Duration(),
              onTimerDurationChanged: (Duration _picked) {
                setState(() {
                  hrs = _picked.inHours;
                  mins = _picked.inMinutes;
                  sec = _picked.inSeconds;
                });
              },
            ),
          ), SizedBox(height: 30.0),

          FlatButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
                side: BorderSide(color: Colors.blueGrey)),
            onPressed: _showNotification,
            color: Colors.blue,
            textColor: Colors.white,
            child: new Text('Set Timed Reminder With Notification',
                style: new TextStyle(fontSize: 16.0)),
          )
        ],
      )
    );
  }

  Future _showNotification() async {
    var androidDetails = new AndroidNotificationDetails(
        "Project ID", "Group Project", "text...",
        importance: Importance.Max);
    var IOSDetails = new IOSNotificationDetails();
    var generalNotificationDetails =
        new NotificationDetails(androidDetails, IOSDetails);

    var scheduledTime = DateTime.now().add(Duration(hours: hrs, minutes: mins, seconds: sec));
    flutterNotif.schedule(1, "Time Reached ", task, scheduledTime, generalNotificationDetails);
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
