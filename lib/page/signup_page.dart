import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context , title: 'CADASTRAR-SE'),
        backgroundColor: const Color.fromRGBO(244, 244, 244, 1),
        body: SingleChildScrollView(child: bodySignUp()));
  }

  Widget bodySignUp() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 50),
      child: Column(children: [signUpWidget()]),
    );
  }

  Widget signUpWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Nome",
        ),
        TextFormField(
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
              border: OutlineInputBorder(), hintText: "user@email.com"),
        ),
        const Text("Empresa"),
        TextFormField(
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        const Text("Tema"),
        TextFormField(
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        const Text("Telefone"),
        TextFormField(
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        const Text("Email"),
        TextFormField(
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        const Text("Senha"),
        TextFormField(
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        const Text("Confirmar senha"),
        TextFormField(
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: createButton('Continuar', () {}),
        ),
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

AppBar customAppBar(BuildContext context, {String title = ''}) {
  return AppBar(
    centerTitle: true,
    backgroundColor: const Color.fromRGBO(39, 144, 176, 1),
    title: Text(title, 
    style: const TextStyle(color:Colors.white),),
    leading: IconButton(
      icon: const Icon(Icons.arrow_back,  color: Colors.white),
      onPressed: () {
        Navigator.of(context).pop();
      },
    ),
  );}