class Item {
  String name;
  String time_in_fridge;
  int? id;

  Item({ required this.name, required this.time_in_fridge, this.id});

  void setId(int _id){
    id = _id;
  }
}