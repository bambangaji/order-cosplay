import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_php/env.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:async/async.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

class Profile extends StatefulWidget {
  String latitude;
  String longitude;
  Profile(this.latitude, this.longitude);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // var uuid = new Uuid();
  var uuid = new Uuid(options: {'grng': UuidUtil.cryptoRNG});
  String nameOutlet, noHp, descOutlet, latitude, longitude, password, username;
  final _key = new GlobalKey<FormState>();
  File _imageFile;

  submit() async {
    try {
      var stream =
          http.ByteStream(DelegatingStream.typed(_imageFile.openRead()));
      var length = await _imageFile.length();
      var uri = Uri.parse(Env.addOutlet);
      var request = http.MultipartRequest("POST", uri);
      request.fields['nameOutlet'] = nameOutlet;
      request.fields['noHp'] = noHp;
      request.fields['descOutlet'] = descOutlet;
      request.fields['latitude'] = latitude;
      request.fields['longitude'] = longitude;
      request.files.add(http.MultipartFile("image", stream, length,
          filename: path.basename(_imageFile.path)));
      var response = await request.send();
      if (response.statusCode > 2) {
        print("image upload");
        // setState(() {
        //   // widget.reload();
        //   Navigator.pop(context);
        // });
      } else {
        print("image failed");
      }
    } catch (e) {
      debugPrint("error $e");
    }
  }

  String id_user;
  createId() {
    id_user = uuid.v1();
    print(id_user);
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      
      dialogConfirm();
    }
    var id_user = uuid.v4();
    print(id_user);
    setState(() {
      _autoValidate = true;
    });
  }

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  var _autoValidate = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.latitude);
    createId();
    // print(id_user);
  }

  _chooseImageGallery() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 1920.0, maxWidth: 1080.0);
    setState(() {
      _imageFile = image;
    });
  }

  bool _secureText = true;

  dialogConfirm() {
     id_user = uuid.v1();
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
                          print(id_user);
                        },
                        child: Text(
                          "Back",
                          style: TextStyle(color: Colors.red),
                        )),
                    FlatButton(
                        onPressed: () {
                          _addOutlet(id_user);
                          Navigator.pop(context);
                           _key.currentState.reset();
                          setState(() {
                            _autoValidate = false;
                          });
                          print(_autoValidate);
                          print(_key);
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

  _addOutlet(String id_user) async {
    print("ashf"+id_user);
    final response = await http.post(Env.addOutlet, body: {
      "id_user": id_user,
      "nameOutlet": nameOutlet,
      "username": username,
      "password": password
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    
    if (value == 1) {
      setState(() {
        Navigator.pop(context);
      });
      print("object");
    } else {
      print(pesan);
    }
    Navigator.pop(context);
    _key.currentState.reset();
  }

  @override
  Widget build(BuildContext context) {
    // var placeholder = Container(
    //   width: double.infinity,
    //   height: 150.0,
    //   child: Image.asset('./images/Picture.png'),
    // );
    return Scaffold(
      // appBar: AppBar(),
      body: Form(
        autovalidate: _autoValidate,
        key: _key,
        child: Align(
          alignment: Alignment(0, 0),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
            child: Container(
              height: 380,
              child: Card(
                elevation: 5.0,
                // margin: EdgeInsets.all(5.0),
                child: ListView(
                  padding: EdgeInsets.all(16.0),
                  children: <Widget>[
                    // Container(
                    //     width: double.infinity,
                    //     height: 150.0,
                    //     child: InkWell(
                    //       onTap: () {
                    //         _chooseImageGallery();
                    //       },
                    //       child: _imageFile == null
                    //           ? placeholder
                    //           : Image.file(
                    //               _imageFile,
                    //               fit: BoxFit.contain,
                    //             ),
                    //     )),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Center(
                          child: Text("Create Account Outlet",
                              style: TextStyle(
                                  fontSize: 20,
                                  decorationStyle: TextDecorationStyle.wavy,
                                  // decorationThickness: deco,

                                  decoration: TextDecoration.underline))),
                    ),
                    TextFormField(
                      onSaved: (e) => nameOutlet = e,
                      validator: (e) {
                        if (e.isEmpty) {
                          return "please insert Name Outlet";
                        }
                      },
                      decoration: InputDecoration(labelText: 'Name Outlet'),
                    ),
                    TextFormField(
                      onSaved: (e) => username = e,
                      validator: (e) {
                        if (e.length < 1) {
                          return "please insert username";
                        }
                      },
                      decoration: InputDecoration(labelText: 'Username'),
                    ),
                    TextFormField(
                      validator: (e) {
                        if (e.length < 8) {
                          return "minimal 8 character";
                        }
                      },
                      obscureText: _secureText,
                      onSaved: (e) => password = e,
                      decoration: InputDecoration(
                          labelText: 'Password',
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 18.0),
                          suffixIcon: IconButton(
                            onPressed: showHide,
                            icon: Icon(_secureText
                                ? Icons.visibility_off
                                : Icons.visibility),
                            color: Colors.grey,
                          )),
                      style: TextStyle(color: Colors.black87),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: MaterialButton(
                        minWidth: 300,
                        shape: new RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        color: Colors.lightBlueAccent,
                        onPressed: () {
                          check();
                          // dialogConfirm(id_user);
                        },
                        child: Text(
                          "Create",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: MaterialButton(
                        minWidth: 300,
                        shape: new RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        color: Colors.redAccent,
                        onPressed: () {
                          _key.currentState.reset();
                        },
                        child: Text(
                          "Reset",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
