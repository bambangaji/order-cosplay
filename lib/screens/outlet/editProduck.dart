import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_php/env.dart';
import 'package:flutter_php/models/outletDetailModel.dart';
import 'package:flutter_php/models/productModel.dart';
import 'package:http/http.dart' as http;
class EditProduct extends StatefulWidget {
  // final VoidCallback reload;
  final OutletDetailModel model;
  EditProduct(this.model);
  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  TextEditingController txtName,txtSeries,txtMaterial,txtDescription;
  final _key = new GlobalKey<FormState>();
  String name_product,series,material,desc;
  
  setup(){
txtName = TextEditingController(text:widget.model.name_product);
txtSeries = TextEditingController(text:widget.model.qty);
txtMaterial = TextEditingController(text:widget.model.price);
txtDescription = TextEditingController(text:widget.model.website);
  }
  check(){
    final form = _key .currentState;
    if (form.validate()){
      form.save();
      submit();
    } else {

    }
  }

  submit()async{
    final response = await http.post(Env.editProduct, body: {
      "name":name_product,
      "series":series,
      "material":material,
      "desc":desc,
      "id_product":widget.model.id_product
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setup();
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
              controller: txtName,
              onSaved: (e)=>name_product=e,
              decoration: InputDecoration(
                labelText: 'Name Character'
              ),
            ),
            TextFormField(
              controller: txtMaterial,
              onSaved: (e)=>series=e,
              decoration: InputDecoration(
                labelText: 'Series'
              ),
            ),
            TextFormField(
              controller: txtSeries,
              onSaved: (e)=>material=e,
              decoration: InputDecoration(
                labelText: 'Material'
              ),
            ),
            TextFormField(
              controller: txtDescription,
              onSaved: (e)=>desc=e,
              decoration: InputDecoration(
                labelText: 'Description'
              ),
            ),
            MaterialButton(
              color: Colors.blueAccent,
              onPressed: (){
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