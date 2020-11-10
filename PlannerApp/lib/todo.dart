class todo{
  String description;
  int priority;
  String date;
  String time;
  String assignedto;
  String repeated;
  todo.from_map(Map<String,dynamic> map){
    this.description=map['description'];
    this.priority=map['priority'];
    this.date=map['date'];
    this.time=map['time'];
    this.assignedto=map['assignedto'];
    this.repeated=map['repeated'];
  }
  Map<String, dynamic> toMap() {
    return {
      'description': this.description,
      'priority': this.priority,
      'date':this.date,
      'time':this.time,
      'assignedto':this.assignedto,
    'repeated':this.repeated,
    };
  }

}