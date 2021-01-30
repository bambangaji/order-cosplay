import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_php/env.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:async/async.dart';

class Order extends StatefulWidget {
  final String id_outlet;
  final String id_user;
  Order(this.id_user, this.id_outlet);

  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<Order> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("uwu" + widget.id_outlet + widget.id_user);
    // getPref();
    // print("objectwad");
    // print(widget.model.id_outlet);
  }

  String nameCharacter, description, material, series, address, phone;
  final _key = new GlobalKey<FormState>();
  DateTime dateProduct = DateTime.now();
  File _imageFile;

  void showColoredToast() {
    Fluttertoast.showToast(
      msg: "Image file must be fill",
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.redAccent,
      textColor: Colors.white,
      gravity: ToastGravity.BOTTOM,
    );
  }

  submit() async {
    String formatDate = new DateFormat('yyyy-MM-dd').format(dateProduct);
    print(formatDate);
    try {
      var stream =
          http.ByteStream(DelegatingStream.typed(_imageFile.openRead()));
      var length = await _imageFile.length();
      var uri = Uri.parse(Env.order);
      var request = http.MultipartRequest("POST", uri);
      request.fields['nameCharacter'] = nameCharacter;
      request.fields['series'] = series;
      request.fields['material'] = material;
      request.fields['phone'] = phone;
      request.fields['address'] = address;
      request.fields['desc'] = description;
      request.fields['id_user'] = widget.id_user;
      request.fields['id_outlet'] = widget.id_outlet;
      request.fields['dateProduct'] = formatDate;
      print(request.fields);
      request.files.add(http.MultipartFile("image", stream, length,
          filename: path.basename(_imageFile.path)));
      var response = await request.send();
      if (response.statusCode > 2) {
        print("image upload");
        setState(() {
          // widget.reload();
          Navigator.pop(context);
        });
      } else {
        print("image failed");
      }
    } catch (e) {
      debugPrint("error $e");
    }
    // final response = await http.post(Env.addProduct, body: {
    //   "name_product": nameProduct,
    //   "qty": qty,
    //   "price": price.replaceAll(",", ""),
    //   "id_user": id
    // });
    // final data = jsonDecode(response.body);
    // int value = data['value'];
    // String pesan = data['message'];
    // if (value == 1) {
    //   print(pesan);
    //   setState(() {
    //     widget.reload();
    //     Navigator.pop(context);
    //   });
    // } else {
    //   print(pesan);
    // }
  }

  check() {
    final form = _key.currentState;
    if (_imageFile == null) {
      showColoredToast();
      
    } else {
      if (form.validate()) {
        form.save();
        dialogConfirm();
      }
      setState(() {
        _autovalidate = true;
      });
    }
  }

  var _autovalidate = false;
  _chooseImageGallery() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 1920.0, maxWidth: 1080.0);
    setState(() {
      _imageFile = image;
    });
  }

  dialogConfirm() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: ListView(
              padding: EdgeInsets.all(16.0),
              shrinkWrap: true,
              children: <Widget>[
                Center(
                    child: Text(
                  "Are these data already filled correctly?",
                  style: TextStyle(fontSize: 18.0),
                )),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // print(id_user);
                        },
                        child: Text(
                          "Back",
                          style: TextStyle(color: Colors.red),
                        )),
                    FlatButton(
                        onPressed: () {
                          submit();
                          Navigator.pop(context);
                          _key.currentState.reset();
                          setState(() {
                            _autovalidate = false;
                          });
                          // print(_autovalidate);
                          // print(_key);
                        },
                        child: Text(
                          "Confirm",
                          style: TextStyle(color: Colors.blue),
                        ))
                  ],
                ),
              ],
            ),
          );
        });
  }

  // _addOrder() async {
  //   // print("ashf"+id_user);
  //   final response = await http.post(Env.addOutlet, body: {
  //     "id_user": widget.id_user,
  //     "id_outlet": widget.id_outlet,
  //     "": ,
  //     "password": password
  //   });
  //   final data = jsonDecode(response.body);
  //   int value = data['value'];
  //   String pesan = data['message'];

  //   if (value == 1) {
  //     setState(() {
  //       Navigator.pop(context);
  //     });
  //     print("object");
  //   } else {
  //     print(pesan);
  //   }
  //   Navigator.pop(context);
  //   _key.currentState.reset();
  // }

  @override
  var placeholder = Container(
    width: double.infinity,
    height: 150.0,
    child: Image.asset('./images/Picture.png'),
  );

  Widget build(BuildContext context) {
    String formatDate = new DateFormat.yMMMd().format(dateProduct);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        centerTitle: true,
        title: Text("Form Order"),
      ),
      body: Form(
        autovalidate: _autovalidate,
        key: _key,
        child: Container(
          color: Colors.white,
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 5, 10.0, 0),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Photo Character", textAlign: TextAlign.left)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    width: double.infinity,
                    height: 150.0,
                    child: InkWell(
                      onTap: () {
                        _chooseImageGallery();
                      },
                      child: _imageFile == null
                          ? placeholder
                          : Image.file(
                              _imageFile,
                              fit: BoxFit.contain,
                            ),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 5, 10.0, 0),
                child: Row(
                  children: <Widget>[
                    Align(
                        alignment: Alignment.centerLeft,
                        child:
                            Text("Name Character", textAlign: TextAlign.left)),
                    Text(
                      "*",
                      style: TextStyle(color: Colors.red),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 5, 10.0, 5),
                child: TextFormField(
                  validator: (e) {
                    if (e.isEmpty) {
                      return "please insert Name Character";
                    }
                  },
                  onSaved: (e) => nameCharacter = e,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.rowing,
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
                      hintText: "Uciha Sasuke"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 5, 10.0, 0),
                child: Row(
                  children: <Widget>[
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Series", textAlign: TextAlign.left)),
                    Text(
                      "*",
                      style: TextStyle(color: Colors.red),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 5, 10.0, 5),
                child: TextFormField(
                  validator: (e) {
                    if (e.isEmpty) {
                      return "please insert Series Character";
                    }
                  },
                  onSaved: (e) => series = e,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.movie,
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
                      hintText: "Naruto"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 5, 10.0, 0),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Material", textAlign: TextAlign.left)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 5, 10.0, 5),
                child: TextFormField(
                  onSaved: (e) => material = e,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.category,
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
                      hintText: "PVC/Kayu/Busa Hati/Mika"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 5, 10.0, 0),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Decription Costum Play",
                        textAlign: TextAlign.left)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 5, 10.0, 5),
                child: TextFormField(
                  // expands: true,

                  onSaved: (e) => description = e,
                  maxLines: 4,
                  minLines: 2,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.description,
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
                      // border: ,
                      hintText: ""),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 5, 10.0, 0),
                child: Row(
                  children: <Widget>[
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Address", textAlign: TextAlign.left)),
                    Text(
                      "*",
                      style: TextStyle(color: Colors.red),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 5, 10.0, 5),
                child: TextFormField(
                  validator: (e) {
                    if (e.isEmpty) {
                      return "please insert Address";
                    }
                  },
                  onSaved: (e) => address = e,
                  decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FaIcon(
                          FontAwesomeIcons.houseUser,
                          color: Colors.blue,
                        ),
                      ),
                      border: new OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5.0),
                          topRight: Radius.circular(5.0),
                          bottomLeft: Radius.circular(5.0),
                          bottomRight: Radius.circular(5.0),
                        ),
                      ),
                      hintText: "Jl.xyz"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 5, 10.0, 0),
                child: Row(
                  children: <Widget>[
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text("WhatsApp", textAlign: TextAlign.left)),
                    Text(
                      "*",
                      style: TextStyle(color: Colors.red),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 5, 10.0, 5),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  validator: (e) {
                    if (e.isEmpty) {
                      return "please insert Number Whatsapp";
                    }
                  },
                  onSaved: (e) => phone = e,
                  decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FaIcon(
                          FontAwesomeIcons.whatsapp,
                          color: Colors.greenAccent,
                        ),
                      ),
                      border: new OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5.0),
                          topRight: Radius.circular(5.0),
                          bottomLeft: Radius.circular(5.0),
                          bottomRight: Radius.circular(5.0),
                        ),
                      ),
                      hintText: "08XX-XXXX-XXXX"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 5, 10.0, 5),
                child: Column(
                  children: <Widget>[
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Date Costum Play Use",
                            textAlign: TextAlign.left)),
                    TextFormField(
                        readOnly: true,
                        onTap: () {
                          DatePicker.showDatePicker(context,
                                  showTitleActions: true,
                                  minTime: DateTime.now(),
                                  // maxTime: DateTime.now() + "",
                                  theme: DatePickerTheme(
                                      headerColor: Colors.orange,
                                      backgroundColor: Colors.blue,
                                      itemStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                      doneStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16)), onChanged: (date) {
                            print('change $date in time zone ' +
                                date.timeZoneOffset.inHours.toString());
                          }, onConfirm: (date) {
                            print('confirm $date');
                            final dateProduct = date;
                            return dateProduct;
                          }, currentTime: DateTime.now(), locale: LocaleType.en)
                              .then((date) {
                            setState(() {
                              dateProduct = date;
                            });
                          });
                        },
                        decoration: InputDecoration(
                            border: new OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5.0),
                                topRight: Radius.circular(5.0),
                                bottomLeft: Radius.circular(5.0),
                                bottomRight: Radius.circular(5.0),
                              ),
                            ),
                            prefixIcon: Icon(
                              Icons.calendar_today,
                              color: Colors.blue,
                            ),
                            // labelText: "$formatDate",
                            hintText: "$formatDate")),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: SizedBox(
                          height: 40,
                          width: double.infinity,
                          child: RaisedButton(
                            onPressed: () {
                              check();
                            },
                            color: Colors.lightBlueAccent,
                            shape: new RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            child: Text("Confirm",
                                style: TextStyle(color: Colors.white)),
                          )),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomPicker extends CommonPickerModel {
  String digits(int value, int length) {
    return '$value'.padLeft(length, "0");
  }

  CustomPicker({DateTime currentTime, LocaleType locale})
      : super(locale: locale) {
    this.currentTime = currentTime ?? DateTime.now();
    this.setLeftIndex(this.currentTime.hour);
    this.setMiddleIndex(this.currentTime.minute);
    this.setRightIndex(this.currentTime.second);
  }

  @override
  String leftStringAtIndex(int index) {
    if (index >= 0 && index < 24) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String middleStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String rightStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String leftDivider() {
    return "|";
  }

  @override
  String rightDivider() {
    return "|";
  }

  @override
  List<int> layoutProportions() {
    return [1, 2, 1];
  }

  @override
  DateTime finalTime() {
    return currentTime.isUtc
        ? DateTime.utc(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            this.currentLeftIndex(),
            this.currentMiddleIndex(),
            this.currentRightIndex())
        : DateTime(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            this.currentLeftIndex(),
            this.currentMiddleIndex(),
            this.currentRightIndex());
  }
}
