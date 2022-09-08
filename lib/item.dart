import 'dart:io';

class Item {
  String name;
  String? insert_date;
  String time_in_fridge;
  int? id;

  Item({ required this.name, required this.time_in_fridge, this.id});

  factory Item.fromJSON(dynamic json){
    String days = json['time_in_fridge'] as String;
    List<String> tokens = days.split(" ");
    int numDays = int.parse(tokens.first);
    String result = days;

    if (numDays >= 365) {
      int numYears = numDays % 365;
      result = "$numYears years";
    } else if (numDays >= 30) {
      int numMonths = numDays % 365;
      result = "$numMonths months";
    } else if (numDays >= 7) {
      int numWeeks = numDays % 7;
      result = "$numWeeks weeks";
    } else if (numDays == 0){
      result = "> 1 day";
    }

    return Item(name: json['name'] as String, time_in_fridge: result, id: json['id'] as int);
  }

  void setId(int _id){
    id = _id;
  }

  String getDays(dynamic insert_date){
    return "";
  }

  @override
  String toString() {
    return '{ $id, $name, $insert_date }';
  }
}