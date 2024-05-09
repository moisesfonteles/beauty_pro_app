import 'package:beauty_pro/controller/forgot_password_controller.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  final _controller = ForgotPasswordController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, title: "Recuperar senha"),
      body: body(),
    );
  }

  Widget body() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _controller.formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _controller.emailController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Email"),
              validator: (email) => _controller.validatorEmail(email),
            ),
            const SizedBox(height: 16,),
            SizedBox(
              height: 65,
              width: double.maxFinite,
              child: StreamBuilder<bool>(
                initialData: false,
                stream: _controller.sendingPasswordResetController.stream,
                builder: (context, snapshot) {
                  return ElevatedButton(
                    onPressed: () => snapshot.data ?? false ? () {} : _controller.recoverPassword(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(39, 144, 176, 1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                    child: snapshot.data ?? false ? const CircularProgressIndicator(color: Colors.white) : const Text(style: TextStyle(fontSize: 18, color: Colors.white), "Enviar"),
                  );
                }
              ),
            )
          ],
        ),
      ),
    );
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
}