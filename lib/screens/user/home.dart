import 'package:flutter/material.dart';
import 'package:flutter_php/models/outletDetailModel.dart';
import 'package:flutter_php/screens/outlet/outletDetail.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../env.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class Home extends StatefulWidget {
  Home(this.positionLatitude, this.positionLongitude);
  final double positionLatitude;
  final double positionLongitude;

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  String idUser;
  String data;
  var loading = false;
  final list = new List<OutletDetailModel>();
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();
  Position position;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idUser = preferences.getString("id");
      print("object");
      print("id : " + idUser);
    });
  }

  Future<void> _lihatData() async {
    Position res = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      position = res;
    });
    print(position);
    list.clear();

    final response = await http.get(Env.outletMaps);
    if (response.contentLength == 1) {
    } else {
      final data = jsonDecode(response.body);
      print(data);
      data.forEach((api) {
        final ab = new OutletDetailModel(
            api['id_outlet'],
            api['name_outlet'],
            api['no_hp'],
            api['desc_outlet'],
            api['latitude'],
            api['longitude'],
            api['image'],
            api['id_product'],
            api['name_product'],
            api['qty'],
            api['price'],
            api['image_product'],
            api['address'],
            api['city'],
            api['rating'],
            api['instagram'],
            api['facebook'],
            api['website']
            );
        list.add(ab);
      });

      print(list);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
    print("tolol");
    _lihatData();
    getMarkers();
    print("men22u");
    print(widget.positionLongitude);

  }

  final Set<Marker> _markers = {};
  final LatLng _currentPosition = LatLng(3.595196, 98.672226);

  getMarkers() async {
    var i;
    await _lihatData();
    print(position.longitude);
    setState(() {
      loading = true;
    });
    // print(list[i].image);
    for (i = 0; i < list.length; i++) {
      final markerId = MarkerId(list[i].id_outlet);
      final _markerId = list[i];
      _markers.add(Marker(
          markerId: markerId,
          position: LatLng(
              double.parse(list[i].latitude), double.parse(list[i].longitude)),
          icon: BitmapDescriptor.defaultMarker,
          onTap: () {
            // list[i];
            print("objects");
            print(_markerId);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => OutletDetail(_markerId.id_outlet,idUser)));
          }));
      setState(() {
        loading = false;
      });
    }
    return _markers;
  }

  @override
  Widget build(BuildContext context) {
    final Set<Circle> _circles = Set.from([
      Circle(
        circleId: CircleId(list[0].id_outlet),
        // center: LatLng(widget.positionLatitude, widget.positionLongitude),
        center: LatLng(position.latitude,position.longitude),
        radius: 3000,
        fillColor: Colors.red[200].withOpacity(0.2),
        strokeWidth: 1,
        strokeColor: Colors.blue,
      )
    ]);
    //   // if (){}
    //   if(widget.positionLongitude == null ){
    //  setState(() {
    //    CameraPosition(
    //                       target: new LatLng(widget.positionLatitude, widget.positionLongitude),
    //                       zoom: 12.0,
    //                     );
    //  LatLng;
    //  });

    //   }
    return Scaffold(
      body: Container(

              child: position.latitude != null && position.longitude != null ? new GoogleMap(
                  // circles: _circles,
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    bearing: 0,
                    // target: new LatLng(position.latitude,position.longitude),
                    target:  new LatLng(-6.3732675, 106.753495),
                    zoom: 12.0,
                  ),
                  markers: _markers):
                  Container()
            ),
    );
  }
}
