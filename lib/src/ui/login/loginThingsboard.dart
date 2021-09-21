import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lumi/src/constants/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../thingsboard_client.dart';

class loginThingsboard {
  static Future<bool> callThingsboardLogin(BuildContext context) async {
    try {
      var tbClient = ThingsboardClient(serverUrl);
      SharedPreferences prefs = await SharedPreferences.getInstance();

      final smartToken =
          await tbClient.login(LoginRequest(smart_Username, smart_Password));
      if (smartToken.token != null) {
        prefs.setString('smart_token', smartToken.token);
        prefs.setString('smart_refreshtoken', smartToken.refreshToken);

        final prodToken =
            await tbClient.login(LoginRequest(prod_Username, prod_Password));
        if (prodToken.token != null) {
          prefs.setString('prod_token', prodToken.token);
          prefs.setString('prod_refreshtoken', prodToken.refreshToken);
          return true;
        }
      }
    } catch (e) {
      return false;
    }
    return true;
  }
}
