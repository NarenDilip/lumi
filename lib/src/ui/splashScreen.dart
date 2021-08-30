import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lumi/src/constants/const.dart';
import 'package:lumi/src/ui/dashboard/dashboard.dart';
import 'package:lumi/src/utils/apppreference.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login/login_screen.dart';

class splashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return splashScreenState();
  }
}

class splashScreenState extends State<splashScreen> {
  late SharedPreferences logindata;
  late String token;

  void initState() {
    // TODO: implement initState
    super.initState();
    initial();
  }

  void initial() async {
    logindata = await SharedPreferences.getInstance();
    try {
      token = logindata.getString("token")!;
      Timer(
          Duration(seconds: 4),
          () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (BuildContext context) {
                if (token != null) {
                  return dashboardScreen();
                } else {
                  return LoginScreen();
                }
              })));
    } catch (e) {}
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        height: size.height,
        width: double.infinity,
        color: Colors.white,
        margin: new EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
                image: AssetImage("assets/icons/logo.png"),
                height: 150,
                width: 150),
            SizedBox(
              height: 20,
            ),
            Text(splashscreen_text,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 35,
                    fontFamily: "Montserrat")),
          ],
        ));
  }
}
