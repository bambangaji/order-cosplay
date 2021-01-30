import 'dart:convert';
import 'package:flutter_php/models/order.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_php/models/outletLoginModel.dart';
import 'package:responsive_container/responsive_container.dart';
import '../../env.dart';
class ProcessOrderDetail extends StatefulWidget {
  String id_order;
  String image;
  String deadline;
  String nameCharacter;
  String series;
  String material;
  String desc;
  String phone;
  String address;
  String nameUser;
  String rangePrice;
  String imageUser;
    ProcessOrderDetail(
      this.id_order,
      this.image,
      this.deadline,
      this.nameCharacter,
      this.series,
      this.material,
      this.desc,
      this.phone,
      this.address,
      this.nameUser,
      this.imageUser,
      this.rangePrice
      );
 
  @override
  _ProcessOrderDetailState createState() => _ProcessOrderDetailState();
}

class _ProcessOrderDetailState extends State<ProcessOrderDetail> {
   String rangePrice;
  String id;
  var loading = false;
  final list = new List<OutletLoginModel>();
  final listOrder = new List<OrderModel>();

  final _key = new GlobalKey<FormState>();
  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      _buyProduct(widget.id_order, rangePrice);
    }
  }

  dialogBuy(String id_order) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Form(
              key: _key,
              child: ListView(
                padding: EdgeInsets.all(16.0),
                shrinkWrap: true,
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Price",
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  TextFormField(onSaved: (e) => rangePrice = e),
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
                              check();
                              print(rangePrice);
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
            ),
          );
        });
  }

  _buyProduct(String id_order, String rangePrice) async {
    print(id_order);
    // print(idUser);
    final body = {"id_order": id_order, "rangePrice": rangePrice};
    print(body);
    final response = await http.post(Env.orderDone, body: body);
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      setState(() {
        Navigator.pop(context);
        // _lihatData();
        print(pesan);
      });
    } else {
      print(pesan);
    }
  }

  dialogDecline(String id_order) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: ListView(
              padding: EdgeInsets.all(16.0),
              shrinkWrap: true,
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Apakah kamu yakin menolak pesanan ini?",
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                TextFormField(),
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
                            _decline(widget.id_order);
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

  _decline(String id_order) async {
    print(id_order);
    final body = {
      "id_order": id_order,
    };
    print(body);
    final response = await http.post(Env.declineOrder, body: body);
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      setState(() {
        Navigator.pop(context);
        // _lihatData();
        print(pesan);
      });
    } else {
      print(pesan);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _lihatDataOrder();
    // _lihatData();
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
        body: ListView(children: <Widget>[
      GestureDetector(
        onTap: () {
          // print(widget.image_product);
          print(widget.image);
        },
        child: Container(
          height: 200,
          // width: 100,
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0.0),
              image: DecorationImage(
                fit: BoxFit.fitWidth,
                image: NetworkImage(
                  Env.imageLoader + widget.image,
                ),
              )),
        ),
      ),
      Card(
        child: ResponsiveContainer(
          widthPercent: 100,
          heightPercent: 70,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      "Name Character: ",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Expanded(
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text(
                            widget.nameCharacter,
                            softWrap: true,
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Series: ",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Expanded(
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text(
                            widget.series,
                            softWrap: true,
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Divider(
                  height: 2,
                  thickness: 1,
                  color: Colors.lightBlueAccent,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Material: " + widget.material,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Expanded(
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text(
                            widget.phone,
                            softWrap: true,
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Description: " + widget.desc,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Phone Number: " + widget.phone,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Address: " + widget.desc,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Divider(
                  height: 2,
                  thickness: 1,
                  color: Colors.lightBlueAccent,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Deadline: " + widget.deadline,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Divider(
                  height: 2,
                  thickness: 1,
                  color: Colors.red[300],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Divider(
                  height: 2,
                  thickness: 1,
                  color: Colors.red[300],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      new SizedBox(
                        height: 40,
                        width: 150.0,
                        child: RaisedButton(
                          color: Colors.lightBlueAccent,
                          onPressed: () {
                            // showDialog(widget.id_order);
                            dialogBuy(widget.id_order);
                          },
                          shape: new RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          child: Text("Accept Order",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      new SizedBox(
                        height: 40,
                        width: 150.0,
                        child: RaisedButton(
                          color: Colors.redAccent,
                          shape: new RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          onPressed: () {
                            //  _decline(id, image, name_product, qty, idUser, price)
                            dialogDecline(widget.id_order);
                          },
                          child: Text("Decline",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ]));

  }
}