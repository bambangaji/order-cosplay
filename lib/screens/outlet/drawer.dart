import 'package:flutter/material.dart';
import 'package:flutter_php/models/outletDetailModel.dart';
import 'package:flutter_php/models/outletLoginModel.dart';
import 'package:flutter_php/models/userModel.dart';
import 'package:flutter_php/screens/outlet/accountOutlet.dart';
import 'package:flutter_php/screens/outlet/addProductOutlet.dart';
import 'package:flutter_php/screens/outlet/getHistoryOrder.dart';
import 'package:flutter_php/screens/outlet/getOrder.dart';
import 'package:flutter_php/screens/outlet/listProductOutlet.dart';
import 'package:flutter_php/screens/outlet/outletHome.dart';
import 'package:flutter_php/screens/outlet/processOrder.dart';
import 'package:flutter_php/screens/outlet/settings.dart';
import 'package:http/http.dart' as http;
import 'package:responsive_container/responsive_container.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../env.dart';

import '../../env.dart';
class DrawerOutlet extends StatefulWidget {
  VoidCallback signOut;
  DrawerOutlet(this.signOut);
  @override
  _DrawerOutletState createState() => _DrawerOutletState();
}
class _DrawerOutletState extends State<DrawerOutlet> {
    signOut() {
    setState(() {
      widget.signOut();
    });
  }

final list = new List<OutletLoginModel>();
Future<void> _lihatData() async {
     await getPref();
    list.clear();
    setState(() {
      // loading = true;
    });
    // await getPref();
    print("object"+id);
    
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
        // loading = false;
      });
      print(list);
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _lihatData();
    getPref();

  }
  String id = "999";
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id = preferences.getString("id");
      print(id);
      print("asduin");
    });
  }
  // bool _key GlobalKey;
  @override
  Widget build(BuildContext context) {
  return DefaultTabController(
      length: 4,
      child: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.red[500],
        //   actions: <Widget>[
        //     IconButton(
        //       onPressed: () {
        //         signOut();
        //       },
        //       icon: Icon(Icons.lock_open),
        //     )
        //   ],
        // ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[ProductOutlet(list[0].id_outlet,id), GetOrderOutlet(list[0].id_outlet),GetHistoryOrder(list[0].id_outlet),AccountOutlet(widget.signOut,list[0].id_outlet)],
        ),
        bottomNavigationBar: Material(
          color: Colors.redAccent,
                  child: TabBar(
            
            isScrollable: false,
            labelColor: Colors.lightBlue[100],
            unselectedLabelColor: Colors.white,
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.home),
                text: ("Portofolio"),
              ),
              Tab(
                icon: Icon(Icons.shop),
                text: "List Order",
              ),
              Tab(
                icon: Icon(Icons.shop_two),
                text: "History",
              ),
              Tab(
                icon: Icon(Icons.settings),
                text: "Settings",
              )
            ],
          ),
        ),
      ),
    );
  }
}