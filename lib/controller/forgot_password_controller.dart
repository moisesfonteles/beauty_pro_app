import 'dart:async';
import 'package:beauty_pro/services/user_authentication.dart';
import 'package:flutter/material.dart';

class ForgotPasswordController{

  TextEditingController emailController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final _userAuthentication = UserAuthentication();

  StreamController<bool> sendingPasswordResetController = StreamController<bool>();

  bool sendingPasswordReset = false;

  String? validatorEmail(String? value) {
    value = value?.trim();
    if(value == null || value.isEmpty){
      return "E-mail não pode ser vazio!";
    }
    return null;
  }

  Future<void> recoverPassword(BuildContext context) async {
    if(formKey.currentState?.validate() ?? false) {
      sendingPasswordReset = true;
      sendingPasswordResetController.sink.add(sendingPasswordReset);
      await _userAuthentication.recoverPassword(emailController.text).then((String? erro) {
      if(erro != null) {
        sendingPasswordReset = false;
        sendingPasswordResetController.sink.add(sendingPasswordReset);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(erro),
          backgroundColor: Colors.red,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("E-mail enviado com sucesso"),
          backgroundColor: Colors.green,
          )
        );
        Navigator.pop(context);
      }
      });
    }
  }

}