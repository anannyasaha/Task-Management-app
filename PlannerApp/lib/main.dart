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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
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
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                      width: 100.0,
                      height: 60.0,
                      child: CupertinoPicker(
                        magnification: 1.1,
                        itemExtent: 40,
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
                        magnification: 1.1,
                        itemExtent: 40,
                        onSelectedItemChanged: (int index) {
                          val = index + 1;
                          print(val);
                        },
                        children: <Widget>[
                          Text("1",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                          Text("2",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                          Text("3",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                          Text("4",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                          Text("5",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                          Text("6",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                          Text("7",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                          Text("8",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                          Text("9",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                          Text("10",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                          Text("11",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                          Text("12",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                          Text("13",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                          Text("14",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                          Text("15",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                          Text("16",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                          Text("17",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                          Text("18",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                          Text("19",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                          Text("20",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                          Text("21",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                          Text("22",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                          Text("23",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                          Text("24",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                          Text("25",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                          Text("26",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                          Text("27",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                          Text("28",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                          Text("29",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                          Text("30",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                          Text("31",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                          Text("32",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                          Text("33",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                          Text("34",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                          Text("35",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                          Text("36",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                          Text("37",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                          Text("38",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                          Text("39",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                          Text("40",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                          Text("41",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                          Text("42",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                          Text("43",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                          Text("44",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                          Text("45",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                          Text("46",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                          Text("47",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                          Text("48",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                          Text("49",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                          Text("50",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                          Text("51",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                          Text("52",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                          Text("53",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                          Text("54",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                          Text("55",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                          Text("56",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                          Text("57",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                          Text("58",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                          Text("59",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none)),
                        ],
                      )),
                ],
              ),
            ),
            SizedBox(height: 10),
            FlatButton(
              minWidth: 340,
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
