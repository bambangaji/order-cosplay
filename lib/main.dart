import 'package:flutter/material.dart';
import 'package:flutter_php/env.dart';
import 'package:flutter_php/screens/admin/homeAdmin.dart';
import 'package:flutter_php/screens/outlet/drawer.dart';
import 'package:flutter_php/screens/outlet/outletHome.dart';
import 'package:flutter_php/screens/outlet/product.dart';
import 'package:flutter_php/screens/admin/profile.dart';
import 'package:flutter_php/screens/user/user.dart';
import 'package:device_info/device_info.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_id/device_id.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Login(),
  ));
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

enum LoginStatus { notSignIn, signIn, signInUsers ,signInOutlet}

class _LoginState extends State<Login> {
    var currentLocation;
    Position position;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo;

  String imei;
  String imeiID;
  String meid;
  String imeiId = 'unknow';
  

  @override
  void initState() {
    super.initState();
    getImei();
    getPref();
    fetchDeviceInfo();
    getLocation();
  }
  getLocation()async{
     Position res = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      position = res;
    });
    print(position);
    print("asu");
  }
  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    getImei();
  }
  fetchDeviceInfo() async {
    setState(() async {
      imei = await DeviceId.getIMEI;
    });
    
    
    imeiID = await DeviceId.getID;
    meid = await DeviceId.getMEID;
    androidInfo = await deviceInfo.androidInfo;
  }

  Future<void> getImei() async{
    String platform;
    try{
       platform = await ImeiPlugin.getImei();
       print(platform);
    
    }
    catch(e){
      platform='cannot get imei';
    }
    setState(() {
      imeiId=platform;
    });
    
  }
//   var imei = await ImeiPlugin.getImei();
// var uuid = await ImeiPlugin.getId();
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  String username;
  String password;
  String level;
  final _key = new GlobalKey<FormState>();
  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  var _autovalidate = false;
  check() async {
    print(position);
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      await getImei();
      login();
      print("$username,$password");
      // print(androidInfo.version.securityPatch);
      // print(androidInfo.manufacturer);
      print('imei');
      print(imeiId);
      // print(imeiID);
      // print(DeviceId.getIMEI);
    } else {
      setState(() {
        _autovalidate = true;
      });
    }
  }

  login() async {
    print("jalan ga");
    final response = await http
        .post(Env.login, body: {"username": username, "password": password});
    final data = jsonDecode(response.body);
    print(data);
    int value = data['value'];
    String pesan = data['message'];
    String usernameApi = data['username'];
    String nameApi = data['name'];
    String id = data['id'];
    String level = data['level'];
    if (value == 1) {
      if (level == "7") {
        setState(() {
          _loginStatus = LoginStatus.signIn;
          savePref(value, usernameApi, nameApi, id, level);
        });
      } else if (level == "1"){
        setState(() {
          _loginStatus = LoginStatus.signInUsers;
          savePref(value, usernameApi, nameApi, id, level);
        });
        print(pesan);
      }
      else {
        setState(() {
          _loginStatus = LoginStatus.signInOutlet;
          savePref(value, usernameApi, nameApi, id, level);
        });
      }
    } else {
      print(pesan);
    }
    print(data);
    print(level);
  }

  savePref(
      int value, String username, String name, String id, String level) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
      preferences.setString("name", name);
      preferences.setString("username", username);
      preferences.setString("id", id);
      preferences.setString("level", level);
      preferences.commit();
    });
  }

  var value;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getString("level");
      _loginStatus = value == "7"
          ? LoginStatus.signIn
          : value == "1" ? LoginStatus.signInUsers : value == "2" ? LoginStatus.signInOutlet : LoginStatus.notSignIn;
    });
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", null);
      preferences.commit();
      _loginStatus = LoginStatus.notSignIn;
      print("data");
    });
  }

  

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.notSignIn:
        return Scaffold(
          body: Stack(
            alignment: Alignment(0, -1),
            children: <Widget>[
              Container(
                // height: 1000,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      alignment:Alignment(0, -0.7) ,
                      fit: BoxFit.none,
                        image: AssetImage(
                          "./images/USNI.png",
                        ),
                        ),
                    color: Colors.lightBlueAccent
                    ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: 240.0,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25.0),
                      topRight: Radius.circular(25.0),
                    ),
                  ),
                  child: Form(
                      key: _key,
                      autovalidate: _autovalidate,
                      child: ListView(padding: EdgeInsets.all(16.0), children: <
                          Widget>[
                            // Text("Manufacturer: ${androidInfo.manufacturer}"),
                        TextFormField(
                          validator: (e) {
                            if (e.isEmpty) {
                              return "please insert username";
                            }
                          },
                          onSaved: (e) => username = e,
                          decoration: InputDecoration(
                              fillColor: Colors.black87,
                              hintText: "Username",
                              hintStyle: TextStyle(
                                  color: Colors.grey, fontSize: 18.0)),
                          style: TextStyle(color: Colors.black87),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 19.0),
                          child: TextFormField(
                            validator: (e) {
                              if (e.isEmpty) {
                                return "please insert password";
                              }
                            },
                            obscureText: _secureText,
                            onSaved: (e) => password = e,
                            decoration: InputDecoration(
                                hintText: "Password",
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 18.0),
                                suffixIcon: IconButton(
                                  onPressed: showHide,
                                  icon: Icon(_secureText
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                  color: Colors.grey,
                                )),
                            style: TextStyle(color: Colors.black87),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 40.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              
                              new SizedBox(
                                height: 40,
                                width: 150.0,
                                child: FlatButton(
                                  // color: Colors.redAccent,
                                  // shape: new RoundedRectangleBorder(
                                  //     borderRadius:
                                  //         BorderRadius.circular(30.0)),
                                  hoverColor: Colors.cyanAccent,
                                  splashColor: Colors.red[100],
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => Register()));
                                  },
                                  child: Text("Create Account",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.red)),
                                ),
                              ),
                              new SizedBox(
                                height: 40,
                                width: 150.0,
                                child: RaisedButton(
                                  color: Colors.lightBlueAccent,
                                  onPressed: () {
                                    check();
                                    print("ugb"+Env.urlBase);
                                  },
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(5.0)),
                                  child: Text("Login",
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ])),
                ),
              )
            ],
          ),
        );
        break;
      case LoginStatus.signIn:
        return MainMenu(signOut);
        break;
      case LoginStatus.signInUsers:
        return User(signOut);
        break;
        case LoginStatus.signInOutlet:
        return DrawerOutlet(signOut);
        break;
    }
  }
}

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  
  String username, password, name;
  final _key = GlobalKey<FormState>();
  bool _secureText = true;
  var uuid = new Uuid(options: {'grng': UuidUtil.cryptoRNG});
  
  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  var _autoValidate = false;
  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      save();
      print("$name,$username,$password");
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  save() async {
    var id_user = uuid.v1();
    print(id_user);
    final response = await http.post(Env.register,
        body: {"id_user":id_user,"name": name, "username": username, "password": password});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      setState(() {
        Navigator.pop(context);
      });
    } else {
      print(pesan);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text("Register")),
      ),
      body: Form(
        key: _key,
        autovalidate: _autoValidate,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              validator: (e) {
                if (e.isEmpty) {
                  return "name must be fill";
                }
              },
              onSaved: (e) => name = e,
              decoration: InputDecoration(labelText: "Name"),
            ),
            TextFormField(
              validator: (e) {
                if (e.isEmpty) {
                  return "please insert username";
                } else
                  return null;
              },
              onSaved: (e) => username = e,
              decoration: InputDecoration(labelText: "Username"),
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
                  labelText: "Password",
                  suffixIcon: IconButton(
                    onPressed: showHide,
                    icon: Icon(
                        _secureText ? Icons.visibility_off : Icons.visibility),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: RaisedButton(
                onPressed: () {
                  check();
                },
                child: Text(
                  "Register",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.lightBlue,
                shape: new RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MainMenu extends StatefulWidget {
  final VoidCallback signOut;
  MainMenu(this.signOut);
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  signOut() {
    setState(() {
      widget.signOut();
    });
  }

  String username = "", name = "";

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString("username");
      name = preferences.getString("name");
      print(username);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
    print(username);
    print(Env.urlBase);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Row(children: [
            Padding(
              padding: const EdgeInsets.only(left:8.0),
              child: Text("HSA"),
            )
          ],),
          backgroundColor: Colors.red[500],
          actions: <Widget>[
            IconButton(
              onPressed: () {
                signOut();
              },
              icon: Icon(Icons.lock_open),
            )
          ],
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[HomeAdmin(), Product(), Profile("","")],
        ),
        bottomNavigationBar: Material(
          color: Colors.redAccent,
                  child: TabBar(
            
            isScrollable: false,
            labelColor: Colors.lightBlue[100],
            unselectedLabelColor: Colors.white,
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.home),
                text: ("Home"),
              ),
              Tab(
                icon: Icon(Icons.shop),
                text: "List Outlet",
              ),
              Tab(
                icon: Icon(Icons.people),
                text: "Account",
              )
            ],
          ),
        ),
      ),
    );
  }
}
