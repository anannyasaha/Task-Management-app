import 'package:PlannerApp/model/todo/addtodopage.dart';
import 'package:flutter/material.dart';
import 'utilities.dart';
import 'tab_page.dart';
import 'list_view.dart';
import 'grid_view.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'App Planner',
        theme: ThemeData(
          primarySwatch: Colors.pink,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MainPage(title: 'Home Page'),
        routes: <String, WidgetBuilder>{
          '/utilities': (BuildContext context) =>
              todolistpage(title: "My Todo list"),
          '/addtodopage': (BuildContext context) => addtodo(title: "Add todo"),
        });
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
        builder: buildRowWidget,
      ),
    ];

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
              child: new Text('Set Task With Notification'),
            )
          ],
        ),
      ),
    );

    floatingActionButton:
    return DefaultTabController(
      length: options.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          bottom: buildTabBar(options),
        ),
        body: buildTabBarView(options),
        floatingActionButton: new FloatingActionButton(
          tooltip: "Add Event",
          child: new Icon(Icons.add),
          onPressed: () {
            print("Add Event");
          },
        ),
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

  Widget buildStackWidget() {
    return Stack(
      alignment: const Alignment(1.0, -0.5),
      children: <Widget>[
        CircleAvatar(
          radius: 100.0,
          backgroundColor: Colors.blue,
          child: Text(
            'RF',
            textScaleFactor: 4.0,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.black45,
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Text('Randy',
                style: TextStyle(fontSize: 20, color: Colors.white)),
          ),
        ),
      ],
    );
  }

  Future<void> _gototodolistPage(context) async {
    await Navigator.pushNamed(context, '/utilities');
  }

  Widget buildRowWidget() {
    return Container(
      height: 80.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 50.0,
            color: Colors.red,
          ),
          Container(
            width: 50.0,
            color: Colors.blue,
          ),
          Container(
            width: 50.0,
            color: Colors.green,
          ),
          Container(
            width: 50.0,
            color: Colors.amber,
          ),
        ],
      ),
    );
  }

  Widget buildColumnWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        FlutterLogo(
          size: 40.0,
          textColor: Colors.red,
        ),
        FlutterLogo(
          size: 40.0,
          textColor: Colors.blue,
        ),
        FlutterLogo(
          size: 40.0,
          textColor: Colors.green,
        ),
        FlutterLogo(
          size: 40.0,
          textColor: Colors.amber,
        ),
      ],
    );
  }

  Future _showNotification() async {
    var androidDetails = new AndroidNotificationDetails(
        "Project ID", "Group Project", "text...",
        importance: Importance.Max);
    var IOSDetails = new IOSNotificationDetails();
    var generalNotificationDetails =
        new NotificationDetails(androidDetails, IOSDetails);

    await flutterNotif.show(
        0, "Notification", "Test notification", generalNotificationDetails,
        payload: "Notification");

    // var scheduledTime = DateTime.now().add(Duration(seconds: 5));

    // flutterNotif.schedule(1, "Notification", "Schedules Notifcation",
    // scheduledTime, generalNotificationDetails)
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Center(
  //       child: RaisedButton(
  //         onPressed: _showNotifications,
  //         child: Text("Flutter Notifications"),
  //       ),
  //     ),
  //   );
  // }

  Future notificationSelected(String payload) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("Notification Clicked $payload"),
      ),
    );
  }
}
