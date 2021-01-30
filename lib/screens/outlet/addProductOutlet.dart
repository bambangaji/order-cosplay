import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_php/env.dart';
import 'package:flutter_php/models/currency.dart';
import 'package:flutter_php/models/outletLoginModel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:async/async.dart';

class AddProductOutlet extends StatefulWidget {
  String id_user;
  AddProductOutlet(this.id_user);
  @override
  _AddProductOutletState createState() => _AddProductOutletState();
}

class _AddProductOutletState extends State<AddProductOutlet> {
  final list = new List<OutletLoginModel>();
  String nameProduct, id,material,series,desc;

  Future<void> _lihatData() async {
    list.clear();
    setState(() {
      // loading = true;
    });
    // await getPref();
    print("object");
    print(id);
    var body = {"idUser": widget.id_user};
    final response = await http.post(Env.outletHome, body: body);
    print(body);
    if (response.contentLength == 1) {
    } else {
      final data = jsonDecode(response.body);
      print(data);
      data.forEach((api) {
        final ab = new OutletLoginModel(
            api['id_outlet'],
            api['id_user'],
            api['name_outlet'],
            api['no_hp'],
            api['desc_outlet'],
            api['latitude'],
            api['longitude'],
            api['image_outlet']);
        list.add(ab);
      });
      setState(() {
        // loading = false;
      });
      print(list);
    }
  }

  final _key = new GlobalKey<FormState>();
  File _imageFile;
  File _imageFile2;
  File _imageFile3;
  submit() async {
    try {
      // await _lihatData();
      var stream =
          http.ByteStream(DelegatingStream.typed(_imageFile.openRead()));
      var stream2 =
          http.ByteStream(DelegatingStream.typed(_imageFile2.openRead()));
      var stream3 =
          http.ByteStream(DelegatingStream.typed(_imageFile3.openRead()));
      var length = await _imageFile.length();
      var length2 = await _imageFile2.length();
      var length3 = await _imageFile3.length();
      var uri = Uri.parse(Env.outletAddPortofolio);
      var request = http.MultipartRequest("POST", uri);
       request.fields['id_user'] = widget.id_user;
      request.fields['id_outlet'] = list[0].id_outlet;
      request.fields['name_product'] = nameProduct;
      request.fields['material'] = material;
      request.fields['series'] = series;
      request.fields['desc'] = desc; 
      request.files.add(http.MultipartFile("image", stream, length,
          filename: path.basename(_imageFile.path)));
      request.files.add(http.MultipartFile("image2", stream2, length2,
          filename: path.basename(_imageFile2.path)));
      request.files.add(http.MultipartFile("image3", stream3, length3,
          filename: path.basename(_imageFile3.path)));
      var response = await request.send();
      print(request);
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
    if (form.validate()) {
      form.save();
      submit();
    }
  }

  _chooseImageGallery() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 1920.0, maxWidth: 1080.0);
    setState(() {
      _imageFile = image;
    });
  }

  _chooseImageGallery2() async {
    var image2 = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 1920.0, maxWidth: 1080.0);
    setState(() {
      _imageFile2 = image2;
    });
  }

  _chooseImageGallery3() async {
    var image3 = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 1920.0, maxWidth: 1080.0);
    setState(() {
      _imageFile3 = image3;
    });
  }
  // _chooseImageCamera() async {
  //   var image = await ImagePicker.pickImage(source: ImageSource.camera);
  //   setState(() {
  //     _imageFile = image;
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getPref();
    _lihatData();
  }

  @override
  Widget build(BuildContext context) {
    var placeholder = Container(
      width: double.infinity,
      height: 150.0,
      child: Image.asset('./images/Picture.png'),
    );
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Add Data Portofolio")),
        actions: <Widget>[
          SizedBox(
            width: 33,
          )
        ],
      ),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            Container(
              height: 200,
              width: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Container(
                      width: 200,
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
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: Container(
                        width: 200,
                        height: 150.0,
                        child: InkWell(
                          onTap: () {
                            _chooseImageGallery2();
                          },
                          child: _imageFile2 == null
                              ? placeholder
                              : Image.file(
                                  _imageFile2,
                                  fit: BoxFit.contain,
                                ),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: Container(
                        width: 200,
                        height: 150.0,
                        child: InkWell(
                          onTap: () {
                            _chooseImageGallery3();
                          },
                          child: _imageFile3 == null
                              ? placeholder
                              : Image.file(
                                  _imageFile3,
                                  fit: BoxFit.contain,
                                ),
                        )),
                  ),
                ],
              ),
            ),
            TextFormField(
              onSaved: (e) => nameProduct = e,
              decoration: InputDecoration(labelText: 'Name Character'),
            ),
            TextFormField(
              onSaved: (e) => series = e,
              decoration: InputDecoration(labelText: 'Series'),
            ),
              TextFormField(
              onSaved: (e) => material = e,
              decoration: InputDecoration(labelText: 'Material'),
            ),
            TextFormField(
              // inputFormatters: [
              //   WhitelistingTextInputFormatter.digitsOnly,
              //   CurrencyFormat()
              // ],
              onSaved: (e) => desc = e,
              decoration: InputDecoration(labelText: 'Description',
              ),
              // maxLength: 4,
              maxLines: 4,
              minLines: 2,
            ),
            MaterialButton(
              onPressed: () {
                check();
                print("asd"+widget.id_user);
                print(list[0].id_outlet);
              },
              child: Text("Submit"),
            )
          ],
        ),
      ),
    );
  }
}
