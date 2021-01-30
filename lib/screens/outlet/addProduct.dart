import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_php/env.dart';
import 'package:flutter_php/models/currency.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:async/async.dart';

class AddProduct extends StatefulWidget {
  final VoidCallback reload;
  AddProduct(this.reload);
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  String nameProduct, qty, price, id;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id = preferences.getString("id");
    });
  }

  final _key = new GlobalKey<FormState>();
  File _imageFile;
  submit() async {
    try {
      var stream = http.ByteStream(DelegatingStream.typed(_imageFile.openRead()));
      var length = await _imageFile.length();
      var uri = Uri.parse(Env.addProduct);
      var request = http.MultipartRequest("POST", uri);
      request.fields['name_product'] = nameProduct;
      request.fields['qty'] = qty;
      request.fields['price'] = price.replaceAll(",", "");
      request.fields[ 'id_user'] = id;
      request.files.add(http.MultipartFile("image", stream , length ,
              filename: path.basename(_imageFile.path)));
              var response = await request.send();
              if(response.statusCode > 2){
                print("image upload");
                setState(() {
                  widget.reload();
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

  _chooseImageCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _imageFile = image;
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
    var placeholder = Container(
      width: double.infinity,
      height: 150.0,
      child: Image.asset('./images/Picture.png'),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("add Portofolio"),
      ),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            Container(
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
            TextFormField(
              onSaved: (e) => nameProduct = e,
              decoration: InputDecoration(labelText: 'Name Product'),
            ),
            TextFormField(
              onSaved: (e) => qty = e,
              decoration: InputDecoration(labelText: 'Quantity'),
            ),
            TextFormField(
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly,
                CurrencyFormat()
              ],
              onSaved: (e) => price = e,
              decoration: InputDecoration(labelText: 'Price'),
            ),
            MaterialButton(
              onPressed: () {
                check();
              },
              child: Text("Submit"),
            )
          ],
        ),
      ),
    );
  }
}
