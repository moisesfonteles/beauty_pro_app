import 'package:flutter/material.dart';
import 'package:beauty_pro/model/event.dart';
import 'package:beauty_pro/services/user_authentication.dart';
import 'package:intl/intl.dart';

class EventDetailsPage extends StatelessWidget {
  final Event event;

  EventDetailsPage({super.key, required this.event});

  final _userAuthentication = UserAuthentication();
  late String userID = _userAuthentication.getCurrentUserId() ?? "";

  @override
  Widget build(BuildContext context) {

    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    final String formattedDate = formatter.format(event.date);

    TextStyle boldStyle = const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 18,
    );

    return Scaffold(
      appBar: customAppBar(context, title: "Detalhes do evento"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Data: $formattedDate', style: boldStyle),
            Text('Cliente: ${event.customer}', style: boldStyle),
            Text('Horário: ${event.hour}', style: boldStyle),
            Text('Serviço: ${event.service}', style: boldStyle),
            Text('Preço: R\$ ${event.price.toStringAsFixed(2)}', style: boldStyle),
            const SizedBox(height: 16),
            Center(
              child: createButton(
                "Excluir atendimento",
                () {
                  _userAuthentication.deleteEventFromFirestore(userID, event.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Atendimento excluído com sucesso'),
                      duration: Duration(seconds: 4),
                      backgroundColor: Colors.green, // Defina a duração do SnackBar
                    ),
                  );
                  Navigator.pop(context);
                },
             
              ),
            ),
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

  Widget createButton(String label, VoidCallback onPressed) {
    return SizedBox(
        height: 50,
        width: 180,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 243, 75, 75),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
          child: Text(
              style: const TextStyle(fontSize: 14, color: Colors.white), label),
        ));
  }
}
