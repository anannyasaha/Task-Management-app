import 'package:flutter/material.dart';
import 'utilities.dart';
import 'tab_page.dart';
import 'list_view.dart';
import 'grid_view.dart';
import 'addtodopage.dart';
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
      routes:<String,WidgetBuilder>{'/utilities':(BuildContext context)=>
        todolistpage(title:"My Todo list"),
          '/addtodopage':(BuildContext context)=>
              addtodo(title:"Add todo"),}
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

    floatingActionButton:


    return DefaultTabController(
      length: options.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          bottom: buildTabBar(options),
        ),
        body: buildTabBarView(options),
        floatingActionButton:  new FloatingActionButton(
          tooltip: "Add Event",
          child: new Icon(Icons.add),
          onPressed: () {
            print("Add Event");
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (int index){
            setState(() {
              if(index==0){
                _gototodolistPage(context);
              }
            });
          },
          items:const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon:Icon(Icons.list),
              title:Text("Todo list"),

            ),
            BottomNavigationBarItem(
              icon:Icon(Icons.alarm),
              title:Text("Alarm")
            )

          ]
        ),
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
  Future<void> _gototodolistPage(context) async{
    await Navigator.pushNamed(context, '/utilities');}
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
}
