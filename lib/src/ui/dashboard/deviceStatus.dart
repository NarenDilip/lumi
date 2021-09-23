import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lumi/src/constants/const.dart';

import 'dashboard.dart';

class deviceStatus extends StatefulWidget {

  final String text;
  deviceStatus({Key? key, required this.text}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() {
    return deviceStatusState();
  }
}

class deviceStatusState extends State<deviceStatus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: deviceStatusForm(widget.text));
  }
}

class deviceStatusForm extends StatelessWidget {
   deviceStatusForm(String text);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Material(
        type: MaterialType.transparency,
        child: new Container(
            height: size.height,
            width: double.infinity,
            color: Colors.white,
            margin: new EdgeInsets.all(0.0),
            child: Card(
                child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                height: 100,
                width: double.infinity,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(
                          image: AssetImage("assets/icons/logo.png"),
                          height: 50,
                          width: 50),
                      SizedBox(
                        height: 20,
                      ),
                      Text(splashscreen_text,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: "Montserrat")),
                      SizedBox(
                        height: 20,
                      ),
                      Text("Device Moved in to Production Successfully",
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 20,
                              fontFamily: "Montserrat"),
                          textAlign: TextAlign.center),
                    ]),
              ),
            ))));
  }
}
