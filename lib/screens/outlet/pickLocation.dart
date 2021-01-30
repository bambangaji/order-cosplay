import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_php/env.dart';
import 'package:flutter_php/models/outletDetailModel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PickLocation extends StatefulWidget {
  String id_outlet;
  PickLocation(this.id_outlet);
  @override
  _PickLocationState createState() => _PickLocationState();
}

class _PickLocationState extends State<PickLocation> {
  String idUser;
  String data;
  var loading = false;
  final list = new List<OutletDetailModel>();
  Position position;

  Future<void> _lihatData() async {
    // if(position.latitude == null){
    //   position.latitude == -6.3732582;
    //   position.longitude == 106.7534968;
    // }
    Position res = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      position = res;
    });
    print(position);
  }

  @override
  void initState() {
    super.initState();
    _lihatData();
    print("menu");
    
  }
  double latitude;
  double longitude;
  Set<Marker> _markers = {};
  String _marker;
  String _markerLatitude;
  String _markerLongitude;
  void _onAddMarkerButtonPressed(LatLng latlang) {
    final _latLng = latlang;
    setState(() {
      _markers.add(Marker(
          // This marker id can be anything that uniquely identifies each marker.
          markerId: MarkerId(latlang.toString()),
          position: latlang,
          // infoWindow: InfoWindow(
          //   title: address,
          // //  snippet: '5 Star Rating',
          // ),
          icon: BitmapDescriptor.defaultMarkerWithHue(20),
          infoWindow: InfoWindow(title: "asdw", snippet: "5"))
          
          );
    });

    setState(() {
      final latitude = latlang.latitude;
      final longitude = latlang.longitude;
      _markerLatitude="$latitude";
      _markerLongitude="$longitude";
      print(_markerLatitude);
    });
      }
 dialogBuy(String id_outlet, String latitude, String longitude) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: ListView(
              padding: EdgeInsets.all(16.0),
              shrinkWrap: true,
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Confirm Location?",
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    SizedBox(
                      height: 40,
                      width: 60,
                      child: RaisedButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          color: Colors.lightBlue,
                          onPressed: () {
                            _buyProduct(id_outlet,latitude,longitude);
                            Navigator.pop(context);
                          },
                          child: Text("Yes",
                              style: TextStyle(color: Colors.white))),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    SizedBox(
                      height: 40,
                      width: 60,
                      child: RaisedButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          color: Colors.red,
                          onPressed: () {
                            Navigator.pop(context);
                            print(id_outlet);
                            print(latitude);
                          },
                          child: Text(
                            "No",
                            style: TextStyle(color: Colors.white),
                          )),
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }

  _buyProduct(String id_outlet, String latitude, String longitude) async {
    // print(id_order);
    // print(idUser);
    final body = {
      "id_outlet": id_outlet,
      "latitude": latitude,
      "longitude": longitude
    };
    print(body);
    final response = await http.post(Env.pickLocation, body: body);
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
      print(pesan);
    }
  }
  // positionMap(positionLat,positionLang){
  //   print(position);
  // if (position == null){
  //   new LatLng(-6.3732582, 106.7534968);
  // } else {
  //  new LatLng(positionLat,positionLang);
  // }
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          new GoogleMap(
            markers: _markers,
            onTap: (LatLng) {
              if (_markers.length >= 1) {
                _markers.clear();
               
              }
              _onAddMarkerButtonPressed(LatLng);
            },
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              bearing: 0,
              target: new LatLng(-6.3732582, 106.7534968),
              // target: new LatLng(position.latitude,position.longitude),
              zoom: 12.0,
            ),
          ),
          AnimatedPositioned(bottom: 0, right: 0, left: 0,
   duration: Duration(milliseconds: 200),
   child: Align(
      alignment: Alignment.bottomCenter,
      child: Container(
   margin: EdgeInsets.all(20),
   height: 70,
   decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(50)),
      boxShadow: <BoxShadow>[
         BoxShadow(
            blurRadius: 20,
            offset: Offset.zero,
            color: Colors.grey.withOpacity(0.5)
      )]
   ),
   child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
   mainAxisAlignment: MainAxisAlignment.spaceAround,
   children: <Widget>[
     FlatButton(onPressed: (){
       print(_markers);
       _markers.clear();
       Navigator.of(context).pop({_markerLatitude,_markerLongitude});
     }, child: Text("Back",
     style: TextStyle(
       color: Colors.red
     ),)),
     FlatButton(onPressed: (){
       dialogBuy(widget.id_outlet, _markerLatitude, _markerLongitude);
       print(LatLng);
     }, child: Text("Confirm",
     style: TextStyle(
       color: Colors.blue
     ),
     ))
     
   ],
   ),
   )
      ),
   )
        ],
      ),
    );
  }
}
