import 'package:flutter/material.dart';
import 'package:flutter_php/models/outletDetailModel.dart';
import 'package:flutter_php/models/userModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../env.dart';

class HomeAdmin extends StatefulWidget {
  @override
  _HomeAdminState createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  int list_outlet;
  int list_user;
  final listUser = new List<UserlistModel>();
  final list = new List<OutletDetailModel>();
  Future<void> _lihatData() async {
    list.clear();
    final response = await http.get(Env.outletMaps);
    if (response.contentLength == 1) {
    } else {
      final data = jsonDecode(response.body);
      print(data);
      data.forEach((api) {
        final ab = new OutletDetailModel(
            api['id_outlet'],
            api['name_outlet'],
            api['no_hp'],
            api['desc_outlet'],
            api['latitude'],
            api['longitude'],
            api['image'],
            api['id_product'],
            api['name_product'],
            api['qty'],
            api['price'],
            api['image_product'],
            api['address'],
            api['city'],
            api['rating'],
            api['instagram'],
            api['facebook'],
            api['website']);
        list.add(ab);
      });

      print(list.length);
    }
    setState(() {
      list_outlet = list.length;
    });
  }

  Future<void> _lihatDataUser() async {
    // list.clear();
    final response = await http.get(Env.getUser);
    if (response.contentLength == 1) {
    } else {
      final data = jsonDecode(response.body);
      print(data);
      data.forEach((api) {
        final ab = new UserlistModel(api['id_user']);
        listUser.add(ab);
      });
      print(listUser);
    }
    setState(() {
      list_user = listUser.length;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _lihatData();
    _lihatDataUser();
    print("menu");
  }

  @override
  Widget build(BuildContext context) {
    // print();
    return Container(
        child: Center(
      child: Container(
          // color: Colors.red,

          height: 200,
          width: 300,
          child: Card(
              // shape: ,
              color: Colors.lightBlueAccent[100],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "WELCOME ADMIN",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("List Outlet = "),
                        Text(
                          list_outlet.toString(),
                          style: TextStyle(color: Colors.red),
                        )
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("List User = "),
                      Text(
                        list_user.toString(),
                        style: TextStyle(color: Colors.red),
                      )
                    ],
                  ),
                ],
              ))),
    ));
  }
}
