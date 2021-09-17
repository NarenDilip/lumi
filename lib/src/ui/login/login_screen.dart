import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lumi/src/constants/const.dart';
import 'package:lumi/src/models/loginrequester.dart';
import 'package:email_validator/email_validator.dart';
import 'package:lumi/src/tb/service/tb_secure_storage.dart';
import 'package:lumi/src/ui/dashboard/dashboard.dart';
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
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 10),
                  Image(
                      image: AssetImage("assets/icons/logo.png"),
                      height: 75,
                      width: 75),
                  SizedBox(height: 20),
                  Column(
                    children: <Widget>[
                      SizedBox(
                        width: double.infinity,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(30, 0, 0, 15),
                          child: Text(
                            "User Login",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Montserrat",
                                height: 1,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
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
                  SizedBox(height: size.height * 0.01),
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
                  RoundedButton(
                    text: "Login",
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
        var tbClient = ThingsboardClient(serverUrl);

        final response =
            await tbClient.login(LoginRequest(user.username, user.password));
        if (response.token != null) {
          AppPreference.save("token", response.token);

          // storage.setItem("jwt_token", response.token);
          // storage.setItem("refresh_token", response.refreshToken);
          //
          // var jwtToken = storage.getItem('jwt_token');

          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('token', response.token);
          prefs.setString('refreshtoken', response.refreshToken);

          logindata = await SharedPreferences.getInstance();
          logindata.setString('token', response.token);
          logindata.setString('refresh_token', response.refreshToken);
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => dashboardScreen()));
        }
      }
    });
  }
}
