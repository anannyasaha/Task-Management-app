class todo{
  String description;
  String priority;
  String date;
  String time;
  String assignedto;

  todo(this.description,this.priority,this.date,this.time,this.assignedto);
  int id;
  todo.from_map(Map<String,dynamic> map){
    this.id=map['id'];
    this.description=map['description'];
    this.priority=map['priority'];
    this.date=map['date'];
    this.time=map['time'];
    this.assignedto=map['assignedto'];

  }
  Map<String, dynamic> toMap() {
    return {
      'id':this.id,
      'description': this.description,
      'priority': this.priority,
      'date':this.date,
      'time':this.time,
      'assignedto':this.assignedto,

    };
  }
  toString(){
    return '$id $description $priority $date $time $assignedto';
  }

}