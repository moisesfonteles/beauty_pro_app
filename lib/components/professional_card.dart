import 'package:beauty_pro/model/professional.dart';
import 'package:beauty_pro/page/professional_details_page.dart';
import 'package:flutter/material.dart';

class ProfessionalCard extends StatelessWidget {
  final Professional professional;

  const ProfessionalCard(this.professional);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              professional.role,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('Profissional: ${professional.name}'),
            Text(professional.type),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProfessionalDetailsPage(professional: professional),
                      ),
                    );
                  },
                  child: Text('Veja mais...'),
                ),
                Row(
                  children: List.generate(
                    professional.rating,
                    (index) => Icon(Icons.star, color: Colors.yellow),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
