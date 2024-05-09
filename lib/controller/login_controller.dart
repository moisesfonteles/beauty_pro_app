import 'dart:async';

import 'package:beauty_pro/services/user_authentication.dart';
import 'package:flutter/material.dart';

class LoginController{

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _userAuthentication = UserAuthentication();

  final StreamController<bool> togglePasswordController = StreamController<bool>();
  final StreamController<bool> loggingInController = StreamController<bool>();

  bool isObscuredePassword = true;
  bool loggingIn = true;

  final formKey = GlobalKey<FormState>();

  String? validator(String? value, String text) {
    value = value?.trim();
    if(value == null || value.isEmpty){
      return "$text não pode ser vazio!";
    }
    return null;
  }

  void togglePassword() {
    isObscuredePassword = !isObscuredePassword;
    togglePasswordController.sink.add(isObscuredePassword);
  }

  void loginUser(BuildContext context) {
    if(formKey.currentState?.validate() ?? false) {
      loggingIn = true;
      loggingInController.sink.add(loggingIn);
      _userAuthentication.loginUser(
        email: emailController.text,
        password: passwordController.text
      ).then((String? erro) {
        if (erro != null) {
          loggingIn = false;
          loggingInController.sink.add(loggingIn);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(erro),
            backgroundColor: Colors.red,
            ),
          );
        }
      });
    }
  }


}