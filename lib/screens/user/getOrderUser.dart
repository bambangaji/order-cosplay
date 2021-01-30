import 'dart:convert';
import 'package:flutter_php/models/orderUser..dart';
import 'package:flutter_php/screens/outlet/getOrderDetailFinish.dart';
import 'package:flutter_php/screens/user/getHistoryDetailUser.dart';
import 'package:flutter_php/screens/user/getOrderDetail.dart';
import 'package:flutter_php/screens/user/getOrderDetailProcess.dart';
import 'package:flutter_php/screens/user/getOrderDetailUser.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_php/models/outletLoginModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../env.dart';

class OrderUser extends StatefulWidget {
  String id_user;
  OrderUser(this.id_user);
  @override
  _OrderUserState createState() => _OrderUserState();
}

class _OrderUserState extends State<OrderUser> {
  signOut() {
    setState(() {
      // widget.signOut();
    });
  }

  String id;
  var loading = false;
  final list = new List<OutletLoginModel>();
  final listOrder = new List<OrderUserModel>();
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
    listOrder.clear();
    setState(() {
      loading = true;
    });
    await getPref();
    print("object");
    print(widget.id_user);
    var body = {"id_user": widget.id_user};
    final response = await http.post(Env.getOrderUser, body: body);
    print(body);
    if (response.contentLength == 1) {
    } else {
      final data = jsonDecode(response.body);
      print(data);
      data.forEach((api) {
        final ab = new OrderUserModel(
            api['id_order'],
            api['id_user'],
            api['id_outlet'],
            api['nameCharacter'],
            api['series'],
            api['material'],
            api['desc'],
            api['phone_user'],
            api['address_user'],
            api['dateProduct'],
            api['createdDate'],
            api['image'],
            api['rangePrice'],
            api['isStatus'],
            api['address'],
            api['phone'],
            api['name_outlet'],
            api['pengiriman'],
            api['noResi']);
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

   status(isStatus) {
    if (isStatus == "waiting" || isStatus =="wait price" || isStatus =="reject") {
      return Text(
        isStatus,
        style: TextStyle(
            color: Colors.redAccent,
            fontSize: 16.0,
            fontWeight: FontWeight.bold),
      );
    } 
    else if(isStatus == "process"){
return Text(
        isStatus,
        style: TextStyle(
            color: Colors.orangeAccent,
            fontSize: 16.0,
            fontWeight: FontWeight.bold),
      );
    } 
    else {
      return Text(
        isStatus,
        style: TextStyle(
            color: Colors.green, fontSize: 16.0, fontWeight: FontWeight.bold),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            "My Orders",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.lightBlueAccent),
      body: Container(
        child: RefreshIndicator(
          onRefresh: _lihatDataOrder,
          key: _refresh,
          child: loading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ListView.builder(
                    itemCount: listOrder.length,
                    itemBuilder: (context, i) {
                      final x = listOrder[i];
                      return GestureDetector(
                        onTap: () {
                          if (x.isStatus == 'wait price') {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => GetOrderDetailFinish(
                                    x.id_order,
                                    x.imageProduct,
                                    x.date_product,
                                    x.nameCharacter,
                                    x.series,
                                    x.material,
                                    x.description,
                                    x.phone,
                                    x.address,
                                    x.name_outlet,
                                    x.phoneNumberOutlet,
                                    x.rangePrice,
                                    x.id_outlet,
                                    x.id_user
                                   )));
                          } else if(x.isStatus == 'process' || x.isStatus == 'waiting' || x.isStatus=='finish' || x.isStatus =="reject"){ 
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => GetOrderDetailProcess(
                                    x.id_order,
                                    x.imageProduct,
                                    x.date_product,
                                    x.nameCharacter,
                                    x.series,
                                    x.material,
                                    x.description,
                                    x.phone,
                                    x.address,
                                    x.name_outlet,
                                    x.rangePrice,
                                    x.imageProduct,
                                    x.id_outlet,
                                    x.id_user,
                                    x.isStatus,
                                    x.pengiriman,
                                    x.noResi
                                   )));
                          }
                        },
                        child: Card(
                          borderOnForeground: false,
                          color: Colors.white,
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
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 0.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Center(child: status(x.isStatus)),
                                        Center(child: Text(x.name_outlet),),
                                        Center(child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            FaIcon(FontAwesomeIcons.whatsapp,color: Colors.green,),Padding(
                                              padding: const EdgeInsets.only(left:8.0),
                                              child: SelectableText(x.phoneNumberOutlet),
                                            ),
                                          ],
                                        ),)
                                        // Text("Deadline: " + x.date_product),
                                        // Text("Date Order : " + x.isStatus)
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
      ),
    );
  }
}
