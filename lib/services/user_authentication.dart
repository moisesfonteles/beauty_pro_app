import 'package:beauty_pro/model/event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
 

class UserAuthentication{
  
  final firebaseAuth = FirebaseAuth.instance;

  Future<String?> registerUser({
    required String name,
    required String job,
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

      await FirebaseFirestore.instance.collection('userIjobs').doc(userCredential.user!.uid).set({
      'name': name,
      'email': email,
      'job': job,
      'phone': phone,
    });

      

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
      } else if(e.message == "The email address is badly formatted."){
        return "O e-mail está mal formatado";
      }else {
        return e.message;
      }
    }
  }

  Future<void> logout() async {
    return firebaseAuth.signOut();
  }

  Future<String?> recoverPassword(String email) async {
    try{
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch(e) {
      if(e.message == "The email address is badly formatted.") {
        return "O e-mail está mal formatado";
      } else {
        return e.message;
      }
    }
  }

  Future<void> addEventToUser(
    String userId,
     String customer,
      String service,
       DateTime date,
        String hour,
        double price
        ) async {
  try {
    await FirebaseFirestore.instance.collection('users').doc(userId).collection('events').add({
      'customer': customer,
      'service': service,
      'date': date,
      'hour': hour,
      'price': price
      
    });
  } catch (e) {
    print('Erro ao adicionar evento ao usuário: $e');
  }

 
}

 String? getCurrentUserId() {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;
  
  if (user != null) {
    return user.uid;
  } else {
    
    return null;
  }
}

Future<List<Event>> fetchEventsFromFirestore(String userID) async {
  final events = <Event>[];

  try {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('events')
        .get();

    snapshot.docs.forEach((doc) {
      Timestamp timestamp = doc['date'];
      DateTime date = timestamp.toDate();
      String customer = doc['customer'];
      String hour = doc['hour'];
      double price = doc['price'];
      String service = doc['service']; // Replace with actual property name

      events.add(Event(date: date, customer: customer, hour: hour, price: price, service: service));
    });
  } catch (error) {
    print('Error fetching events: $error');
  }

  return events;
}


}