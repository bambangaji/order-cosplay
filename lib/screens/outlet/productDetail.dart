import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_php/models/productDetailModel.dart';
import 'package:http/http.dart' as http;
import 'package:responsive_container/responsive_container.dart';

import '../../env.dart';

class ProductDetail extends StatefulWidget {
  final String id_product;
  ProductDetail(this.id_product);
  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  var loading = false;
  final money = NumberFormat("#,##0", "en_US");
  final list = new List<ProductUserModel>();
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  Future<void> _lihatData() async {
    print(widget.id_product);
    list.clear();
    setState(() {
      loading = true;
    });
    var body = {"id_product": widget.id_product};
    final response = await http.post(Env.detailProductOutlet, body: body);
    if (response.contentLength == 1) {
    } else {
      final data = jsonDecode(response.body);
      print(data);
      data.forEach((api) {
        final ab = new ProductUserModel(
            api['id_product'],
            api['name_product'],
            api['createdDate'],
            api['id_user'],
            api['price'],
            api['qty'],
            api['image'],
            api['image2'],
            api['image3'],
            api['series'],
            api['material'],
            api['description_product']);
        list.add(ab);
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                    color: Colors.blue,
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 1,
                      itemBuilder: (context, i) {
                        final x = list[i];
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 0, left: 0, right: 0.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  print(x.image);
                                  print(x.image2);
                                },
                                child: ResponsiveContainer(
                                  heightPercent: 100,
                                  widthPercent: 100,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                        image: DecorationImage(
                                          fit: BoxFit.fitWidth,
                                          image: NetworkImage(
                                            Env.imageLoader + x.image,
                                          ),
                                        )),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  print(x.image);
                                  print(x.image2);
                                },
                                child: ResponsiveContainer(
                                  heightPercent: 100,
                                  widthPercent: 100,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                        image: DecorationImage(
                                          fit: BoxFit.fitWidth,
                                          image: NetworkImage(
                                            Env.imageLoader + x.image2,
                                          ),
                                        )),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  print(x.image);
                                  print(x.image2);
                                },
                                child: ResponsiveContainer(
                                  heightPercent: 100,
                                  widthPercent: 100,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                        image: DecorationImage(
                                          fit: BoxFit.fitWidth,
                                          image: NetworkImage(
                                            Env.imageLoader + x.image3,
                                          ),
                                        )),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
            Container(
              height: 200,
              // child: ListView.builder(
                
              //     scrollDirection: Axis.horizontal,
              //     itemCount: 1,
              //     itemBuilder: (context, i) {
              //        final x = list[i];
              //       return Container(
              //         height: 200,
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: <Widget>[
                          // Padding(
                          //   padding: const EdgeInsets.only(top: 5.0),
                          //   child: Row(
                          //       mainAxisAlignment:
                          //           MainAxisAlignment.spaceBetween,
                          //       children: <Widget>[
                          //         Text("Name Character :"),
                          //         Align(
                          //           alignment: Alignment.topRight,
                          //           child: Text(
                          //             "PVC",
                          //             style:
                          //                 TextStyle(color: Colors.red[200]),
                          //           ),
                          //         ),
                          //       ]),
                          // ),
                        //   Padding(
                        //     padding: const EdgeInsets.only(top: 5.0),
                        //     child: Row(
                        //         mainAxisAlignment:
                        //             MainAxisAlignment.spaceBetween,
                        //         children: <Widget>[
                        //           Text("Series :"),
                        //           Align(
                        //             alignment: Alignment.topRight,
                        //             child: Text(
                        //               "PVC",
                        //               style:
                        //                   TextStyle(color: Colors.red[200]),
                        //             ),
                        //           ),
                        //         ]),
                        //   ),
                        //   Padding(
                        //     padding: const EdgeInsets.only(top: 8.0),
                        //     child: Row(
                        //         mainAxisAlignment:
                        //             MainAxisAlignment.spaceBetween,
                        //         children: <Widget>[
                        //           Text("Material :"),
                        //           Align(
                        //             alignment: Alignment.topRight,
                        //             child: Text(
                        //               "PVC",
                        //               style: TextStyle(color: Colors.blue),
                        //             ),
                        //           ),
                        //         ]),
                        //   ),
                        //   Padding(
                        //     padding:
                        //         const EdgeInsets.only(top: 5.0, bottom: 8.0),
                        //     child: Row(
                        //         mainAxisAlignment:
                        //             MainAxisAlignment.spaceBetween,
                        //         children: <Widget>[
                        //           Text("Description :"),
                        //         ]),
                        //   ),
                        //   Container(
                        //     height: 50,
                        //     width: double.infinity,
                        //     decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(5),
                        //         border: Border.all(color: Colors.grey)),
                        //     child: Padding(
                        //       padding: const EdgeInsets.all(8.0),
                        //       child: Text(
                        //         "PVC",
                        //         style: TextStyle(color: Colors.red[200]),
                        //       ),
                        //     ),
                        //   ),
                        // ],
                    //   ),
                    // );
              //     }),
             child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 1,
                      itemBuilder: (context, i) {
                        final x = list[i];
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 0, left: 0, right: 0.0),
                          child: Card(
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Container(
                                                          height: 200,
                                                          width: 370,
                                                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                  Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text("Name Character :"),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      x.name_product,
                                      style:
                                          TextStyle(color: Colors.red[200]),
                                    ),
                                  ),
                                ]),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text("Series :"),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      x.series,
                                      style:
                                          TextStyle(color: Colors.red[200]),
                                    ),
                                  ),
                                ]),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text("Material :"),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      x.material,
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                ]),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 5.0, bottom: 8.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text("Description"),
                                ]),
                          ),
                          Container(
                            height: 50,
                            width: 365,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.grey)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                x.description,
                                style: TextStyle(color: Colors.red[200]),
                              ),
                            ),
                          ),
                      
                              ],
                            ),
                                                        ),
                                                      ),
                          ),
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}
