import 'dart:convert';
import 'package:flutter_php/models/histortModel.dart';
import 'package:flutter_php/screens/outlet/getOrderDetailComplete.dart';
import 'package:flutter_php/screens/user/getHistoryDetailUser.dart';
import 'package:flutter_php/screens/user/getOrderDoneDetail.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../../env.dart';
class GetHistoryOrder extends StatefulWidget {
   String id_outlet;
  GetHistoryOrder(this.id_outlet);
  @override
  _GetHistoryOrderState createState() => _GetHistoryOrderState();
}

class _GetHistoryOrderState extends State<GetHistoryOrder> {
  var loading = false;

  final listHistory = new List<HistoryModel>();
  Future<void> _lihatDataHistory() async {
    listHistory.clear();
    setState(() {
      loading = true;
    });
    print("object");
    print(widget.id_outlet);
    var body = {"id_outlet": widget.id_outlet};
    final response = await http.post(Env.getHistoryOrder, body: body);
    print(body);
    if (response.contentLength == 1) {
    } else {
      final data = jsonDecode(response.body);
      print(data);
      data.forEach((api) {
        final ab = new HistoryModel(
            api['id_review'],
            api['id_order'],
            api['id_user'],
            api['id_outlet'],
            api['nameCharacter'],
            api['series'],
            api['material'],
            api['desc'],
            api['phone'],
            api['address'],
            api['dateProduct'],
            api['createdDate'],
            api['image'],
            api['name'],
            api['imageUsers'],
            api['rangePrice'],
            api['isStatus'],
            api['review'],
            api['rating']);
        listHistory.add(ab);
      });
      setState(() {
        loading = false;
      });
      print(listHistory);
    }
  }

  rating(rating) {
    if (rating == "0") {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FaIcon(
            FontAwesomeIcons.star,
            color: Colors.orangeAccent,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            // child: rating(rating),
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
            child: Text(rating),
          )
        ],
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _lihatDataHistory();
  }

  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
 return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            "My History",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.lightBlueAccent),
      body: Container(
        child: RefreshIndicator(
          onRefresh: _lihatDataHistory,
          key: _refresh,
          child: loading
              ? Center(child: Container())
              : Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ListView.builder(
                    itemCount: listHistory.length,
                    itemBuilder: (context, i) {
                      final x = listHistory[i];
                      return GestureDetector(
                        onTap: () {
                          if (x.rating != '0') {
                            print("rest");
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => GetOrderDetailDone(
                                    x.id_review,
                                    x.id_outlet,
                                    x.id_order,
                                    x.id_user,
                                    x.imageProduct,
                                    x.date_product,
                                    x.nameCharacter,
                                    x.series,
                                    x.material,
                                    x.description,
                                    x.phone,
                                    x.address,
                                    x.nameUser,
                                    x.imageUser,
                                    x.rangePrice,
                                    x.review,
                                    x.rating,
                                    x.isStatus
                                   )));
                          } else if (x.rating == '0') {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => GetOrderDetailHistory(
                                    x.id_review,
                                    x.id_outlet,
                                    x.id_order,
                                    x.id_user,
                                    x.imageProduct,
                                    x.date_product,
                                    x.nameCharacter,
                                    x.series,
                                    x.material,
                                    x.description,
                                    x.phone,
                                    x.address,
                                    x.nameUser,
                                    x.imageUser,
                                    x.rangePrice,
                                    x.review,
                                    x.rating,
                                    x.isStatus)));
                          }
                        },
                        child: Card(
                          borderOnForeground: false,
                          color: Colors.white,
                          elevation: 3.0,
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            child: Row(
                              children: <Widget>[
                                Image.network(
                                  Env.imageLoader + x.imageProduct,
                                  height: 50.0,
                                  width: 70.0,
                                  fit: BoxFit.cover,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          x.nameCharacter,
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text("Deadline: " + x.date_product),
                                        Text("Date Order : " + x.created_date)
                                        // Text(money.format(int.parse(x.price))),
                                        // Text(x.id_user),
                                        // Text(x.name),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 0.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        // Center(child: status(x.isStatus)),
                                        // Center(child: Text(),),
                                        Center(
                                          child: rating(x.rating),
                                        )
                                        // Text("Deadline: " + x.date_product),
                                        // Text("Date Order : " + x.isStatus)
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
                        ),
                      );
                    },
                  ),
                ),
        ),
      ),
    );
  }
}