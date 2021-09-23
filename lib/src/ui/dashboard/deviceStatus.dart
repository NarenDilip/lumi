import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lumi/src/constants/const.dart';
import 'package:lumi/src/ui/login/components/rounded_button.dart';

class deviceStatus extends StatefulWidget {
  final bool isSuccess;
  final String deviceName;

  deviceStatus({Key? key, required this.isSuccess , required this.deviceName}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return deviceStatusState();
  }
}

class deviceStatusState extends State<deviceStatus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: deviceStatusForm(isSuccess: widget.isSuccess, deviceName:widget.deviceName));
  }
}

class deviceStatusForm extends StatelessWidget {
  final bool isSuccess;
  final String deviceName;

  deviceStatusForm({Key? key, required this.isSuccess, required this.deviceName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: new Container(
          height: size.height,
          width: size.width,
          margin: new EdgeInsets.all(0.0),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/icons/background_img.jpeg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: SizedBox(
                  height: 200,
                  width: size.width - 20,
                  child: Card(
                    elevation: 8,
                    child: Column(children: <Widget>[
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 40,
                        width: 40,
                        child: Icon(
                          isSuccess?Icons.done:Icons.clear,
                          color: Colors.white,
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSuccess?btnLightGreenColor:Colors.red,
                        ),
                      ),
                      Spacer(),
                      Text(isSuccess?(device_toast_msg + deviceName + device_success_msg):( device_toast_msg + deviceName + device_fail_msg),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: "Montserrat"),
                          textAlign: TextAlign.center),
                      Spacer(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            "Done",
                            style: TextStyle(
                                color: successGreenColor, fontSize: 16),
                          ),
                        ),
                      )
                    ]),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              /*RoundedButton(
                text: "SMART FOR REPAIR",
                color: btnLightGreenColor,
                press: () {

                },
                key: null,
              )*/
            ],
          )),
    );
  }
}
