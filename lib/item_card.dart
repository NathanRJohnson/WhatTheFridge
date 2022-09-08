import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'item.dart';
class ItemCard extends StatelessWidget {
  final Item item;
  final Function() delete;
  ItemCard({required this.item, required this.delete});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(item.name,
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(width: 30.0),
          Text(item.time_in_fridge,
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(width: 2.0),
          IconButton(
          onPressed: delete,
          icon: Icon(Icons.cancel)
          ),
        ],
      ),
    );
  }
}