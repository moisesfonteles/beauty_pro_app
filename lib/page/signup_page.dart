import 'package:beauty_pro/controller/signup_controller.dart';
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
    return Form(
      key: _controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _controller.nameController,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
                labelText: "Nome",
                border: OutlineInputBorder(),
                hintText: "user@email.com"
            ),
            validator: (name) => _controller.validator(name, "Nome"),
          ),
          const SizedBox(height: 15),
          TextFormField(
            controller: _controller.companyController,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
                labelText: "Serviço/Profissão", border: OutlineInputBorder()),
            validator: (company) => _controller.validator(company, "Serviço/Profissão"),
          ),
          // const SizedBox(height: 15),
          // const Text(
          //   "Tema",
          //   style: TextStyle(
          //     fontSize: 16,
          //   ),
          // ),
          // switchTheme(),
          const SizedBox(height: 15),
          TextFormField(
            controller: _controller.phoneController,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: "Telefone"),
            validator: (phone) => _controller.validator(phone, "Telefone"),
          ),
          const SizedBox(height: 15),
          TextFormField(
            controller: _controller.emailController,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
                labelText: "Email", border: OutlineInputBorder()),
            validator: (email) => _controller.validatorEmail(email),
          ),
          const SizedBox(height: 15),
          StreamBuilder<bool>(
            stream: _controller.togglePasswordController.stream,
            initialData: true,
            builder: (context, snapshot) {
              return TextFormField(
                controller: _controller.passwordController,
                obscureText: snapshot.data ?? true,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  suffixIcon: IconButton(onPressed: () => _controller.togglePassword(), icon: snapshot.data == true ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility)),
                  labelText: "Senha", border: const OutlineInputBorder()),
                  validator: (password) => _controller.validatorPassword(password),
              );
            }
          ),
          const SizedBox(height: 15),
          StreamBuilder<bool>(
            stream: _controller.togglePasswordConfirmationController.stream,
            initialData: true,
            builder: (context, snapshot) {
              return TextFormField(
                controller: _controller.passwordConfirmationController,
                obscureText: snapshot.data ?? true,
                textInputAction: TextInputAction.go,
                decoration: InputDecoration(
                  suffixIcon: IconButton(onPressed: () => _controller.togglePasswordConfirmation(), icon: snapshot.data == true ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility)),
                  labelText: "Confirmar senha", border: const OutlineInputBorder()),
                validator: (passwordConfirmation) => _controller.validatorPasswordConfirmation(passwordConfirmation),
              );
            }
          ),
          StreamBuilder<bool>(
            initialData: false,
            stream: _controller.signingUpController.stream,
            builder: (context, snapshot) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: createButton('Cadastrar', () => _controller.registerUser(context), snapshot.data ?? false),
              );
            }
          ),
        ],
      ),
    );
  }
}

Widget createButton(String label, VoidCallback onPressed, bool signingUp) {
  return SizedBox(
      height: 65,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: signingUp ? () {} : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(20, 28, 95, 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: signingUp ? const CircularProgressIndicator(color: Colors.white) : Text(
            style: const TextStyle(fontSize: 18, color: Colors.white), label),
      ));
}

AppBar customAppBar(BuildContext context, {String title = ''}) {
  return AppBar(
    centerTitle: true,
    backgroundColor: const Color.fromRGBO(20, 28, 95, 1),
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
      [Color.fromRGBO(20, 28, 95, 1)],
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
