import 'dart:convert';
import 'package:flutter_php/models/order.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:responsive_container/responsive_container.dart';
import '../../env.dart';

class GetOrderDetailUser extends StatefulWidget {
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
  String status;
  String pengiriman;
  String noResi;
  GetOrderDetailUser(
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
      this.rangePrice,
      this.status,
      this.pengiriman,
      this.noResi);
  @override
  _GetOrderDetailUserState createState() => _GetOrderDetailUserState();
}

class _GetOrderDetailUserState extends State<GetOrderDetailUser> {
  var loading = false;
  String pengiriman;
  String noResi;
  final _key = new GlobalKey<FormState>();
  final listOrder = new List<OrderModel>();
  var _autovalidate = false;

  check() {
    final form = _key.currentState;

    if (form.validate()) {
      form.save();
      print(pengiriman);
      _buyProduct(widget.id_order);
      Navigator.pop(context);
    }
    setState(() {
      _autovalidate = true;
    });
  }

  dialogBuy(String id_order) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Form(
              autovalidate: _autovalidate,
              key: _key,
              child: ListView(
                padding: EdgeInsets.all(16.0),
                shrinkWrap: true,
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Expedition Information",
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 5, 10.0, 2),
                    child: TextFormField(
                      validator: (e) {
                        if (e.isEmpty) {
                          return "please insert expedition name";
                        }
                      },
                      onSaved: (e) => pengiriman = e,
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.directions_car,
                            color: Colors.lightBlue,
                          ),
                          border: new OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5.0),
                              topRight: Radius.circular(5.0),
                              bottomLeft: Radius.circular(5.0),
                              bottomRight: Radius.circular(5.0),
                            ),
                          ),
                          hintText: "Expedition Name"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 5, 10.0, 10),
                    child: TextFormField(
                      validator: (e) {
                        if (e.isEmpty) {
                          return "please insert expedition name";
                        }
                      },
                      onSaved: (e) => noResi = e,
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.dvr,
                            color: Colors.lightBlue,
                          ),
                          border: new OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5.0),
                              topRight: Radius.circular(5.0),
                              bottomLeft: Radius.circular(5.0),
                              bottomRight: Radius.circular(5.0),
                            ),
                          ),
                          hintText: "Input Airway Bill Number"),
                    ),
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 40,
                          width: 120,
                          child: RaisedButton(
                              shape: new RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              color: Colors.lightBlue,
                              onPressed: () {
                                check();

                                setState(() {
                                  _autovalidate = true;
                                });
                              },
                              child: Text("Submit",
                                  style: TextStyle(color: Colors.white))),
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _buyProduct(String id_order) async {
    print(id_order);
    // print(idUser);
    final body = {
      "id_order": id_order,
      "pengiriman": pengiriman,
      "noResi": noResi
    };
    print(body);
    final response = await http.post(Env.acceptOrderFinish, body: body);
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

  price(price) {
    if (price == '0') {
      return new Container();
    } else {
      return new Center(
        child: Text(
          "Price: " + widget.rangePrice,
          style: TextStyle(fontSize: 18, color: Colors.red),
        ),
      );
    }
  }

  status(isStatus) {
    if (isStatus == "process") {
      return Padding(
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
                  color: Colors.lightGreen,
                  onPressed: () {
                    // showDialog(widget.id_order);
                    dialogBuy(widget.id_order);
                  },
                  shape: new RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Text("Order Finish",
                      style: TextStyle(color: Colors.white)),
                ),
              )
            ],
          ),
        ),
      );
    } else if (isStatus == "wait price") {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: Center(
            child: Text(
              "Wait for the user to accept the price that you had offered",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.orangeAccent,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    } else if (isStatus == "reject") {
      return Padding(
        padding: const EdgeInsets.only(top: 18.0),
        child: Center(
          child: Text(
            "Your price has been denied by user",
            style: TextStyle(
                color: Colors.red, fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 18.0),
        child: Center(
          child: Text(
            "Wait user to give rating",
            style: TextStyle(
                color: Colors.green,
                fontSize: 16.0,
                fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
  }

  pengirimanStatus(status) {
    if (status == "finish") {
      return Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Icon(
                Icons.directions_car,
                color: Colors.lightBlue,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "Expedition: ",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              Expanded(
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      widget.pengiriman,
                      softWrap: true,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Icon(
                Icons.dvr,
                color: Colors.lightBlue,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "Number Expedition: ",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              Expanded(
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      widget.noResi,
                      softWrap: true,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      );
    } else {}
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
                fit: BoxFit.fill,
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
                    Icon(
                      Icons.rowing,
                      color: Colors.lightBlue,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        "Name Character: ",
                        style: TextStyle(
                          fontSize: 18,
                        ),
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
                    Icon(
                      Icons.movie,
                      color: Colors.lightBlue,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        "Series: ",
                        style: TextStyle(
                          fontSize: 18,
                        ),
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
                    Icon(
                      Icons.category,
                      color: Colors.lightBlue,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        "Material: ",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Expanded(
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text(
                            widget.material,
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
                    Icon(
                      Icons.description,
                      color: Colors.lightBlue,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        "Description: ",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(40.0, 8, 8, 8),
                child: Text(
                  widget.desc,
                  style: TextStyle(fontSize: 18, color: Colors.blueGrey[600]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.person, color: Colors.lightBlue),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        "Name: ",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Expanded(
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          SelectableText(
                            widget.nameUser,
                            // softWrap: true,
                            style: TextStyle(color: Colors.lightBlue),
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
                    FaIcon(FontAwesomeIcons.whatsapp, color: Colors.green),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        "Whatssapp: ",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Expanded(
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          SelectableText(
                            widget.phone,
                            // softWrap: true,
                            style: TextStyle(color: Colors.green[700]),
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
                    FaIcon(
                      FontAwesomeIcons.houseUser,
                      color: Colors.blue,
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Address: ",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 8, 8, 8),
                child: Text(
                  widget.address,
                  style: TextStyle(fontSize: 18, color: Colors.blueGrey[600]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(1),
                child: pengirimanStatus(widget.status),
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
                  style: TextStyle(fontSize: 18, color: Colors.red),
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
                  child: price(widget.rangePrice)),
              Container(
                child: status(widget.status),
              )
            ],
          ),
        ),
      ),
    ]));
  }
}
