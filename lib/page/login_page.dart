import 'package:beauty_pro/page/signup_page.dart';
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
      body: SingleChildScrollView(child: bodyLogin(context))
    );
  }

  Widget bodyLogin(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 50),
      child: Column(
        children: [Image.asset("assets/logo.png"), loginWidget(context)],
      ),
    );
  }

  Widget loginWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Email",
        ),
        TextFormField(
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
              border: OutlineInputBorder(), hintText: "user@email.com"),
        ),
        const Text("Senha"),
        TextFormField(
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: createButton('Entrar', () {}),
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
        child: Text(style: const TextStyle(color: Colors.black), label),
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
            decoration: TextDecoration.underline,
          ),
        ),
      )
    ],
  );

}
