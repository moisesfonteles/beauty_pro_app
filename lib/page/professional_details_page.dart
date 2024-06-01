import 'package:beauty_pro/model/professional.dart';
import 'package:flutter/material.dart';

class ProfessionalDetailsPage extends StatelessWidget {
  final Professional professional;

  const ProfessionalDetailsPage({required this.professional});

  void _showHireDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Contratar ${professional.name}'),
          content:
              Text('Tem certeza de que deseja contratar este profissional?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Adicione a funcionalidade de contratação aqui
              },
              child: Text('Sim'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Não'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, title: professional.role),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              professional.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              professional.type,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(
                professional.rating,
                (index) => Icon(Icons.star, color: Colors.yellow),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _showHireDialog(context);
                },
                child: Text('Contratar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
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
