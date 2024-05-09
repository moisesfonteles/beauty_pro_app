import 'package:firebase_auth/firebase_auth.dart';

class UserAuthentication{
  
  final firebaseAuth = FirebaseAuth.instance;

  Future<String?> registerUser({
    required String name,
    required String company,
    required String phone,
    required String email,
    required String password
  }) async {
    try {
      UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password
      );

      await userCredential.user!.updateDisplayName(name);

      return null;

    } on FirebaseAuthException catch(e) {
      if(e.code == "email-already-in-use") {
        return "Usuário já cadastrado!";
      }
      return "Erro desconhecido";
    }
  }

  Future<String?> loginUser({required String email, required String password}) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch(e) {
      if(e.message == "The supplied auth credential is incorrect, malformed or has expired.") {
        return "Erro de Login! Verifique se você digitou corretamente seu nome de usuário e senha.";
      } else {
        return e.message;
      }
    }
  }

  Future<void> logout() async {
    return firebaseAuth.signOut();
  }

}