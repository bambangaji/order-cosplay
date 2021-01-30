import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_php/env.dart';
import 'package:flutter_php/models/userModel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:async/async.dart';

class SettingsOutlet extends StatefulWidget {
  final String id_outlet;
  SettingsOutlet(this.id_outlet);
  @override
  _SettingsOutletState createState() => _SettingsOutletState();
}

class _SettingsOutletState extends State<SettingsOutlet> {
  File _imageFile;
  bool _secureText = true;
  String password, username, name, description,address,city,instagram,facebook,website,phone;
  var _autoValidate = false;
  final _key = new GlobalKey<FormState>();
  _chooseImageGallery() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 1920.0, maxWidth: 1080.0);
    setState(() {
      _imageFile = image;
    });
  }

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  final list = new List<UserModel>();
  var loading = false;
  Future<void> _lihatData() async {
    print("idUser:" + widget.id_outlet);
    list.clear();
    setState(() {
      loading = true;
    });
    var body = {"id_user": widget.id_outlet};
    final response = await http.post(Env.userDetail, body: body);
    print(body);
    if (response.contentLength == 1) {
    } else {
      final data = jsonDecode(response.body);
      print(data);
      data.forEach((api) {
        final ab = new UserModel(
          api['id_user'],
          api['username'],
          api['name_user'],
          api['desc_user'],
          api['status'],
          api['level'],
          api['imageUsers'],
        );
        list.add(ab);
      });
      setState(() {
        loading = false;
      });
    }
    print(list.length);
  }

  void showColoredToast() {
    Fluttertoast.showToast(
        msg: "Image file must be fill",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM,
        
        );
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
        _autoValidate = true;
      });
    }
  }

  submit() async {
    try {
      var stream =
          http.ByteStream(DelegatingStream.typed(_imageFile.openRead()));
      var length = await _imageFile.length();
      var uri = Uri.parse(Env.outletProfile);
      var request = http.MultipartRequest("POST", uri);
      request.fields['instagram'] = instagram;
      request.fields['facebook'] = facebook;
      request.fields['website'] = website;
      request.fields['phone'] = phone;
      request.fields['name_outlet'] = name;
      request.fields['city'] = city;
      request.fields['address'] = address;
      request.fields['desc_outlet'] = description;
      request.fields['id_outlet'] = widget.id_outlet;
      print(request.fields);
      request.files.add(http.MultipartFile("image", stream, length,
          filename: path.basename(_imageFile.path)));
      var response = await request.send();
      if (response.statusCode > 2) {
        print("image upload");
        setState(() {
          // widget.reload();
          //  Navigator.of(context).push(MaterialPageRoute(
          //       builder: (context) => Account(_lihatData)));
          Navigator.pop(context);
        });
      } else {
        print("image failed");
      }
    } catch (e) {
      debugPrint("error $e");
    }
  }

  Widget _status(status) {
    return Image.network(
      "https://semantic-ui.com/images/wireframe/image.png",
      height: 60.0,
      width: 60.0,
      fit: BoxFit.cover,
    );
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _lihatData();
  }
  @override
  Widget build(BuildContext context) {
     var placeholder = Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
      width: double.infinity,
      height: 150.0,
      child: Image.asset('./images/Picture.png'),
    );
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.lightBlueAccent,
          title: Text(
            "Profile",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Form(
          autovalidate: _autoValidate,
          key: _key,
          child: Align(
            alignment: Alignment(1, -1),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
              child: Container(
                height: double.infinity,
                child: Card(
                  elevation: 5.0,
                  // margin: EdgeInsets.all(5.0),
                  child: ListView(
                    padding: EdgeInsets.all(16.0),
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 105.0, right: 105.0),
                        child: InkWell(
                          onTap: () {
                            _chooseImageGallery();
                          },
                          child: Container(
                            height: 100,
                            width: 90,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(80.0),
                                child: _imageFile == null
                                    ? _status(_imageFile)
                                    : Image.file(
                                        _imageFile,
                                        height: 60.0,
                                        width: 60.0,
                                        fit: BoxFit.cover,
                                      )
                                ),
                          ),
                        ),
                      ),
                      TextFormField(
                        onSaved: (e) => name = e,
                        validator: (e) {
                          if (e.isEmpty) {
                            return "please insert Your Name";
                          }
                        },
                        decoration: InputDecoration(labelText: 'Name'),
                      ),
                      TextFormField(
                        validator: (e) {
                          if (e.isEmpty) {
                            return "please fill description";
                          }
                        },
                        onSaved: (e) => description = e,
                        decoration: InputDecoration(labelText: 'Description'),
                      ),
                       TextFormField(
                         validator: (e) {
                          if (e.isEmpty) {
                            return "please fill your address";
                          }
                        },
                        onSaved: (e) => address = e,
                        decoration: InputDecoration(labelText: 'Address'),
                      ),
                       TextFormField(
                         validator: (e) {
                          if (e.isEmpty) {
                            return "please insert City";
                          }
                        },
                        onSaved: (e) => city = e,
                        decoration: InputDecoration(labelText: 'City'),
                      ),
                       TextFormField(
                        onSaved: (e) => instagram = e,
                        decoration: InputDecoration(labelText: 'Instagram'),
                      ),
                       TextFormField(
                        onSaved: (e) => facebook = e,
                        decoration: InputDecoration(labelText: 'Facebook'),
                      ),
                       TextFormField(
                        onSaved: (e) => website = e,
                        decoration: InputDecoration(labelText: 'Website'),
                      ),
                       TextFormField(
                         validator: (e) {
                          if (e.isEmpty) {
                            return "please insert Your Phone Number";
                          }
                        },
                         keyboardType: TextInputType.number,
                        onSaved: (e) => phone = e,
                        decoration: InputDecoration(labelText: 'Phone'),
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
                            "Change",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));

  }
}