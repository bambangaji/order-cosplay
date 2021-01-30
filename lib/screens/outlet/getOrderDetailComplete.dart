import 'dart:convert';

import 'package:flutter_php/screens/user/getHistoryDetailUser.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:responsive_container/responsive_container.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../env.dart';

class GetOrderDetailHistory extends StatefulWidget {
  String id_review;
  String id_outlet;
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
  String review;
  String rating;
  String id_user;
  String isStatus;
  GetOrderDetailHistory(
      this.id_review,
      this.id_outlet,
      this.id_order,
      this.id_user,
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
      this.review,
      this.rating,
      this.isStatus);
  @override
  _GetOrderDetailHistoryState createState() => _GetOrderDetailHistoryState();
}

class _GetOrderDetailHistoryState extends State<GetOrderDetailHistory> {
  String review;
  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      submit();
    }
  }

  submit() async {
    String rating = _rating.toString();
    print(rating);
    final body = {
      "id_order": widget.id_order,
      "review":review,
      "rating":rating
    };
    print(body);
    final response = await http.post(Env.rating, body: body);
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
      Navigator.pop(context);
      print(pesan);
    }
    Navigator.pop(context);
    print(_rating/2);
    print(review);
  }

  Widget _heading(String text) => Column(
        children: [
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 24.0,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
        ],
      );

  Widget _radio(int value) {
    return Expanded(
      child: RadioListTile(
        value: value,
        groupValue: _ratingBarMode,
        dense: true,
        title: Text(
          'Mode $value',
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 12.0,
          ),
        ),
        onChanged: (value) {
          setState(() {
            _ratingBarMode = value;
          });
        },
      ),
    );
  }

  Widget _ratingBar(int mode) {
    switch (mode) {
      case 1:
        return RatingBar(
          initialRating: 2,
          minRating: 1,
          direction: _isVertical ? Axis.vertical : Axis.horizontal,
          allowHalfRating: true,
          unratedColor: Colors.amber.withAlpha(50),
          itemCount: 5,
          itemSize: 50.0,
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => Icon(
            _selectedIcon ?? Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {
            setState(() {
              _rating = rating;
            });
          },
        );
      case 2:
        return RatingBar(
          initialRating: 3,
          direction: _isVertical ? Axis.vertical : Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          ratingWidget: RatingWidget(
              // full: _image('assets/heart.png'),
              // half: _image('assets/heart_half.png'),
              // empty: _image('assets/heart_border.png'),
              ),
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          onRatingUpdate: (rating) {
            setState(() {
              _rating = rating;
            });
          },
        );
      case 3:
        return RatingBar(
          initialRating: 3,
          direction: _isVertical ? Axis.vertical : Axis.horizontal,
          itemCount: 5,
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                return Icon(
                  Icons.sentiment_very_dissatisfied,
                  color: Colors.red,
                );
              case 1:
                return Icon(
                  Icons.sentiment_dissatisfied,
                  color: Colors.redAccent,
                );
              case 2:
                return Icon(
                  Icons.sentiment_neutral,
                  color: Colors.amber,
                );
              case 3:
                return Icon(
                  Icons.sentiment_satisfied,
                  color: Colors.lightGreen,
                );
              case 4:
                return Icon(
                  Icons.sentiment_very_satisfied,
                  color: Colors.green,
                );
              default:
                return Container();
            }
          },
          onRatingUpdate: (rating) {
            setState(() {
              _rating = rating;
            });
          },
        );
      default:
        return Container();
    }
  }

  final _key = new GlobalKey<FormState>();
  var _ratingController = TextEditingController();
  double _rating;
  double _userRating = 3.0;
  int _ratingBarMode = 1;
  bool _isRTLMode = false;
  bool _isVertical = false;
  IconData _selectedIcon;
  @override
  void initState() {
    _ratingController.text = "3.0";
    super.initState();
  }
   @override
  Widget build(BuildContext context) {
   return Scaffold(
        body: Form(
      key: _key,
      child: ListView(children: <Widget>[
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
                // Container(
                //   child: Directionality(
                //     textDirection:
                //         _isRTLMode ? TextDirection.rtl : TextDirection.ltr,
                //     child: SingleChildScrollView(
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.center,
                //         mainAxisSize: MainAxisSize.min,
                //         children: <Widget>[
                //           SizedBox(
                //             height: 40.0,
                //           ),
                //           _heading('Rating Bar'),
                //           _ratingBar(_ratingBarMode),
                //           SizedBox(
                //             height: 20.0,
                //           ),
                //           _rating != null
                //               ? Text(
                //                   "Rating: $_rating",
                //                   style: TextStyle(fontWeight: FontWeight.bold),
                //                 )
                //               : Container(),
                //           SizedBox(
                //             height: 40.0,
                //           ),
                //           Row(
                //             // mainAxisAlignment: MainAxisAlignment.center,
                //             children: <Widget>[],
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                // Container(
                //   decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(5.0),

                //       // color: Colors.lightBlue[100],
                //       border: Border.all(
                //           style: BorderStyle.solid, color: Colors.lightBlue)),
                //   child: Padding(
                //     padding: const EdgeInsets.only(left: 8.0),
                //     child: TextFormField(
                //       onSaved: (e) => review = e,
                //       maxLines: 2,
                //       minLines: 1,
                //     ),
                //   ),
                // ),
                Container(
                            padding: EdgeInsets.all(10.0),
                            child: Row(
                              children: <Widget>[
                                Image.network(
                                  Env.imageLoader + widget.image,
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
                                          widget.nameCharacter,
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text("Deadline: " + widget.deadline),
                                        
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
                          Center(child: Text("Wait Customer Give Rating",style: TextStyle(color: Colors.red,fontSize: 18),),)
              ],
              
            ),
          ),
        ),
        
      ]),
    ));

  }
}