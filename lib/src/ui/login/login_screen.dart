import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lumi/src/constants/const.dart';
import 'package:lumi/src/models/loginrequester.dart';
import 'package:email_validator/email_validator.dart';
import 'package:lumi/src/tb/service/tb_secure_storage.dart';
import 'package:lumi/src/ui/dashboard/dashboard.dart';
import 'package:lumi/src/ui/login/loginThingsboard.dart';
import 'package:lumi/src/utils/apppreference.dart';
import 'package:lumi/src/utils/utility.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../thingsboard_client.dart';
import 'components/rounded_button.dart';
import 'components/rounded_input_field.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LoginForm());
  }
}

class LoginForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  late SharedPreferences logindata;
  final user = LoginRequester(
      username: "",
      password: "",
      token: "",
      refreshtoken: "",
      responseCode: 0,
      email: "");
  late final TbStorage storage;
  TextEditingController passwordController =
      new TextEditingController(text: "");
  TextEditingController _emailController = new TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
          height: size.height,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/icons/background_img.jpeg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(
                      image: AssetImage("assets/icons/logo.png"),
                      height: 75,
                      width: 75),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      child: Text(
                        "LOG IN",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  RoundedInputField(
                    hintText: "User Email",
                    isObscure: false,
                    controller: _emailController,
                    validator: (email) {
                      if (email!.isEmpty) {
                        return "Please enter the email";
                      } else if (!EmailValidator.validate(email)) {
                        return "Please enter the validate email";
                      }
                    },
                    onSaved: (email) => user.username = email!,
                    onChanged: (String value) {},
                  ),
                  SizedBox(height: size.height * 0.02),
                  RoundedInputField(
                    hintText: "Password",
                    isObscure: true,
                    onSaved: (value) => user.password = value!,
                    controller: passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter the password";
                      }
                    },
                    onChanged: (value) {},
                  ),
                  SizedBox(height: 20),
                  RoundedButton(
                    text: sign_in,
                    color: purpleColor,
                    press: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        FocusScope.of(context).requestFocus(new FocusNode());
                        _loginAPI(context);
                      }
                    },
                    key: null,
                  ),
                ],
              ))),
    );
  }

  void _loginAPI(BuildContext context) {
    storage = TbSecureStorage();

    Utility.isConnected().then((value) async {
      if (value) {
        Utility.progressDialog(context);

        if ((user.username == "smartLumi@gmail.com") && (user.password == "smartLumi")) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('username', user.username);
          var status = await loginThingsboard.callThingsboardLogin(context);
          if (status == true) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => dashboardScreen()));
          }
        } else {

        }
      }
    });
  }
}
