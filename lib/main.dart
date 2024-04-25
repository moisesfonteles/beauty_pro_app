import 'package:beauty_pro/page/login_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      buttonTheme:const ButtonThemeData (
        buttonColor: Color.fromRGBO(39, 144, 176, 1),
      ),
      appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: Colors.white)),
      primarySwatch: Colors.blue,
    ),
    home: const LoginPage(),
  ));
}