import 'dart:convert';
import 'package:flutter_php/models/order.dart';
import 'package:flutter_php/screens/outlet/addProductOutlet.dart';
import 'package:flutter_php/screens/outlet/getOrder.dart';
import 'package:flutter_php/screens/outlet/listProductOutlet.dart';
import 'package:flutter_php/screens/outlet/outletHome.dart';
import 'package:flutter_php/screens/outlet/processOrderDetail.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_php/models/outletLoginModel.dart';
import 'package:responsive_container/responsive_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../env.dart';

class ProcessOrder extends StatefulWidget {
    final VoidCallback signOut;
  final String idOutlet;
  ProcessOrder(this.signOut, this.idOutlet);
  @override
  _ProcessOrderState createState() => _ProcessOrderState();
}

class _ProcessOrderState extends State<ProcessOrder> {
  signOut() {
    setState(() {
      widget.signOut();
    });
  }
  String id;
  var loading = false;
  final list = new List<OutletLoginModel>();
  final listOrder = new List<OrderModel>();
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id = preferences.getString("id");
      print(id);
    });
  }

  savePref(String id) async {
    await getPref();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      print("savePref" + id);
      preferences.setString("id", id);
      preferences.commit();
    });
  }

  Future<void> _lihatDataOrder() async {
    list.clear();
    setState(() {
      loading = true;
    });
    await getPref();
    print("object");
    print(widget.idOutlet);
    var body = {"id_outlet": widget.idOutlet};
    final response = await http.post(Env.processOrder,body: body);
    print(body);
    if (response.contentLength == 1) {
    } else {
      final data = jsonDecode(response.body);
      print(data);
      data.forEach((api) {
        final ab = new OrderModel(
            api['id_order'],
            api['id_user'],
            api['id_outlet'],
            api['nameCharacter'],
            api['series'],
            api['material'],
            api['desc'],
            api['phone'],
            api['address'],
            api['dateProduct'],
            api['createdDate'],
            api['image'],
            api['name'],
            api['imageUsers'],
            api['rangePrice'],
            api['isStatus'],
            api['pengiriman'],
            api['noResi']
            );
        listOrder.add(ab);
      });
      setState(() {
        loading = false;
      });
      print(list);
    }
  }

  Future<void> _lihatData() async {
    list.clear();
    setState(() {
      loading = true;
    });
    await getPref();
    print("object");
    print(id);
    var body = {"idUser": id};
    final response = await http.post(Env.outletHome, body: body);
    print(body);
    if (response.contentLength == 1) {
    } else {
      final data = jsonDecode(response.body);
      print(data);
      data.forEach((api) {
        final ab = new OutletLoginModel(
            api['id_outlet'],
            api['id_user'],
            api['name_outlet'],
            api['no_hp'],
            api['desc_outlet'],
            api['latitude'],
            api['longitude'],
            api['image_outlet']);
        list.add(ab);
      });
      setState(() {
        loading = false;
      });
      print(list);
    }
  }

    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _lihatDataOrder();
    savePref(id);
    getPref();
    _lihatData();
  }
   final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
  return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              onPressed: () {
                signOut();
              },
              icon: Icon(Icons.lock_open),
            )
          ],
        ),
        
       body: RefreshIndicator(
onRefresh: _lihatData,
        key:_refresh ,
        child: loading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(5.0),
                child: ListView.builder(
                  itemCount: listOrder.length,
                  itemBuilder: (context, i) {
                    final x = listOrder[i];
                    return GestureDetector(
                      onTap: (){
                       Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProcessOrderDetail(x.id_order,x.imageProduct,x.date_product,x.nameCharacter,x.series,x.material,x.description,x.phone,x.address,x.nameUser,x.imageUser,x.rangePrice)));
                      },
                                          child: Card(
                        borderOnForeground: false ,
                        color: Colors.lightBlue[200],
                        elevation: 3.0,
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            children: <Widget>[
                              Image.network(
                                Env.imageLoader + x.imageProduct,
                                height: 50.0,
                                width: 70.0,
                                fit: BoxFit.cover,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left:8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        x.nameCharacter,
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text("Deadline: " + x.date_product),
                                      Text("Date Order : " + x.created_date) 
                                      // Text(money.format(int.parse(x.price))),
                                      // Text(x.id_user),
                                      // Text(x.name),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
        );
  }
}