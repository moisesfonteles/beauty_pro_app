import 'package:beauty_pro/components/professional_card.dart';
import 'package:beauty_pro/model/professional.dart';
import 'package:beauty_pro/page/contracted_services.dart';
import 'package:beauty_pro/page/dashboard_page.dart';
import 'package:beauty_pro/page/edit_account.dart';
import 'package:beauty_pro/page/edit_add_service_page.dart';
import 'package:beauty_pro/services/user_authentication.dart';
import 'package:flutter/material.dart';

class ProfessionalsPage extends StatefulWidget {
  String? email;
  ProfessionalsPage({super.key, this.email});

  @override
  State<ProfessionalsPage> createState() => _ProfessionalsPageState();
}

class _ProfessionalsPageState extends State<ProfessionalsPage> {
  final List<Professional> professionals = [
    Professional('Pintor', 'Marcus Paulo', 'Credit', 5),
    Professional('Marceneiro', 'Felipe Duquet', 'Debit', 4),
    Professional('Pedreiro', 'Marcus Paulo', 'Debit', 5),
    Professional('Pintor', 'Marcus Paulo', 'Credit', 5),
  ];

  String query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, title: "IJob"),
      drawer: Drawer(
          backgroundColor: const Color.fromRGBO(20, 28, 95, 1),
          child: drawerOpitions(context, widget.email!)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'profissionais, problemas, áreas',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (text) {
                setState(() {
                  query = text;
                });
              },
            ),
          ),
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

Widget drawerOpitions(BuildContext context, String email) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(5, 128, 5, 5),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EditAccount()),
            );
          },
          icon: const Icon(Icons.person, size: 40, color: Colors.white),
          label: Text(
            '$email',
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
        TextButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DashboardPage()),
            );
          },
          icon: const Icon(Icons.dashboard, size: 40, color: Colors.white),
          label: const Text(
            'Dashboard',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
        TextButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ContractedServices()),
            );
          },
          icon: const Icon(Icons.settings, size: 40, color: Colors.white),
          label: const Text(
            'Serviços contratados',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
        TextButton.icon(
          onPressed: () => UserAuthentication().logout(),
          icon: const Icon(Icons.exit_to_app, size: 40, color: Colors.white),
          label: const Text(
            'Sair',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ],
    ),
  );
}
