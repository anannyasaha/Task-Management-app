class speech{
  String Description;
  speech(this.Description);
  int id;
  speech.from_map(Map<String,dynamic> map){
    this.id=map['id'];
    this.Description=map['Description'];
  }
  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'Description': this.Description,};
  }
  toString(){
    return '$id $Description';}
}