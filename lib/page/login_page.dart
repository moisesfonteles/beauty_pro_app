import 'package:beauty_pro/controller/login_controller.dart';
import 'package:beauty_pro/page/forgot_password.dart';
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
        children: [Image.asset("assets/logoijobs.png"), loginWidget(context)],
      ),
    );
  }

  Widget loginWidget(BuildContext context) {
    return StreamBuilder<bool>(
      initialData: false,
      stream: _controller.loggingInController.stream,
      builder: (context, snapshot) {
        return Form(
          key: _controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _controller.emailController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Email"),
                validator: (email) => _controller.validator(email, "E-mail"),
              ),
              const SizedBox(height: 15),
              StreamBuilder<bool>(
                stream: _controller.togglePasswordController.stream,
                initialData: true,
                builder: (context, snapshot) {
                  return TextFormField(
                    controller: _controller.passwordController,
                      textInputAction: TextInputAction.next,
                      obscureText: snapshot.data ?? true,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(onPressed: () => _controller.togglePassword(), icon: snapshot.data == true ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility)),
                        border: const OutlineInputBorder(),
                        labelText: "Senha",
                      ),
                      validator: (password) => _controller.validator(password, "Senha"),
                      );
                }
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: createButton('Entrar', () => _controller.loginUser(context), snapshot.data ?? false),
              ),
              smallButons(context, snapshot.data ?? false)
            ],
          ),
        );
      }
    );
  }
}

Widget createButton(String label, VoidCallback onPressed, bool loggingIn) {
  return SizedBox(
      height: 65,
      width: double.infinity,
      child: ElevatedButton(
        onPressed:loggingIn ? () {} : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:  const Color.fromRGBO(20, 28, 95, 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: loggingIn ? const CircularProgressIndicator(color: Colors.white) : Text(
            style: const TextStyle(fontSize: 18, color: Colors.white), label),
      )
    );
}

Widget smallButons(BuildContext context, bool loggingIn) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      InkWell(
        onTap: loggingIn ? () {} : () => Navigator.push(context, MaterialPageRoute(builder:(context) => const ForgotPassword(),)),
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
          loggingIn ? () {} :
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
