import 'package:beauty_pro/controller/signup_controller.dart';
import 'package:beauty_pro/page/login_page.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  final _controller = SignUpController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar(context, title: 'Cadastrar-se'),
        backgroundColor: const Color.fromRGBO(244, 244, 244, 1),
        body: SingleChildScrollView(child: bodySignUp()));
  }

  Widget bodySignUp() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 25),
      child: Column(children: [signUpWidget()]),
    );
  }

  Widget signUpWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _controller.nameController,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
              labelText: "Nome",
              border: OutlineInputBorder(),
              hintText: "user@email.com"),
        ),
        const SizedBox(height: 15),
        TextFormField(
          controller: _controller.companyController,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
              labelText: "Empresa", border: OutlineInputBorder()),
        ),
        const SizedBox(height: 15),
        const Text(
          "Tema",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        switchTheme(),
        const SizedBox(height: 15),
        TextFormField(
          controller: _controller.phoneController,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
              border: OutlineInputBorder(), labelText: "Telefone"),
        ),
        const SizedBox(height: 15),
        TextFormField(
          controller: _controller.emailController,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
              labelText: "Email", border: OutlineInputBorder()),
        ),
        const SizedBox(height: 15),
        TextFormField(
          controller: _controller.passwordController,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
              labelText: "Senha", border: OutlineInputBorder()),
        ),
        const SizedBox(height: 15),
        TextFormField(
          controller: _controller.passwordConfirmationController,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
              labelText: "Confirmar senha", border: OutlineInputBorder()),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: createButton('Continuar', () {
            Navigator.push(
              context,
              // MaterialPageRoute(builder: (context) => const AddServicePage()),
              MaterialPageRoute(builder: (context) => const LoginPage())
            );
          }),
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
        child: Text(
            style: const TextStyle(fontSize: 18, color: Colors.white), label),
      ));
}

AppBar customAppBar(BuildContext context, {String title = ''}) {
  return AppBar(
    centerTitle: true,
    backgroundColor: const Color.fromRGBO(39, 144, 176, 1),
    title: Text(
      title,
      style: const TextStyle(color: Colors.white),
    ),
  );
}

Widget switchTheme() {
  return ToggleSwitch(
    minHeight: 65,
    minWidth: double.infinity,
    cornerRadius: 8,
    activeBgColors: const [
      [Color.fromRGBO(39, 144, 176, 1)],
      [Color.fromRGBO(242, 88, 114, 1)]
    ],
    activeFgColor: Colors.white,
    inactiveBgColor: Colors.grey,
    inactiveFgColor: Colors.black,
    initialLabelIndex: 1,
    totalSwitches: 2,
    labels: const ['Azul', 'Rosa'],
    radiusStyle: true,
    onToggle: (index) {},
  );
}
