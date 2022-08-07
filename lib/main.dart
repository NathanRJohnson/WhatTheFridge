import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'item.dart';
import 'item_card.dart';
import 'dart:async';
import 'dart:convert';


//2f202849-15e7-11ed-b24f-005056a6bb13
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
  String _scanBarcode = 'Unknown';
  Bool canScan = Bool(true);
  List<Item> items = [
    Item(name: 'Banana', time_in_fridge: '5 days'),
    Item(name: 'Turkey', time_in_fridge: '2 days'),
    Item(name: 'Frutopia', time_in_fridge: '24 weeks'),
  ];

  Future<void> startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
        '#ff6666', 'Cancel', false, ScanMode.BARCODE)!
        .listen((barcode) => setState((){processScan(items, canScan, barcode);}));
    // processScan(items, barcode)
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      addItem(items, barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }


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
            startBarcodeScanStream();
        },
        icon: Icon(Icons.add),
      ),
    );
  }

}

void processScan(List<Item> items, Bool canScan, String barcode) async {
  if (!canScan.value){
    print("can't scan yet!");
    return;
  }

  // check barcode validity
  if (barcode.startsWith("-1")){
    // send badness notification
    return;
  }

  // api call
  canScan.value = false;
  String? itemName = await getNameFromCode(barcode);
  // api check
  if (itemName == null){
    canScan.value = true;
    return;
  }

  // send some sort of notification to let the user know scan was successful
  toast("Item added!");
  // add the item if successful
  addItem(items, itemName);
  // start a delay
  print('item added: ' + itemName);
  Timer(const Duration(milliseconds: 1500), () => canScan.value = true);
}

void addItem(List<Item> items, String item_name){
  print("inserted item");
  items.add(Item(name: item_name, time_in_fridge:  "2 weeks"));

}

Future<String?> getNameFromCode(String barcode) async{
  String url = 'world.openfoodfacts.org';
  String key = "7664c443d26607247ef9d99560ef4360";
  String path = '/api/v0/product/$barcode.json';
  String? itemName;
  try {
    //request
    print(url+path);
    Response res = await get(
        Uri.https(url, path),
    );
    // log(res.body);
    Map data = jsonDecode(res.body);
    print(data['product']['product_name']);
    if (data['product']['product_name'] != ''){
      itemName = data['product']['product_name'];
      print("Item is: " + itemName!);
    }

  } catch (exception) {
    print('caught error: $exception');
  }

  return itemName;
}

class Bool {
  late bool value;
  Bool (bool _b){
    value = _b;
  }
}

Future<bool?> toast(String message) {
  Fluttertoast.cancel();
  return Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      backgroundColor: Colors.redAccent,
      textColor: Colors.white,
      fontSize: 20.0);
}


