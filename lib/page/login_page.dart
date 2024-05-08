import 'package:beauty_pro/controller/login_controller.dart';
import 'package:beauty_pro/page/home_page.dart';
import 'package:beauty_pro/page/signup_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _controller = LoginController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(244, 244, 244, 1),
        body: SingleChildScrollView(child: bodyLogin(context)));
  }

  Widget bodyLogin(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 128, 25, 25),
      child: Column(
        children: [Image.asset("assets/logo.png"), loginWidget(context)],
      ),
    );
  }

  Widget loginWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _controller.emailController,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Email"),
        ),
        const SizedBox(height: 15),
        TextFormField(
          controller: _controller.passwordController,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Senha",
            )),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: createButton('Entrar', () {
             Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                );

          }),
        ),
        smallButons(context)
      ],
    );
  }
}

Widget createButton(String label, VoidCallback onPressed) {
  return SizedBox(
      height: 65,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(39, 144, 176, 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: Text(
            style: const TextStyle(fontSize: 18, color: Colors.white), label),
      ));
}

Widget smallButons(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      InkWell(
        onTap: () {},
        child: const Text(
          'Esqueceu a senha?',
          style: TextStyle(
            fontSize: 18,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
      InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SignUpPage()),
          );
        },
        child: const Text(
          'Cadastrar-se',
          style: TextStyle(
            fontSize: 18,
            decoration: TextDecoration.underline,
          ),
        ),
      )
    ],
  );
}
