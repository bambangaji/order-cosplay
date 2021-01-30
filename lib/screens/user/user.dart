import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_php/env.dart';
import 'package:flutter_php/models/listOutletModel.dart';
import 'package:flutter_php/models/outletDetailModel.dart';
import 'package:flutter_php/models/productUserModel.dart';
import 'package:flutter_php/models/slopeOne.dart';
import 'package:flutter_php/screens/outlet/outletDetail.dart';
import 'package:flutter_php/screens/user/account.dart';
import 'package:flutter_php/screens/user/home.dart';
import 'package:flutter_php/screens/user/searchOutlet.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/productModel.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class User extends StatefulWidget {
  final VoidCallback signOut;
  User(this.signOut);

  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {
  String id_user;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id_user = preferences.getString("id");
      print("object");
      print(id_user);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(

          backgroundColor: Colors.lightBlueAccent,
          title: Text("Cosplay"),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                 Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SearchOutlet(id_user)));
              },
              icon: Icon(Icons.search),
            )
          ],
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[MenuUser(),Home(23,23),Account(widget.signOut)],
        ),
        bottomNavigationBar: Material(
          color: Colors.blue[300],
          child: TabBar(
            indicatorWeight: 2,
            indicatorColor: Colors.red,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white,
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.home),
                text: ("Home"),
              ),
              Tab(
                icon: Icon(Icons.place),
                text: "Maps",
              ),
              Tab(
                icon: Icon(Icons.person),
                text: "Account",
              )
              
              
            ],
          ),
        ),
      ),
    );
  }
}

class MenuUser extends StatefulWidget {
  @override
  _MenuUserState createState() => _MenuUserState();
}

class _MenuUserState extends State<MenuUser> {
  String idUser;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idUser = preferences.getString("id");
      print("object");
      print("id : " + idUser);
    });
  }

  var loading = false;
  final money = NumberFormat("#,##0", "en_US");
  final list = new List<ListOutletDetailModel>();
   final listSlopeOne = new List<SlopeOneModel>();
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  Future<void> _lihatData() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.get(Env.outletMaps);
    if (response.contentLength == 1) {
    } else {
      final data = jsonDecode(response.body);
      print(".....");
      print(data);
      data.forEach((api) {
        final ab = new ListOutletDetailModel(
            api['id_outlet'],
            api['name_outlet'],
            api['no_hp'],
            api['desc_outlet'],
            api['latitude'],
            api['longitude'],
            api['image_outlet'],
            api['address'],
            api['city'],
            api['rating'],
            api['instagram'],
            api['facebook'],
            api['website']
            );
        list.add(ab);
      });
      setState(() {
        loading = false;
      });
    }
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
    final response = await http.post(Env.buyProduct, body: body);
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
_lihatDataSlopeOne() async {
   list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.get(Env.listOutletSlopeOne);
    if (response.contentLength == 1) {
    } else {
      final data = jsonDecode(response.body);
      print(".....");
      print(data);
      data.forEach((api) {
        final ab = new SlopeOneModel(
            api['id_outlet'],
            api['name_outlet'],
            api['no_hp'],
            api['desc_outlet'],
            api['latitude'],
            api['longitude'],
            api['image_outlet'],
            api['address'],
            api['city'],
            api['rating'],
            api['instagram'],
            api['facebook'],
            api['website']
            );
        listSlopeOne.add(ab);
      });
      setState(() {
        loading = false;
      });
    }

}
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _lihatData();
    _lihatDataSlopeOne();
    getPref();
  }
rating(rating) {
  double rat = double.parse(rating);
  // rat = rating.toStringAsFixed(3);
    if (rat > 4) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FaIcon(
            FontAwesomeIcons.star,
            color: Colors.blueAccent,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child:Text(rat.toStringAsFixed(2)),
          )
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FaIcon(
            FontAwesomeIcons.star,
            color: Colors.orangeAccent,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(rat.toStringAsFixed(2)),
          )
        ],
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _lihatData,
        key: _refresh,
        child: Column(
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.only(top: 20.0, bottom: 5.0, left: 20.0),
              child: Container(
                  alignment: Alignment(-1, 0),
                  child: Text(
                    "Reccomend Outlet",
                    textAlign: TextAlign.start,
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  )),
            ),
            loading
                ? Center(child: CircularProgressIndicator())
                : Container(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: listSlopeOne.length,
                      itemBuilder: (context, i) {
                        final x = listSlopeOne[i];
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, left: 5, right: 2.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                 Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => OutletDetail(x.id_outlet,idUser)));
                                  print(x.id_outlet);
                                },
                                child: Card(
                                 shape:RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)
                            ,
                            side: BorderSide(
                            color: Colors.lightBlueAccent,
                            width: 1.1
                            )),
                                  child: Container(
                                  height: 183,
                                  width: 115,
                                  // padding: EdgeInsets.all(5.0),
                                  // decoration: BoxDecoration(
                                  //     borderRadius: BorderRadius.circular(24.0),
                                  //     image: DecorationImage(
                                  //       fit: BoxFit.fitWidth,
                                  //       image: NetworkImage(
                                  //         Env.imageLoader + x.image,
                                  //       ),
                                  //     )),
                                  child:  Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top:6.0),
                                      child: Container(
                                      height: 100,
                                      width: 100,
                                      padding: EdgeInsets.all(5.0),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(0.0),
                                          image: DecorationImage(
                                            fit: BoxFit.fitHeight,
                                            image: NetworkImage(
                                              Env.imageLoader + x.image,
                                            ),
                                          )),),
                                    ),
                                  ),
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 33,
                                        child: Text(x.name_outlet)),
                                    ),
                                  ),
                                 
                                  Center(
                                          child: rating(x.rating),
                                        )
                                  // Padding(
                                  //   padding: const EdgeInsets.only(top: 8.0),
                                  //   child: Text("IDR : " + x.price),
                                  // ),
                                ],
                              ),
                                ),
                                ),
                                
                              ),
                             
                            ],
                          ),
                        );
                      },
                    ),
                  ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 20.0, bottom: 15.0, left: 20.0),
              child: Container(
                  alignment: Alignment(-1, 0),
                  child: Text(
                    "List Outlet",
                    textAlign: TextAlign.start,
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  )),
            ),
            loading
                ? Center(child: CircularProgressIndicator())
                : Expanded(
                    // height: 200,
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 5.0,mainAxisSpacing: 1.0),
                      scrollDirection: Axis.vertical,
                      itemCount: list.length,
                      itemBuilder: (context, i) {
                        final x = list[i];
                        return Padding(
                          padding: const EdgeInsets.only(right:18.0,left: 18),
                          child: GestureDetector(
                            onTap: () {
                             Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => OutletDetail(x.id_outlet,idUser)));
                              print(x.id_outlet);
                            },
                            child: Card(
                             shape:RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)
                            ,
                            side: BorderSide(
                            color: Colors.lightBlueAccent,
                            width: 1.1
                            )),
                              child: Container(
                              height: 183,
                              width: 115,
                              // padding: EdgeInsets.all(5.0),
                              // decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.circular(24.0),
                              //     image: DecorationImage(
                              //       fit: BoxFit.fitWidth,
                              //       image: NetworkImage(
                              //         Env.imageLoader + x.image,
                              //       ),
                              //     )),
                              child:  Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top:6.0),
                                  child: Container(
                                  height: 100,
                                  width: 100,
                                  padding: EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(0.0),
                                      image: DecorationImage(
                                        fit: BoxFit.fitHeight,
                                        image: NetworkImage(
                                          Env.imageLoader + x.image,
                                        ),
                                      )),),
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 33,
                                    child: Text(x.name_outlet)),
                                ),
                              ),
                             
                              Center(
                                      child: rating(x.rating),
                                    )
                              // Padding(
                              //   padding: const EdgeInsets.only(top: 8.0),
                              //   child: Text("IDR : " + x.price),
                              // ),
                            ],
                          ),
                            ),
                            ),
                            
                          ),
                        );
                      },
                    ),
                  ),
           
          ],
        ),
      ),
    );
  }
}

class ProductUser extends StatefulWidget {
  @override
  _ProductUserState createState() => _ProductUserState();
}

class _ProductUserState extends State<ProductUser> {
   final money = NumberFormat("#,##0","en_US");
  String idUser;
  var loading = false;
  final list = new List<ProductUserModel>();
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idUser = preferences.getString("id");
      print("object");
      print("id : " + idUser);
    });
  }

  Future<void> _lihatData() async {
    list.clear();
    setState(() {
      loading = true;
    });
    await getPref();
    var body = {"idUser": idUser};
    print(body);
    final response = await http.post(Env.productUser, body: body);

    final data = jsonDecode(response.body);
    print("data");
    print(data);
    data.forEach((api) {
      final ab = new ProductUserModel(
          api['id_product'],
          api['name_product'],
          api['buyDate'],
          api['idUser'],
          api['price'],
          api['qty'],
          api['image']);
      list.add(ab);
    });
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
    _lihatData();
    print("init");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _lihatData,
        key: _refresh,
        child: loading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(5.0),
                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    final x = list[i];
                    return Card(
                      borderOnForeground: false ,
                      color: Colors.lightBlue[200],
                      elevation: 3.0,
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          children: <Widget>[
                            Image.network(
                              Env.imageLoader + x.image,
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
                                      x.name_product,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text("price : " + money.format(int.parse(x.price))),
                                    Text("Date : " + x.buyDate) 
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
                    );
                  },
                ),
              ),
      ),
    );
  }
}
