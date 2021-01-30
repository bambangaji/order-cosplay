import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_php/env.dart';
import 'package:flutter_php/models/outletDetailModel.dart';
import 'package:flutter_php/models/productModel.dart';
import 'package:http/http.dart' as http;

class ChangePassword extends StatefulWidget {
 String id_user;
 ChangePassword(this.id_user);
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  String password;
  final _key = new GlobalKey<FormState>();
   bool _secureText = true;
   var _autoValidate = false;
  check(){
    final form = _key .currentState;
    if (form.validate()){
      form.save();
      submit();
    } else {

    }
  }
  submit()async{
    final response = await http.post(Env.changePassword, body: {
      "password":password,
      "id_user":widget.id_user
    });
    final data = jsonDecode(response.body);
    int value = data ['value'];
    String pesan = data['message'];
    if(value == 1){
      setState(() {
        // widget.reload();
        Navigator.pop(context);
      });
    } else {     
          }
  }
   showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _key,
              child: ListView(
                padding: EdgeInsets.all(16.0),
          children: <Widget>[
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
            MaterialButton(
              color: Colors.blueAccent,
              onPressed: (){
                print(widget.id_user);
                check();
              },
              child: Text("Submit",
              style: TextStyle(color: Colors.white),),
            )
          ],
        ),
      ),
    );
  }

}