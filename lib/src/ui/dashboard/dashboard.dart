import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lumi/src/constants/const.dart';
import 'package:lumi/src/models/loginrequester.dart';
import 'package:lumi/src/ui/login/components/rounded_button.dart';
import 'package:lumi/src/ui/login/components/rounded_input_field.dart';
import 'package:lumi/src/utils/utility.dart';

import '../../../thingsboard_client.dart';

class dashboardScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return dashboardScreenState();
  }
}

class dashboardScreenState extends State<dashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: dashboardForm());
  }
}

// String result = "Hey there !";
// Future _scanQR() async {
//   result = "Hey there !";
//   try {
//     String qrResult = await BarcodeScanner.scan();
//     setState(() {
//       result = qrResult;
//     });
//   } on PlatformException catch (ex) {
//     if (ex.code == BarcodeScanner.CameraAccessDenied) {
//       setState(() {
//         result = "Camera permission was denied";
//       });
//     } else {
//       setState(() {
//         result = "Unknown Error $ex";
//       });
//     }
//   } on FormatException {
//     setState(() {
//       result = "You pressed the back button before scanning anything";
//     });
//   } catch (ex) {
//     setState(() {
//       result = "Unknown Error $ex";
//     });
//   }
// }

class dashboardForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _scanController = new TextEditingController(text: "");
  late Future entityFuture;
  late String deviceId;

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
                Material(
                  child: InkWell(
                    onTap: () {
                      // dashboardApi(context);
                      // _scanQR();
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.asset('assets/icons/qr.png',
                          width: 150.0, height: 150.0),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text("Click here to Scan QR",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontFamily: "Montserrat")),
                SizedBox(
                  height: 20,
                ),
                Text("",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontFamily: "Montserrat")),
                RoundedButton(
                  text: "Proceed",
                  press: () {
                    deviceFetcher(context);
                  },
                  key: null,
                ),
              ],
            )));
  }
}

@override
Future<Device?> fetchDeviceType(String deviceName) async {
  Device response;
  Future<List<EntityGroupInfo>> deviceResponse;
  var tbClient = ThingsboardClient(serverUrl);
  tbClient.init();
  response =
      (await tbClient.getDeviceService().getTenantDevice(deviceName)) as Device;
  if (response.label!.isNotEmpty) {
    print("Device present, Device Type-->" + response.type);
    if (response.type == "ilmNode") {
      deviceResponse = fetchDeviceGroups("Device", response.type.toString());
    }
  } else {
    print("Device not present,Try with another device");
  }
  // response.then((value) => {value!.name});
}

@override
Future<Device?> fetchDeviceDetails(String deviceName) async {
  Device response;
  Future<List<EntityGroupInfo>> deviceResponse;
  var tbClient = ThingsboardClient(serverUrl);
  tbClient.init();
  response =
      (await tbClient.getDeviceService().getTenantDevice(deviceName)) as Device;
  if (response.label!.isNotEmpty) {
    var scannedDeviceCredentials = await tbClient
        .getDeviceService()
        .getDeviceCredentialsByDeviceId(response.id!.id!);
    await tbClient.getDeviceService().deleteDevice(response.id!.id!);
    print("Device Deleted Sucessfully");

    Device device = new Device("1234567890123456", "ilmNode");
    device.setOwnerId(EntityGroupId("326276d0-17a1-11ec-a622-c70a8200fa04"));
    // device.name = "1234567890123456";
    // device.label = "ilmDevice";
    // device.type = "ilmNode";

    await tbClient.getDeviceService().saveDevice(device);
    print("Device Added Sucessfully");
  } else {}
  // response.then((value) => {value!.name});
}

@override
Future<List<EntityGroupInfo>> fetchDeviceGroups(
    String groupType, String deviceType) async {
  List<EntityGroupInfo> response;
  var tbClient = ThingsboardClient(serverUrl);
  tbClient.init();
  var groupType = "Device";
  var entityVal = entityTypeFromString(groupType);
  response =
      await tbClient.getEntityGroupService().getEntityGroupsByType(entityVal);
  for (int i = 0; i < response.length; i++) {
    if (deviceType == "ilmNode") {
      if (response[i].name == "forRepairILM") {
        var tbClient = ThingsboardClient(serverUrl);
        tbClient.init();
        Future<Device?> entityFuture = fetchDeviceDetails("1234567890123456");
      }
    } else if (deviceType == "Gateway") {
    } else {}
  }
  return response;
}

void deviceFetcher(BuildContext context) {
  late Future<Device?> entityFuture;
  Utility.isConnected().then((value) async {
    if (value) {
      entityFuture = fetchDeviceType("1234567890123456");
    }
  });
}
