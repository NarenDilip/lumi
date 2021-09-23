import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lumi/src/utils/responsive.dart';

class Utility {
  static Future<bool> isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    Fluttertoast.showToast(
        msg: "Please check your Mobile Internet Connectivity",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.blue,
        fontSize: 16.0);
    return false;
  }

  static void progressDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  static double getResponsiveWidth(BuildContext context) {
    if (Responsive.isDesktop(context)) {
      return 0.2;
    } else if (Responsive.isTablet(context)) {
      return 0.5;
    } else {
      return 0.9;
    }
  }
}
