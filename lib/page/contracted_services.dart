import 'package:beauty_pro/components/professional_card.dart';
import 'package:beauty_pro/model/professional.dart';
import 'package:flutter/material.dart';

class ContractedServices extends StatefulWidget {
  const ContractedServices({super.key});

  @override
  State<ContractedServices> createState() => _ContractedServicesState();
}

class _ContractedServicesState extends State<ContractedServices> {
  final List<Professional> professionals = [
    Professional('Pintor', 'Marcus Paulo', 'Credit', 5),
    Professional('Marceneiro', 'Felipe Duquet', 'Debit', 4),
  ];

  String query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, title: "Serviços Contrados"),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: professionals.length,
              itemBuilder: (context, index) {
                if (query.isEmpty ||
                    professionals[index]
                        .role
                        .toLowerCase()
                        .contains(query.toLowerCase())) {
                  return ProfessionalCard(professionals[index]);
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
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
