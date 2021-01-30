import 'dart:convert';
import 'package:flutter_php/main.dart';
import 'package:flutter_php/screens/outlet/addProductOutlet.dart';
import 'package:flutter_php/screens/outlet/drawer.dart';
import 'package:flutter_php/screens/outlet/getOrder.dart';
import 'package:flutter_php/screens/outlet/listProductOutlet.dart';
import 'package:flutter_php/screens/outlet/processOrder.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_php/models/outletLoginModel.dart';
import 'package:responsive_container/responsive_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../env.dart';

class OutletHome extends StatefulWidget {
  final VoidCallback signOut;
  OutletHome(this.signOut);
  @override
  _OutletHomeState createState() => _OutletHomeState();
}

class _OutletHomeState extends State<OutletHome> {
  String id;
  var loading = false;
  final list = new List<OutletLoginModel>();
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

  signOut()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", null);
      preferences.commit();
      _loginStatus = LoginStatus.notSignIn;
      print("data");
    });
  }
    LoginStatus _loginStatus = LoginStatus.notSignIn;

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
    savePref(id);
    getPref();
    _lihatData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              onPressed: () {
               widget.signOut();
              },
              icon: Icon(Icons.lock_open),
            )
          ],
        ),drawer: DrawerOutlet(widget.signOut),
        );
  }
}
