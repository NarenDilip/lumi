import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lumi/src/constants/const.dart';
import 'package:lumi/src/models/loginrequester.dart';
import 'package:lumi/src/tb/service/tb_secure_storage.dart';
import 'package:lumi/src/ui/dashboard/dashboard.dart';
import 'package:lumi/src/ui/login/loginThingsboard.dart';
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
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  RoundedInputField(
                    hintText: user_email,
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
                    hintText: user_password,
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

  Future<void> _loginAPI(BuildContext context) async {

    // storage = TbSecureStorage();
    Utility.isConnected().then((value) async {
      if (value) {
        Utility.progressDialog(context);

        if ((user.username == app_username) &&
            (user.password == app_password)) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('username', user.username);
          var status = await loginThingsboard.callThingsboardLogin(context);
          if (status == true) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => dashboardScreen()));
          }
        } else {
          Navigator.pop(context);
          Fluttertoast.showToast(
              msg: "Please check Username and Password, Invalid Credentials",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.white,
              textColor: Colors.black,
              fontSize: 16.0);
        }
      }
    });
  }
}
