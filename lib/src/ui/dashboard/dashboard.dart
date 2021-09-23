import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lumi/src/constants/const.dart';
import 'package:lumi/src/ui/dashboard/deviceStatus.dart';
import 'package:lumi/src/ui/login/loginThingsboard.dart';
import 'package:lumi/src/ui/login/login_screen.dart';
import 'package:lumi/src/ui/qr_scanner.dart';
import 'package:lumi/src/utils/utility.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class dashboardForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _scanController = new TextEditingController(text: "");
  late Future entityFuture;
  late String deviceId;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
        onWillPop: () async {
          final result = await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text("Lumi"),
              content: Text("Are you sure you want to exit?"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text("NO"),
                ),
                TextButton(
                  child: Text('YES', style: TextStyle(color: Colors.red)),
                  onPressed: () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                ),
              ],
            ),
          );
          return result;
        },
        child: Scaffold(
            body: Container(
                height: size.height,
                width: double.infinity,
                color: dashboardThemeColor,
                child: Stack(
                  children: [
                    Positioned(
                      top: 20,
                      child: IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            // Navigator.pop(context);
                          }),
                    ),
                    Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 70,
                          ),
                          Image(
                              image: AssetImage("assets/icons/logo.png"),
                              height: 50,
                              width: 50),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            splashscreen_text.toUpperCase(),
                            style: TextStyle(
                              fontSize: 30,
                              color: purpleColor,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Montserrat",
                            ),
                          )
                        ],
                      ),
                    ),
                    Center(
                        child: InkWell(
                            onTap: () {
                              devicecloser(context);
                            },
                            child: Container(
                              alignment: Alignment.topRight,
                              padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
                              child: Text(
                                "Logout",
                                style: TextStyle(
                                  fontSize: 25,
                                  color: purpleColor,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Montserrat",
                                ),
                              ),
                            ))),
                    Center(
                        child: Container(
                      width: 180,
                      height: 200,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Material(
                            child: InkWell(
                              onTap: () {
                                deviceFetcher(context);
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Image.asset(
                                  'assets/icons/qr.png',
                                  width: 160,
                                  height: 160,
                                ),
                              ),
                            ),
                          ),
                          Text(qr_text,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Montserrat",
                              )),
                        ],
                      ),
                    )),
                  ],
                ))));
  }
}

Future<void> devicecloser(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
  prefs.commit();

  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => LoginScreen()));
}

// @override
// Future<Device?> fetchDeviceType(String deviceName, BuildContext context) async {
//   Utility.isConnected().then((value) async {
//     try {
//       Device response;
//       Future<List<EntityGroupInfo>> deviceResponse;
//       var tbClient = ThingsboardClient(serverUrl);
//       tbClient.smart_init();
//       response = (await tbClient.getDeviceService().getTenantDevice(deviceName))
//           as Device;
//       if (response.label!.isNotEmpty) {
//         print("Device present, Device Type-->" + response.type);
//         if (response.type == "ilmNode") {
//           deviceResponse = fetchDeviceGroups(
//               "Device", deviceName, response.type.toString(), context);
//         } else if (response.type == "") {
//         } else {}
//       } else {
//         print("Device not present,Try with another device");
//       }
//     } catch (e) {
//       var message = toThingsboardError(e).message;
//       if (message == "Session expired!") {
//         var status = loginThingsboard.callThingsboardLogin(context);
//         if (status == true) {
//           fetchDeviceType(deviceName, context);
//         }
//       }
//     }
//   });
// }

// @override
// Future<List<EntityGroupInfo>> fetchDeviceGroups(String groupType,
//     String deviceName, String deviceType, BuildContext context) async {
//   List<EntityGroupInfo> response;
//   response = null as List<EntityGroupInfo>;
//   Utility.isConnected().then((value) async {
//     try {
//       var tbClient = ThingsboardClient(serverUrl);
//       tbClient.smart_init();
//       var groupType = selectiondevice;
//       var entityVal = entityTypeFromString(groupType);
//       response = await tbClient
//           .getEntityGroupService()
//           .getEntityGroupsByType(entityVal);
//       for (int i = 0; i < response.length; i++) {
//         if (deviceType == "ilm") {
//           if (response[i].name == ilm_deviceRepair) {
//             var tbClient = ThingsboardClient(serverUrl);
//             tbClient.smart_init();
//             Future<Device?> entityFuture =
//                 fetchDeviceDetails(deviceName, context);
//           }
//         }
//       }
//     } catch (e) {
//       var message = toThingsboardError(e).message;
//       if (message == "Session expired!") {
//         var status = loginThingsboard.callThingsboardLogin(context);
//         if (status == true) {
//           fetchDeviceType(deviceName, context);
//         }
//       }
//     }
//   });
//   return response;
// }

// Fetching the device details from smart server
@override
Future<Device?> fetchDeviceDetails(
    String deviceName, BuildContext context) async {
  Utility.isConnected().then((value) async {
    if (value) {
      try {
        Device response;
        Future<List<EntityGroupInfo>> deviceResponse;
        var tbClient = ThingsboardClient(serverUrl);
        tbClient.smart_init();
        response = await tbClient.getDeviceService().getTenantDevice(deviceName)
            as Device;
        if (response.name.isNotEmpty) {
          if (response.type == ilm_deviceType) {
            fetchILMDeviceFolder(
                response.id!.id.toString(), deviceName, response.type, context);
          } else if (response.type == ccms_deviceType) {
            fetchCCMSDeviceFolder(
                response.id!.id.toString(), deviceName, response.type, context);
          } else if (response.type == Gw_deviceType) {
            fetchGatewayDeviceFoler(
                response.id!.id.toString(), deviceName, response.type, context);
          }
        } else {
          Fluttertoast.showToast(
              msg: device_toast_msg + deviceName + device_toast_notfound,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.white,
              textColor: Colors.black,
              fontSize: 16.0);
          Navigator.pop(context);
          nextPage(false, deviceName, context);
        }
      } catch (e) {
        var message = toThingsboardError(e).message;
        if (message == session_expired) {
          var status = loginThingsboard.callThingsboardLogin(context);
          if (status == true) {
            fetchDeviceDetails(deviceName, context);
          }
        } else {
          Fluttertoast.showToast(
              msg: device_toast_msg + deviceName + device_toast_notfound,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.white,
              textColor: Colors.black,
              fontSize: 16.0);
          Navigator.pop(context);
          nextPage(false, deviceName, context);
        }
      }
    } else {
      Fluttertoast.showToast(
          msg: no_network,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0);
    }
  });
}

void fetchGatewayDeviceFoler(
    String deviceId, String deviceName, String type, BuildContext context) {
  Utility.isConnected().then((value) async {
    if (value) {
      try {
        var tbClient = ThingsboardClient(serverUrl);
        tbClient.smart_init();
        var groupType = selectiondevice;
        var deviceLength = 0;
        var filteredDeviceDetails;
        var entityVal = entityTypeFromString(groupType);
        var response = await tbClient
            .getEntityGroupService()
            .getEntityGroupsByType(entityVal);
        for (int i = 0; i < response.length; i++) {
          if (response[i].name == gw_deviceRepair) {
            var pageLink = PageLink(1, 0, deviceName);
            filteredDeviceDetails = await tbClient
                .getDeviceService()
                .getDevicesByEntityGroupId(
                    response[i].id!.id.toString(), pageLink);
            deviceLength = filteredDeviceDetails.data.length;
          }
        }
        if (deviceLength == 0) {
          for (int i = 0; i < response.length; i++) {
            if (response[i].name == gw_deviceReplace) {
              var pageLink = PageLink(1, 0, deviceName);
              var filteredDeviceDetails = await tbClient
                  .getDeviceService()
                  .getDevicesByEntityGroupId(
                      response[i].id!.id.toString(), pageLink);
              deviceLength = filteredDeviceDetails.data.length;
            }
          }
        }

        if (deviceLength == 0) {
          Fluttertoast.showToast(
              msg: device_toast_msg + type + deviceName + session_toast_gw,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.white,
              textColor: Colors.black,
              fontSize: 16.0);
          Navigator.pop(context);
          nextPage(false, deviceName, context);
        } else {
          var deviceCredentials = await tbClient
              .getDeviceService()
              .getDeviceCredentialsByDeviceId(deviceId);

          var updateCredentials = deviceCredentials!.credentialsId.toString();

          fetchProductionDeviceDetails(
              deviceName, updateCredentials, deviceId, context);
        }
      } catch (e) {
        var message = toThingsboardError(e).message;
        if (message == session_expired) {
          var status = loginThingsboard.callThingsboardLogin(context);
          if (status == true) {
            fetchDeviceDetails(deviceName, context);
          }
        } else {
          Fluttertoast.showToast(
              msg: device_toast_msg + type + deviceName + device_toast_notfound,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.white,
              textColor: Colors.black,
              fontSize: 16.0);
          Navigator.pop(context);
          nextPage(false, deviceName, context);
        }
      }
    } else {
      Fluttertoast.showToast(
          msg: no_network,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0);
    }
  });
}

void fetchCCMSDeviceFolder(
    String deviceId, String deviceName, String type, BuildContext context) {
  Utility.isConnected().then((value) async {
    if (value) {
      try {
        var tbClient = ThingsboardClient(serverUrl);
        tbClient.smart_init();
        var groupType = selectiondevice;
        var deviceLength = 0;
        var filteredDeviceDetails;
        var entityVal = entityTypeFromString(groupType);
        var response = await tbClient
            .getEntityGroupService()
            .getEntityGroupsByType(entityVal);
        for (int i = 0; i < response.length; i++) {
          if (response[i].name == ccms_deviceRepair) {
            var pageLink = PageLink(1, 0, deviceName);
            filteredDeviceDetails = await tbClient
                .getDeviceService()
                .getDevicesByEntityGroupId(
                    response[i].id!.id.toString(), pageLink);
            deviceLength = filteredDeviceDetails.data.length;
          }
        }
        if (deviceLength == 0) {
          for (int i = 0; i < response.length; i++) {
            if (response[i].name == ccms_deviceReplace) {
              var pageLink = PageLink(1, 0, deviceName);
              var filteredDeviceDetails = await tbClient
                  .getDeviceService()
                  .getDevicesByEntityGroupId(
                      response[i].id!.id.toString(), pageLink);
              deviceLength = filteredDeviceDetails.data.length;
            }
          }
        }

        if (deviceLength == 0) {
          Fluttertoast.showToast(
              msg: device_toast_msg + type + deviceName + session_toast_ccms,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.white,
              textColor: Colors.black,
              fontSize: 16.0);
          Navigator.pop(context);
          nextPage(false, deviceName, context);
        } else {
          var deviceCredentials = await tbClient
              .getDeviceService()
              .getDeviceCredentialsByDeviceId(deviceId);

          var updateCredentials = deviceCredentials!.credentialsId.toString();

          fetchProductionDeviceDetails(
              deviceName, updateCredentials, deviceId, context);
        }
      } catch (e) {
        var message = toThingsboardError(e).message;
        if (message == session_expired) {
          var status = loginThingsboard.callThingsboardLogin(context);
          if (status == true) {
            fetchDeviceDetails(deviceName, context);
          }
        } else {
          Fluttertoast.showToast(
              msg: device_toast_msg + type + deviceName + device_toast_notfound,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.white,
              textColor: Colors.black,
              fontSize: 16.0);
          Navigator.pop(context);
          nextPage(false, deviceName, context);
        }
      }
    } else {
      Fluttertoast.showToast(
          msg: no_network,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0);
    }
  });
}

void nextPage(bool isSuccess, String devicename, BuildContext context) {
  // Navigator.pop(context);
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            deviceStatus(isSuccess: isSuccess, deviceName: devicename),
      ));
}

Future<void> fetchILMDeviceFolder(String deviceId, String deviceName,
    String type, BuildContext context) async {
  Utility.isConnected().then((value) async {
    if (value) {
      try {
        var tbClient = ThingsboardClient(serverUrl);
        tbClient.smart_init();
        var groupType = selectiondevice;
        var deviceLength = 0;
        var filteredDeviceDetails;
        var entityVal = entityTypeFromString(groupType);
        var response = await tbClient
            .getEntityGroupService()
            .getEntityGroupsByType(entityVal);
        for (int i = 0; i < response.length; i++) {
          if (response[i].name == ilm_deviceRepair) {
            var pageLink = PageLink(1, 0, deviceName);
            filteredDeviceDetails = await tbClient
                .getDeviceService()
                .getDevicesByEntityGroupId(
                    response[i].id!.id.toString(), pageLink);
            deviceLength = filteredDeviceDetails.data.length;
          }
        }
        if (deviceLength == 0) {
          for (int i = 0; i < response.length; i++) {
            if (response[i].name == ilm_deviceReplace) {
              var pageLink = PageLink(1, 0, deviceName);
              var filteredDeviceDetails = await tbClient
                  .getDeviceService()
                  .getDevicesByEntityGroupId(
                      response[i].id!.id.toString(), pageLink);
              deviceLength = filteredDeviceDetails.data.length;
            }
          }
        }

        if (deviceLength == 0) {
          Fluttertoast.showToast(
              msg: device_toast_msg + type + deviceName + session_toast_ilm,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.white,
              textColor: Colors.black,
              fontSize: 16.0);
          Navigator.pop(context);
          nextPage(false, deviceName, context);
        } else {
          var deviceCredentials = await tbClient
              .getDeviceService()
              .getDeviceCredentialsByDeviceId(deviceId);

          var updateCredentials = deviceCredentials!.credentialsId.toString();

          fetchProductionDeviceDetails(
              deviceName, updateCredentials, deviceId, context);
        }
      } catch (e) {
        var message = toThingsboardError(e).message;
        if (message == session_expired) {
          var status = loginThingsboard.callThingsboardLogin(context);
          if (status == true) {
            fetchDeviceDetails(deviceName, context);
          }
        } else {
          Fluttertoast.showToast(
              msg: device_toast_msg + type + deviceName + device_toast_notfound,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.white,
              textColor: Colors.black,
              fontSize: 16.0);
          Navigator.pop(context);
          nextPage(false, deviceName, context);
        }
      }
    } else {
      Fluttertoast.showToast(
          msg: no_network,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0);
    }
  });
}

@override
Future<Device?> fetchProductionDeviceDetails(String deviceName,
    String credentials, String deviceid, BuildContext context) async {
  Utility.isConnected().then((value) async {
    if (value) {
      try {
        Device response;
        Future<List<EntityGroupInfo>> deviceResponse;
        var tbClient = ThingsboardClient(serverUrl);
        tbClient.prod_init();
        response = (await tbClient
            .getDeviceService()
            .getTenantDevice(deviceName)) as Device;

        var getCredentials = await tbClient
            .getDeviceService()
            .getDeviceCredentialsByDeviceId(response.id!.id.toString());

        getCredentials!.credentialsId = credentials;

        var tbClient1 = ThingsboardClient(serverUrl);
        tbClient1.smart_init();
        await tbClient1.getDeviceService().deleteDevice(deviceid);

        var savedCredentials = await tbClient
            .getDeviceService()
            .saveDeviceCredentials(getCredentials);

        Fluttertoast.showToast(
            msg: device_success_msg,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            fontSize: 16.0);
        Navigator.pop(context);
        nextPage(true, deviceName, context);
      } catch (e) {
        var message = toThingsboardError(e).message;
        if (message == session_expired) {
          var status = loginThingsboard.callThingsboardLogin(context);
          if (status == true) {
            fetchDeviceDetails(deviceName, context);
          }
        } else {
          Fluttertoast.showToast(
              msg: device_toast_msg + deviceName + device_toast_notfound,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.white,
              textColor: Colors.black,
              fontSize: 16.0);
          Navigator.pop(context);
          nextPage(false, deviceName, context);

          // Navigator.of(context)
          //     .pushReplacement(MaterialPageRoute(builder: (BuildContext context) => {
          //   return deviceStatus(text: 'Hello');
          // }));
        }
      }
    } else {
      Fluttertoast.showToast(
          msg: no_network,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0);
    }
  });
}

// @override
// Future<List<EntityGroupInfo>> fetchProdDeviceGroups(String s, String deviceName,
//     String deviceType, BuildContext context) async {
//   List<EntityGroupInfo> response;
//   response = null as List<EntityGroupInfo>;
//   Utility.isConnected().then((value) async {
//     try {
//       var tbClient = ThingsboardClient(serverUrl);
//       tbClient.prod_init();
//       var groupType = selectiondevice;
//       var entityVal = entityTypeFromString(groupType);
//       response = await tbClient
//           .getEntityGroupService()
//           .getEntityGroupsByType(entityVal);
//       for (int i = 0; i < response.length; i++) {
//         if (deviceType == ilm_deviceType) {
//           if (response[i].name == "forRepairILM") {}
//         }
//       }
//     } catch (e) {
//       var message = toThingsboardError(e).message;
//       if (message == "Session expired!") {
//         var status = loginThingsboard.callThingsboardLogin(context);
//         if (status == true) {
//           fetchDeviceDetails(value, context);
//         }
//       } else {}
//     }
//   });
//   return response;
// }

void deviceFetcher(BuildContext context) {
  Utility.isConnected().then((value) async {
    if (value) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => QRScreen()),
          (route) => true).then((value) async {
        if (value != null) {
          // if (value.toString().length == 6) {
          late Future<Device?> entityFuture;
          Utility.progressDialog(context);
          entityFuture = fetchDeviceDetails(value, context);
          // } else {
          //   Fluttertoast.showToast(
          //       msg: "Invalid Device",
          //       toastLength: Toast.LENGTH_SHORT,
          //       gravity: ToastGravity.BOTTOM,
          //       timeInSecForIosWeb: 1,
          //       backgroundColor: Colors.white,
          //       textColor: Colors.blue,
          //       fontSize: 16.0);
          // }
        }
      });
    } else {
      Fluttertoast.showToast(
          msg: no_network,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0);
    }
  });
}

ThingsboardError toThingsboardError(error, [StackTrace? stackTrace]) {
  ThingsboardError? tbError;
  if (error is DioError) {
    if (error.response != null && error.response!.data != null) {
      var data = error.response!.data;
      if (data is ThingsboardError) {
        tbError = data;
      } else if (data is Map<String, dynamic>) {
        tbError = ThingsboardError.fromJson(data);
      } else if (data is String) {
        try {
          tbError = ThingsboardError.fromJson(jsonDecode(data));
        } catch (_) {}
      }
    } else if (error.error != null) {
      if (error.error is ThingsboardError) {
        tbError = error.error;
      } else if (error.error is SocketException) {
        tbError = ThingsboardError(
            error: error,
            message: 'Unable to connect',
            errorCode: ThingsBoardErrorCode.general);
      } else {
        tbError = ThingsboardError(
            error: error,
            message: error.error.toString(),
            errorCode: ThingsBoardErrorCode.general);
      }
    }
    if (tbError == null &&
        error.response != null &&
        error.response!.statusCode != null) {
      var httpStatus = error.response!.statusCode!;
      var message = (httpStatus.toString() +
          ': ' +
          (error.response!.statusMessage != null
              ? error.response!.statusMessage!
              : 'Unknown'));
      tbError = ThingsboardError(
          error: error,
          message: message,
          errorCode: httpStatusToThingsboardErrorCode(httpStatus),
          status: httpStatus);
    }
  } else if (error is ThingsboardError) {
    tbError = error;
  }
  tbError ??= ThingsboardError(
      error: error,
      message: error.toString(),
      errorCode: ThingsBoardErrorCode.general);

  var errorStackTrace;
  if (tbError.error is Error) {
    errorStackTrace = tbError.error.stackTrace;
  }

  tbError.stackTrace = stackTrace ??
      tbError.getStackTrace() ??
      errorStackTrace ??
      StackTrace.current;

  return tbError;
}
