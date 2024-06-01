import 'package:beauty_pro/page/home_page.dart';
import 'package:beauty_pro/page/login_page.dart';
import 'package:beauty_pro/page/professionals_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      buttonTheme: const ButtonThemeData(
        buttonColor: Color.fromRGBO(20, 28, 95, 1),
      ),
      appBarTheme:
          const AppBarTheme(iconTheme: IconThemeData(color: Colors.white)),
      primarySwatch: Colors.blue,
    ),
    home: const UserAuth(),
  ));
}

class UserAuth extends StatelessWidget {
  const UserAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ProfessionalsPage(email: snapshot.data!.email);
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
