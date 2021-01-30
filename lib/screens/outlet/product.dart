import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_php/env.dart';
import 'package:flutter_php/models/outletDetailModel.dart';
import 'package:flutter_php/models/outletUser.dart';
import 'package:flutter_php/models/reviewModel.dart';
import 'package:http/http.dart' as http;

class Product extends StatefulWidget {
  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {
  //   final GlobalKey <RefreshIndicatorState> _refresh =
  // GlobalKey<RefreshIndicatorState>();
  // var loading = false;
  // final money = NumberFormat("#,##0","en_US");
  final list = new List<OutletUserModel>();
  Future<void> _lihatData() async {
    setState(() {
      loading = true;
    });
    list.clear();
    final response = await http.get(Env.listOutlet);
    if (response.contentLength == 1) {
    } else {
      final data = jsonDecode(response.body);
      print(data);
      data.forEach((api) {
        final ab = new OutletUserModel(api['id_outlet'], api['name_outlet'],
            api['city'], api['id_user'], api['image_outlet']);
        list.add(ab);
       setState(() {
        loading = false;
 
       });
              });
      print(list.length);
      print(list[1].image);
    }
  }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   _lihatData();
  //   print("menu");
  // }

  // // final list = new List<ProductModel>();
  // List<Posts> _list = [];
  // List<Posts> _search = [];
  var loading = false;
  // Future<Null> fetchData() async {
  //   setState(() {
  //     loading = true;
  //   });
  //   _list.clear();
  //   final response = await http.get(Env.searchOutlet);
  //   final data = jsonDecode(response.body);
  //   print(data);
  //   setState(() {
  //     for (Map i in data) {
  //       _list.add(Posts.formJson(i));
  //       loading = false;
  //     }
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      _lihatData();
    // fetchData();
  
  }

  Widget _status(status) {
    if (status == "") {
      return Image.network(
        "https://semantic-ui.com/images/wireframe/image.png",
        height: 60.0,
        width: 60.0,
        fit: BoxFit.cover,
      );
    } else {
      return Image.network(
        Env.imageLoader + status,
        height: 60.0,
        width: 60.0,
        fit: BoxFit.cover,
      );
    }
  }

  _deleteProduct(String id) async {
    final response = await http.post(Env.deleteOutlet, body: {"id_user": id});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      Navigator.pop(context);
    } else {
      print(pesan);
    }
  }

  dialogDelete(String id) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: ListView(
              padding: EdgeInsets.all(16.0),
              shrinkWrap: true,
              children: <Widget>[
                Text(
                  "Are you sure want to delete this outlet?",
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    SizedBox(
                      height: 40,
                      width: 60,
                      child: RaisedButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          color: Colors.lightBlue,
                          onPressed: () {
                            _deleteProduct(id);
                          },
                          child: Text("Yes",
                              style: TextStyle(color: Colors.white))),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    SizedBox(
                      height: 40,
                      width: 60,
                      child: RaisedButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          color: Colors.red,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "No",
                            style: TextStyle(color: Colors.white),
                          )),
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, i) {
                  final b = list[i];
                  return Container(
                      padding: EdgeInsets.fromLTRB(10.0, 10, 10.0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              print(b.id_user);
                              dialogDelete(b.id_user);
                            },
                            child: Row(
                              children: <Widget>[
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(80.0),
                                    child: _status(b.image)),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          b.name_outlet,
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 4.0,
                                        ),
                                        Text(b.city),

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
                          Divider(
                            color: Colors.lightBlue,
                          )
                        ],
                      ));
                },
              ));
  }
}
