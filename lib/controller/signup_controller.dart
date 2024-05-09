import 'dart:async';
import 'package:beauty_pro/services/user_authentication.dart';
import 'package:flutter/material.dart';

class SignUpController{

  TextEditingController nameController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmationController = TextEditingController();

  final StreamController<bool> togglePasswordController = StreamController<bool>();
  final StreamController<bool> togglePasswordConfirmationController = StreamController<bool>();
  final StreamController<bool> signingUpController = StreamController<bool>();

  final formKey = GlobalKey<FormState>();
  final _userAuthentication = UserAuthentication();

  bool isObscuredePassword = true;
  bool isObscuredePasswordConfirmation = true;
  bool signingUp = false;

  String? validator(String? value, String text) {
    value = value?.trim();
    if(value == null || value.isEmpty){
      return "$text obrigatório";
    }
    return null;
  }

  String? validatorEmail(String? value) {
    value = value?.trim();
    if(value == null || value.isEmpty){
      return "E-mail obrigatório";
    } else if(!_isValidEmail(emailController.text)){
      return "E-mail inválido";
    }
    return null;
  }

  String? validatorPassword(String? value) {
    value = value?.trim();
    if((value ?? "").isEmpty) {
      return "Sua senha não pode ser vazia";
    } else if((value ?? "").length < 8) {
      return "Sua senha deve ter pelo menos 8 caracteres";
    }
    return null;
  }

  String? validatorPasswordConfirmation(String? value) {
    value = value?.trim();
    if((value ?? "").isEmpty) {
      return "Por favor, confirme a senha";
    } else if(value != passwordController.text) {
      return "As senhas não coincidem";
    }
    return null;
  }

  void togglePassword() {
    isObscuredePassword = !isObscuredePassword;
    togglePasswordController.sink.add(isObscuredePassword);
  }

  void togglePasswordConfirmation() {
    isObscuredePasswordConfirmation = !isObscuredePasswordConfirmation;
    togglePasswordConfirmationController.sink.add(isObscuredePasswordConfirmation);
  }

  Future<void> registerUser(BuildContext context) async {
    if(formKey.currentState?.validate() ?? false) {
      signingUp = true;
      signingUpController.sink.add(signingUp);
      await _userAuthentication.registerUser(
        name: nameController.text,
        company: companyController.text,
        phone: phoneController.text,
        email: emailController.text,
        password: passwordController.text
      ).then((String? error) {
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: Colors.red,
            ),
        );
        signingUp = false;
        signingUpController.sink.add(signingUp);
      } else {
        // _userAuthentication.logout();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Cadastro realizado com sucesso"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    });
    // Navigator.push(
    //     context,
    //     // MaterialPageRoute(builder: (context) => const AddServicePage()),
    //     MaterialPageRoute(builder: (context) => const LoginPage())
    // );
    }
  }

  bool _isValidEmail(String email) {
    RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

}