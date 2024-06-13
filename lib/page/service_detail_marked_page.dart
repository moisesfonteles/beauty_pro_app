import 'package:beauty_pro/page/edit_add_service_page.dart';
import 'package:beauty_pro/page/home_page.dart';
import 'package:beauty_pro/services/user_authentication.dart';
import 'package:flutter/material.dart';
import 'package:beauty_pro/model/service.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:mailto/mailto.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceDetailMarkedPage extends StatefulWidget {
  final ServiceModel service;
  final String? email;

  const ServiceDetailMarkedPage(
      {Key? key, required this.service, required this.email})
      : super(key: key);

  @override
  _ServiceDetailMarkedPageState createState() =>
      _ServiceDetailMarkedPageState();
}

class _ServiceDetailMarkedPageState extends State<ServiceDetailMarkedPage> {
  final _userAuthentication = UserAuthentication();

  TextEditingController emailBody = TextEditingController();

  late String userID = _userAuthentication.getCurrentUserId() ?? "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, title: "Detalhes do serviço"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nome do Cliente:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              "${widget.service.customer}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Valor:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              "\$${widget.service.price}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Descrição:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              "${widget.service.service}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _deleteService,
              child: const Text('Deletar Serviço'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteService() async {
    final url =
        Uri.parse('http://192.168.124.164:3000/deletar/${widget.service.id}');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      print('Serviço deletado com sucesso!');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Serviço deletado com sucesso!'),
          duration: Duration(seconds: 3), // Duração do SnackBar
        ),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(
                  email: widget.email,
                )),
        (Route<dynamic> route) => false,
      );
      // Aqui você pode adicionar a lógica para lidar com o sucesso da operação
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao deletadar. Tente novamente mais tarde.'),
          duration: Duration(seconds: 3), // Duração do SnackBar
        ),
      );
      // Aqui você pode adicionar a lógica para lidar com erros de requisição
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
}
