import 'package:flutter/material.dart';
import 'package:lumi/src/tb/model/dashboard_models.dart';
import 'package:lumi/src/ui/login/login_screen.dart';
import 'package:lumi/src/ui/splashScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Lumi',
        theme: ThemeData(
          primaryColor: Color(0xFF02BB9F),
          primaryColorDark: Color(0xFF167F67),
          accentColor: Color(0xFF167F67),
        ),
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        // primarySwatch: Colors.blue,
        // ),
        // home: MyHomePage(title: 'Flutter Demo Home Page'),
        home: Scaffold(
          body: LoginScreen(),
        ));
  }
}
