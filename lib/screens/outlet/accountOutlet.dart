import 'package:flutter/material.dart';
import 'package:flutter_php/screens/outlet/changePassword.dart';
import 'package:flutter_php/screens/outlet/pickLocation.dart';
import 'package:flutter_php/screens/outlet/settings.dart';
import 'package:flutter_php/screens/settings.dart';
import 'package:flutter_php/screens/user/getHistoryUser.dart';
import 'package:flutter_php/screens/user/getOrderUser.dart';
import 'package:flutter_php/screens/user/profileUser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountOutlet extends StatefulWidget {
   final VoidCallback signOut;
   final String id_outlet;
  AccountOutlet(this.signOut,this.id_outlet);
  @override
  _AccountOutletState createState() => _AccountOutletState();
}

class _AccountOutletState extends State<AccountOutlet> {
  String id_user;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id_user = preferences.getString("id");
      print("object");
      print("id : " + id_user);
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
     return Scaffold(
       appBar: AppBar(),
            body :Container(
        child: ListView(
          children: <Widget>[
            
            Padding(
              padding: const EdgeInsets.fromLTRB(8,10,8,2),
              child: Container( 
                child: new GestureDetector(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.person_outline,color: Colors.lightBlue,),
                      Padding(
                        padding: const EdgeInsets.only(left:5.0,top: 5.0),
                        child: Text("Profile",style: TextStyle(
                          fontSize: 16
                        ),),
                      ),
                       new Spacer() , Icon(Icons.keyboard_arrow_right, size: 28,color: Colors.lightBlue,)
                    ],
                  ),
                  onTap: (){
                     Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SettingsOutlet(widget.id_outlet)));
                  },
                )
              ),
            ),
            Divider(),
             Padding(
              padding: const EdgeInsets.fromLTRB(8,0,8,2),
              child: Container( 
                child: new GestureDetector(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.person_outline,color: Colors.lightBlue,),
                      Padding(
                        padding: const EdgeInsets.only(left:5.0,top: 5.0),
                        child: Text("Pick Location",style: TextStyle(
                          fontSize: 16
                        ),),
                      ),
                       new Spacer() , Icon(Icons.keyboard_arrow_right, size: 28,color: Colors.lightBlue,)
                    ],
                  ),
                  onTap: (){
                     Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PickLocation(widget.id_outlet)));
                  },
                )
              ),
            ),
            Divider(),
              Padding(
              padding: const EdgeInsets.fromLTRB(8,0,8,2),
              child: Container( 
                child: new GestureDetector(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.vpn_key,color: Colors.lightBlue,),
                      Padding(
                        padding: const EdgeInsets.only(left:5.0,top: 5.0),
                        child: Text("Change Password",style: TextStyle(
                          fontSize: 16
                        ),),
                      ),
                       new Spacer() , Icon(Icons.keyboard_arrow_right, size: 28,color: Colors.lightBlue,)
                    ],
                  ),
                  onTap: (){
                     Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ChangePassword(id_user)));
                  },
                )
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(8,0,8,2),
            //   child: Container( 
            //     child: new GestureDetector(
            //       child: Row(
            //         children: <Widget>[
            //           Icon(Icons.receipt,color: Colors.lightBlue,),
            //           Padding(
            //             padding: const EdgeInsets.only(left:5.0,top: 5.0),
            //             child: Text("My Orders",style: TextStyle(
            //               fontSize: 16
            //             ),),
            //           ),
            //            new Spacer() , Icon(Icons.keyboard_arrow_right, size: 28,color: Colors.lightBlue,)
            //         ],
            //       ),
            //       onTap: (){
            //         Navigator.of(context).push(MaterialPageRoute(
            //       builder: (context) => OrderUser(id_user)));
            //       },
            //     )
            //   ),
            // ),
            // Divider(),
            
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(8,0,8,2),
            //   child: Container( 
            //     child: new GestureDetector(
            //       child: Row(
            //         children: <Widget>[
            //           Icon(Icons.reorder,color: Colors.lightBlue,),
            //           Padding(
            //             padding: const EdgeInsets.only(left:5.0,top: 5.0),
            //             child: Text("History",style: TextStyle(
            //               fontSize: 16
            //             ),),
            //           ),
            //            new Spacer() , Icon(Icons.keyboard_arrow_right, size: 28,color: Colors.lightBlue,)
            //         ],
            //       ),
            //       onTap: (){
            //          Navigator.of(context).push(MaterialPageRoute(
            //       builder: (context) => GetHistoryUser(id_user)));
            //         print(id_user);
            //       },
            //     )
            //   ),
            // ),
            Divider(),
            Padding(
              padding: const EdgeInsets.fromLTRB(8,0,8,2),
              child: Container( 
                child: new GestureDetector(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.lock_open,color: Colors.lightBlue,),
                      Padding(
                        padding: const EdgeInsets.only(left:5.0,top: 5.0),
                        child: Text("Sign Out",style: TextStyle(
                          fontSize: 16
                        ),),
                      ),
                       new Spacer() , Icon(Icons.keyboard_arrow_right, size: 28,color: Colors.lightBlue,)
                    ],
                  ),
                  onTap: (){
                     widget.signOut();
                  },
                )
              ),
            ),
            Divider(),
          ],
        ),
    ),
     );
 
  }
}