import 'package:flutter/material.dart';

class todolistpage extends StatefulWidget {
  String title;
  @override

  todolistpage({Key key,this.title}):super(key:key);
  _todolistpageState createState() => _todolistpageState();
}

class _todolistpageState extends State<todolistpage> {
  List<String> drawerItems=["All Tasks","Today","Tomorrow","This week"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
          title:Text(widget.title) ,
    ),
      drawer: Drawer(
        child: Column(

          children: [
            Expanded(
              flex:1,
              child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/Stay-Organized.jpg"),
                          fit: BoxFit.contain
                      )
                  ),
                ),
              ),
            ),
            Expanded(
            flex: 2,
              child: ListView(children: [
                ListTile(
                title: Text(drawerItems[0]),
                 trailing: IconButton(
                   icon:Icon(Icons.add),

                 ),
               onTap: () {
                 Navigator.of(context).pop();
               },
               ),
               ListTile(
                title: Text(drawerItems[1]),
                 trailing: Icon(Icons.add),
                onTap: () {
               Navigator.of(context).pop();
                },
              ),
               ListTile(
                 title: Text(drawerItems[2]),
                trailing: Icon(Icons.add),
              onTap: () {
               Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text(drawerItems[3]),
                trailing: Icon(Icons.add),
              onTap: () {
                    Navigator.of(context).pop();
              },
             ),
              ],
        ),
      ) ,]
      )
    )
    );
  }

}
