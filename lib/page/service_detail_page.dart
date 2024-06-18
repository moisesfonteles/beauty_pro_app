import 'package:beauty_pro/page/edit_add_service_page.dart';
import 'package:beauty_pro/services/user_authentication.dart';
import 'package:flutter/material.dart';
import 'package:beauty_pro/model/service.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:mailto/mailto.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceDetailPage extends StatefulWidget {
  final ServiceModel service;

  const ServiceDetailPage({Key? key, required this.service}) : super(key: key);

  @override
  _ServiceDetailPageState createState() => _ServiceDetailPageState();
}

class _ServiceDetailPageState extends State<ServiceDetailPage> {
  int _rating = 0;
  final _userAuthentication = UserAuthentication();

  TextEditingController emailBody = TextEditingController();

  late String userID = _userAuthentication.getCurrentUserId() ?? "";

  @override
  void initState() {
    super.initState();
    fetchRating();
  }

  void fetchRating() {
    _rating = widget.service.avaliacao!;
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
            const Text(
              'Avaliação:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            _buildStarRating(),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitRating,
              child: const Text('Avaliar'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Dúvidas:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            TextFormField(
              controller: emailBody,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async =>
                  await _sendEmail("jp53@edu.unifor.br", emailBody.text),
              child: const Text('Enviar email'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStarRating() {
    return Row(
      children: List.generate(5, (index) {
        return IconButton(
          onPressed: () {
            setState(() {
              _rating = index + 1;
            });
          },
          icon: Icon(
            index < _rating ? Icons.star : Icons.star_border,
            color: Colors.yellow,
          ),
        );
      }),
    );
  }

  void _submitRating() async {
    final url = Uri.parse('http://192.168.124.164:3000/avaliar/$userID');
    final response = await http.put(
      url,
      body: {
        'avaliacao': _rating.toString(),
      },
    );

    if (response.statusCode == 200) {
      print('Avaliação enviada com sucesso!');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Serviço avaliado com sucesso!'),
          duration: Duration(seconds: 3), // Duração do SnackBar
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const EditAddServicePage()),
      );
      // Aqui você pode adicionar a lógica para lidar com o sucesso da operação
    } else {
      print('Erro ao enviar avaliação: ${response.statusCode}');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Erro ao enviar avaliação. Tente novamente mais tarde.'),
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

Future<void> _sendEmail(String toEmail, String body) async {
  final mailtoLink = Mailto(
    to: [toEmail],
    subject: "Contratar serviço",
    body: body,
  );

  final url = mailtoLink.toString();
  await launch(url);
}
