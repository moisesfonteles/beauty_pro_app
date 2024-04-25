import 'package:beauty_pro/page/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AddServicePage extends StatefulWidget {
  const AddServicePage({super.key});

  @override
  State<AddServicePage> createState() => _AddServicePageState();
}

class _AddServicePageState extends State<AddServicePage> {
  List<Map<String, String>> services = [
    {
      "name": "Serviço A",
      "value": "R\$100",
    },
    {
      "name": "Serviço B",
      "value": "R\$200",
    },
    {
      "name": "Serviço B",
      "value": "R\$200",
    },
    {
      "name": "Serviço B",
      "value": "R\$200",
    },
    {
      "name": "Serviço B",
      "value": "R\$200",
    },
  
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar(context, title: 'Adicionar serviço'),
        backgroundColor: const Color.fromRGBO(244, 244, 244, 1),
        body: SingleChildScrollView(child: bodyAddService(context)));
  }

  Widget bodyAddService(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 25),
      child: Column(children: [addServiceWidget(context)]),
    );
  }

  Widget addServiceWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
              labelText: "Nome do serviço",
              border: OutlineInputBorder(),
              hintText: "user@email.com"),
        ),
        const SizedBox(height: 15),
        TextFormField(
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
              labelText: "Valor", border: OutlineInputBorder()),
        ),
        const SizedBox(height: 15),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: createButton('Adicionar', () {}, 150),
          ),
        ),
        SingleChildScrollView(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service["name"]!,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(service["value"]!),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: createButton('Continuar', () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
                (Route<dynamic> route) => false,
              );
            }, double.infinity),
          ),
        ),
      ],
    );
  }
}

Widget createButton(String label, VoidCallback onPressed, double width) {
  return SizedBox(
      height: 65,
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(39, 144, 176, 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: Text(
            style: const TextStyle(fontSize: 18, color: Colors.white), label),
      ));
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
