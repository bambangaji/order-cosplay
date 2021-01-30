import 'dart:convert';

import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_php/env.dart';
import 'package:flutter_php/models/reviewModel.dart';
import 'package:flutter_php/models/searchModel.dart';
import 'package:flutter_php/screens/outlet/outletDetail.dart';
import 'package:http/http.dart' as http;

class SearchOutlet extends StatefulWidget {
  String id_user;
  SearchOutlet(this.id_user);
  @override
  _SearchOutletState createState() => _SearchOutletState();
}

class _SearchOutletState extends State<SearchOutlet> {
  //  _lihatData()async{
  // final response = await http.post(Env.searchOutlet);
  // final data = jsonDecode(response.body);
  // print(data);
  // data.forEach((api) {
  //       final ab = new SearchModel(
  //           api['id_outlet'],
  //           api['name_outlet'],
  //           api['image']);
  //       _list.add(ab);
  //     });
  //     setState(() {
  //     });
  //   }

  List<Posts> _list = [];
  List<Posts> _search = [];
  var loading = false;
  Future<Null> fetchData() async {
    setState(() {
      loading = true;
    });
    _list.clear();
    final response = await http.get(Env.searchOutlet);
    final data = jsonDecode(response.body);
    print(data);
    setState(() {
      for (Map i in data) {
        _list.add(Posts.formJson(i));
        loading = false;
      }
    });
  }

  TextEditingController controller = new TextEditingController();

  onSearch(String text) async {
    _search.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _list.forEach((f) {
      if (f.nameOutlet.contains(text) || f.city.contains(text)) _search.add(f);
    });

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
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
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 10.0),
              color: Colors.lightBlueAccent,
              child: Card(
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.all(0),
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Icon(Icons.search),
                  ),
                  title: TextField(
                    controller: controller,
                    onChanged: onSearch,
                    decoration: InputDecoration(
                        hintText: "Search Outlet Name / City",
                        border: InputBorder.none),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      controller.clear();
                      onSearch('');
                    },
                    icon: Icon(Icons.cancel),
                  ),
                ),
              ),
            ),
            loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Expanded(
                    child: _search.length != 0 || controller.text.isNotEmpty
                        ? ListView.builder(
                            itemCount: _search.length,
                            itemBuilder: (context, i) {
                              final b = _search[i];
                              return Container(
                                  padding:
                                      EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      OutletDetail(b.id_outlet,
                                                          widget.id_user)));
                                        },
                                        child: Row(
                                          children: <Widget>[
                                            ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(80.0),
                                                child: _status(b.image)),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      b.nameOutlet,
                                                      style: TextStyle(
                                                        fontSize: 18.0,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                          )
                        : Container()),
          ],
        ),
      ),
    );
  }
}
