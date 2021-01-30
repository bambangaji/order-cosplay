import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_php/env.dart';
import 'package:flutter_php/main.dart';
import 'package:flutter_php/models/outletDetailModel.dart';
import 'package:flutter_php/screens/outlet/drawer.dart';
import 'package:flutter_php/screens/outlet/editProduck.dart';
import 'package:flutter_php/screens/outlet/productDetail.dart';
import 'package:responsive_container/responsive_container.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './addProduct.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'addProductOutlet.dart';
import 'outletHome.dart';

class ProductOutlet extends StatefulWidget {
  // final VoidCallback signOut;
  final String idOutlet;
  final String id_user;
  ProductOutlet(this.idOutlet, this.id_user);
  @override
  _ProductOutletState createState() => _ProductOutletState();
}

class _ProductOutletState extends State<ProductOutlet> {
  var loading = false;
  final money = NumberFormat("#,##0", "en_US");
  final list = new List<OutletDetailModel>();
  // final dataProduct = new List<OutletDetailModel>();
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();
  // final GlobalKey<RefreshIndicatorState> _refresh2 =
  //     GlobalKey<RefreshIndicatorState>();

  String id;

  Future<void> _lihatData() async {
    print(widget.idOutlet);
    list.clear();
    setState(() {
      loading = true;
    });
    var body = {"id_outlet": widget.idOutlet};
    final response = await http.post(Env.outletDetail, body: body);
    if (response.contentLength == 1) {
    } else {
      final data = jsonDecode(response.body);
      print(data);
      data.forEach((api) {
        final ab = new OutletDetailModel(
            api['id_outlet'],
            api['name_outlet'],
            api['phone'],
            api['desc_outlet'],
            api['latitude'],
            api['longitude'],
            api['image_outlet'],
            api['id_product'],
            api['name_product'],
            api['material'],
            api['series'],
            api['image'],
            api['address'],
            api['city'],
            api['rating'],
            api['instagram'],
            api['facebook'],
            api['description_product']);
        list.add(ab);
      });
      setState(() {
        loading = false;
      });
    }
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id = preferences.getString("id");
      print("eres" + id);
    });
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
                  "Are you sure want to delete this product?",
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
                            Navigator.pop(context);
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

  _deleteProduct(String id) async {
    final response =
        await http.post(Env.deleteProduct, body: {"id_product": id});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      setState(() {
        _lihatData();
      });
    } else {
      print(pesan);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
    //  _lihatDataProduct();
    _lihatData();
    print(widget.idOutlet);
    print("ini id" + widget.id_user);
    // print(widget.signOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Portofolio"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddProductOutlet(widget.id_user)));
          }),
      body: RefreshIndicator(
        onRefresh: _lihatData,
        key: _refresh,
        child: loading
            ? Center(
                child: Container(
                child: Center(
                  child: Text("Please Input Your First Portofolio Product"),
                ),
              ))
            : ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, i) {
                  final x = list[i];
                  return GestureDetector(
                    onTap: () {
                      // print(x.id_product);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ProductDetail(x.id_product)));
                    },
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        children: <Widget>[
                          Image.network(
                            Env.imageLoader + x.image_product,
                            height: 100.0,
                            width: 150.0,
                            fit: BoxFit.cover,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    x.name_product,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(x.price),
                                ),
                                // Text(money.format(int.parse(x.price))),
                                // Text(x.id_user),
                                // Text(x.name),
                              ],
                            ),
                          ),
                          IconButton(
                            // onPressed: () {
                            //   print(x.id_user);
                            // Navigator.of(context).push(MaterialPageRoute(
                            //   builder: (context)=>EditProduct(x,_lihatData
                            // )));
                            // },
                            onPressed: () {
                              print(x.qty);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => EditProduct(x)));
                            },
                            icon: Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () {
                              dialogDelete(x.id_product);
                            },
                            icon: Icon(Icons.delete),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
