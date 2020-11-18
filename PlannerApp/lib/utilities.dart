import 'package:PlannerApp/model/todo/todo.dart';
import 'package:PlannerApp/model/todo/todomodel.dart';
import 'package:flutter/material.dart';
import 'main.dart';

class todolistpage extends StatefulWidget {
  String title;

  @override
  todolistpage({Key key,this.title}):super(key:key);
  _todolistpageState createState() => _todolistpageState();

}

class _todolistpageState extends State<todolistpage> {

  List<String> drawerItems=["All Tasks","Today","Tomorrow","Assigned task","Old tasks"];
  final _todomodel=new todomodel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
          title:Text(widget.title) ,
        actions:[IconButton(
          icon:Icon(Icons.arrow_back),
          onPressed: (){
           // _gotoeditpage();
            Navigator.of(context).pop();
          },
        ),IconButton(
          icon:Icon(Icons.add),
          onPressed:(){
            _gotoaddpage();


          }
        )]
    ),
      body:_createlistview(context),
      drawer: Drawer(
        child: Column(

          children: [
            Expanded(
              flex:1,
              child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color:Colors.white,
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
                 trailing: Icon(Icons.arrow_forward),
                onTap: () {
                   gettodolist();
                   },

                 ),

               ListTile(
                title: Text(drawerItems[1]),
                 trailing: Icon(Icons.arrow_forward),
                onTap: () {
               gettodaylist();
                },
              ),
               ListTile(
                 title: Text(drawerItems[2]),
                trailing: Icon(Icons.arrow_forward),
              onTap: () {
               gettomorrowlist();
                },
              ),
                ListTile(
                  title: Text(drawerItems[3]),
                  trailing: Icon(Icons.arrow_forward),
              onTap: () {
                    _gotoassignedlistpage();
              },
             ),
                ListTile(
                  title: Text(drawerItems[4]),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                    getOldtodos();
                  },
                ),
              ],
        ),
      ) ,]
      )
    )


    );

  }
  List<todo> _todos=[];
  Future<void> _gotoassignedlistpage() async{
    var todopage=await Navigator.pushNamed(context, '/assignedtable');
    gettodolist();

  }
  int _SelectedIndex=0;
  Future<void> _gotoaddpage() async{
    var todopage=await Navigator.pushNamed(context, '/addtodopage');

    gettodolist();

  }
  Future<void> getOldtodos()async{
    List<todo> alltodos=await _todomodel.deleteoldtodos();
    setState(() {
      _todos=alltodos;
    });

  }

  Future<void> gettodolist()async{
    List<todo> alltodos=await _todomodel.getAlltodos();
    setState(() {
      _todos=alltodos;
    });

  }
  Future<void> gettodaylist()async{
    List<todo> alltodofortoday=await _todomodel.gettodaytodos();
    setState(() {
      _todos=alltodofortoday;
    });

  }
  Future<void> gettomorrowlist()async{
    List<todo> alltodofortomorrow=await _todomodel.gettoomorrowtodos();
    setState(() {
      _todos=alltodofortomorrow;
    });

  }
  @override
  void initState() {
    super.initState();

    gettodolist();
  }
  Color whichColor(String Priority){
    if (Priority=="High")
      return Colors.red;
    else if(Priority=="Moderate") return Colors.yellow;
    else  return Colors.green;

  }
  List<bool> selected=List.generate(100, (index) => false);
  Widget _createlistview(BuildContext context){

    return ListView.builder(

        itemCount:_todos==null ? 0 : _todos.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              onTap: (){
                setState(() {
                  selected=List.generate(100, (index) => false);
                  selected[index]=!selected[index];
                  _SelectedIndex=index;

                });
              },
              child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide( //                   <--- left side
                          color: whichColor(_todos[index].priority),
                          width:6.0,
                        ),
                  )),
                  child: ListTile(

                    title: Text(_todos[index].description),
                    subtitle: Text(_todos[index].assignedto),
                    trailing: Text(_todos[index].date),
                    leading: CircleAvatar(

                        child: Text(_todos[index].time))
                  )
              )
          );
        }
    );
  }

}
