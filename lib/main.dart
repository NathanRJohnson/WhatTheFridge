import 'package:flutter/material.dart';
import 'item.dart';
import 'item_card.dart';

void main() => runApp(MaterialApp(
  home: FridgeList(),
));

class FridgeList extends StatefulWidget {
  const FridgeList({Key? key}) : super(key: key);

  @override
  State<FridgeList> createState() => _FridgeListState();
}

// Data within widget cannot change
class _FridgeListState extends State<FridgeList> {

  List<Item> items = [
    Item(name: 'Banana', time_in_fridge: '5 days'),
    Item(name: 'Turkey', time_in_fridge: '2 days'),
    Item(name: 'Frutopia', time_in_fridge: '24 weeks'),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Nate\'s Fridge'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: Column(
        children: items.map( (item) => ItemCard(
            item: item,
            delete: () {
              setState(() {
                items.remove(item);
              });
            }
        )).toList(),
      ),
      floatingActionButton: IconButton(

        // open the barcode scanner

        onPressed: () {
          setState(() {
            addItem(items);
          });
        },
        icon: Icon(Icons.add),
      ),
    );
  }
}

void addItem(List<Item> items){
  items.add(Item(name: "Milk", time_in_fridge:  "2 weeks"));
}


