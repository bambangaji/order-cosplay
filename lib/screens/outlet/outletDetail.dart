import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_php/env.dart';
import 'package:flutter_php/models/outletDetailModel.dart';
import 'package:flutter_php/screens/user/order.dart';
import 'package:flutter_php/screens/outlet/productDetail.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OutletDetail extends StatefulWidget {
  // final OutletDetailModel model;
  final String id_outlet;
  final String idUser;

  OutletDetail(this.id_outlet, this.idUser);
  @override
  _OutletDetailState createState() => _OutletDetailState();
}

class _OutletDetailState extends State<OutletDetail> {
  // String idUser;
  // getPref() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   setState(() {
  //     idUser = preferences.getString("id");
  //     print("object");
  //     print("id : " + idUser);
  //   });
  // }

  var loading = false;
  final money = NumberFormat("#,##0", "en_US");
  final list = new List<OutletDetailModel>();
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  Future<void> _lihatData() async {
    print("idUser:" + widget.idUser);
    list.clear();
    setState(() {
      loading = true;
    });
    var body = {"id_outlet": widget.id_outlet};
    final response = await http.post(Env.outletDetail, body: body);
    print(body);
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
            api['series'],
            api['material'],
            api['image'],
            api['address'],
            api['city'],
            api['rating'],
            api['instagram'],
            api['facebook'],
            api['website']);
        list.add(ab);
      });
      setState(() {
        loading = false;
      });
    }
    print("asu");
    print(list.length);
  }

  dialogBuy(String id, image, name_product, price, idUser, qty) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: ListView(
              padding: EdgeInsets.all(16.0),
              shrinkWrap: true,
              children: <Widget>[
                Text(
                  "Are you sure want to buy this movie? ",
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
                            _buyProduct(
                                id, image, name_product, qty, idUser, price);
                            // Navigator.pop(context);
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

  _buyProduct(String id, image, name_product, qty, idUser, price) async {
    print(id);
    print(image);
    print(name_product);
    print(idUser);
    print(price);
    print(qty);
    // print(idUser);
    final body = {
      "id_product": id,
      "image": image,
      "name_product": name_product,
      "price": price,
      "qty": qty,
      "id_user": idUser
    };
    print(body);
    final response = await http.post(Env.outletDetail, body: body);
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

  goToOrder() {
    print(widget.idUser + widget.id_outlet);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Order(widget.idUser, widget.id_outlet)));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _lihatData();
    // getPref();
    // print("objectwad");
    // print(widget.model.id_outlet);
    print(widget.id_outlet);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: RefreshIndicator(
        onRefresh: _lihatData,
        key: _refresh,
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0),
              child: Container(
                alignment: Alignment(-1, 0),
                // child: Text(
                //   "Top movie this week!!!",
                //   textAlign: TextAlign.start,
                //   style:
                //       TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                // )
              ),
            ),
            loading
                ? Center(child: CircularProgressIndicator())
                : Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("./images/bg.png")
                      )
                    ),
                    height: 200,
                    child: ListView.builder(
                      // scrollDirection: Axis.horizontal,
                      itemCount: 1,
                      itemBuilder: (context, i) {
                        final x = list[i];
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 0, left: 0, right: 0.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: 50,
                              ),
                              Row(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left:8.0),
                                    child: Container(
                                      height: 100,
                                      width: 100,
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                          child: _status(x.image)),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, top: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            FaIcon(
                                              FontAwesomeIcons.houseUser,
                                              color: Colors.limeAccent,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Text(
                                                x.name_outlet,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            FaIcon(
                                              FontAwesomeIcons.city,
                                              color: Colors.grey[100],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Text(
                                                x.city,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            FaIcon(
                                              FontAwesomeIcons.whatsapp,
                                              color: Colors.greenAccent,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Text(
                                                x.no_hp,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Card(
                elevation: 2.0,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, bottom: 0.0, left: 20.0),
                      child: Container(
                          alignment: Alignment(-1, 0),
                          child: Text(
                            "Information Outlet",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          )),
                    ),
                    Divider(
                      thickness: 2,
                      height: 10,
                    ),
                    loading
                        ? Center(child: CircularProgressIndicator())
                        : Container(
                            height: 250,
                            child: ListView.builder(
                              // scrollDirection: Axis.horizontal,
                              itemCount: 1,
                              itemBuilder: (context, i) {
                                final x = list[i];
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      top: 0.0, left: 8, right: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 0, 8, 0),
                                            child: Text(
                                              "Address : " + x.address,
                                              softWrap: true,
                                              textAlign: TextAlign.justify,
                                              style: TextStyle(height: 1.3),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 0, 8, 0),
                                            child: Text(
                                              "Description : " + x.desc_outlet,
                                              softWrap: true,
                                              textAlign: TextAlign.justify,
                                              style: TextStyle(height: 1.3),
                                            ),
                                          ),
                                          Divider(
                                            color: Colors.blue,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left:8.0),
                                            child: Row(
                                              children: <Widget>[
                                                FaIcon(
                                                  FontAwesomeIcons.instagram,
                                                  color: Colors.purpleAccent,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(left:8.0),
                                                  child: Text(
                                                      x.instagram),
                                                ),
                                                
                                              ],
                                            ),
                                          ),
                                           Padding(
                                            padding: const EdgeInsets.only(left:8.0),
                                            child: Row(
                                              children: <Widget>[
                                                FaIcon(
                                                  FontAwesomeIcons.facebook,
                                                  color: Colors.lightBlue,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(left:8.0),
                                                  child: Text(
                                                      x.facebook),
                                                ),
                                                
                                              ],
                                            ),
                                          ),
                                           Padding(
                                            padding: const EdgeInsets.only(left:8.0),
                                            child: Row(
                                              children: <Widget>[
                                                FaIcon(
                                                  FontAwesomeIcons.weebly,
                                                  color: Colors.greenAccent,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(left:8.0),
                                                  child: Text(
                                                      x.website),
                                                ),
                                                
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          Divider(
                            color: Colors.lightBlue,
                          ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 0.0, bottom: 0.0, left: 20.0),
                      child: Container(
                          alignment: Alignment(-1, 0),
                          child: Text(
                            "Portofolio ",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          )),
                    ),
                    Divider(),
                    loading
                        ? Center(child: CircularProgressIndicator())
                        : Container(
                            height: 170,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: list.length,
                              itemBuilder: (context, i) {
                                final x = list[i];
                                return GestureDetector(
                                  onTap: () {
                                    print(x.id_product);
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProductDetail(x.id_product)));
                                    print(x.desc_outlet);
                                  },
                                  child: Card(
                                    elevation: 2.0,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, left: 8, right: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            height: 100,
                                            width: 100,
                                            padding: EdgeInsets.all(10.0),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(24.0),
                                                image: DecorationImage(
                                                  fit: BoxFit.fitWidth,
                                                  image: NetworkImage(
                                                    Env.imageLoader +
                                                        x.image_product,
                                                  ),
                                                )),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,

                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: Text(x.name_product),
                                              ),
                                              
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                      child: SizedBox(
                          height: 40,
                          width: double.infinity,
                          child: RaisedButton(
                            onPressed: () {
                              // print();
                              goToOrder();
                            },
                            color: Colors.lightBlueAccent,
                            shape: new RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            child: Text("Create Order",
                                style: TextStyle(color: Colors.white)),
                          )),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
