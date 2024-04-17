

import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(244, 244, 244, 1),
      body: bodyLogin(),
    );
  }

  Widget bodyLogin() {
    return Padding(
      padding:const EdgeInsets.all(16),
      child: Column(
        children: [
          Image.asset("assets/logo.png"),
          loginWidget()
        ],
      ),
    );
  }

  Widget loginWidget() {
    return Column(
      children: [
        const Text("Email"),
        TextFormField(
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "user@email.com"),
        ),
        const Text("Senha"),
        TextFormField(
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
      ],
    );
  }
}