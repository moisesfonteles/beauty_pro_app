import 'package:beauty_pro/page/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MaterialApp(
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
    )
  );
}