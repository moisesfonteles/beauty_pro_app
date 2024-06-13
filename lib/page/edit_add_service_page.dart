import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:beauty_pro/model/service.dart';
import 'package:beauty_pro/page/service_detail_page.dart';

class EditAddServicePage extends StatefulWidget {
  const EditAddServicePage({Key? key});

  @override
  _EditAddServicePageState createState() => _EditAddServicePageState();
}

class _EditAddServicePageState extends State<EditAddServicePage> {
  final TextEditingController _searchController = TextEditingController();
  final BehaviorSubject<List<ServiceModel>> _servicesController =
      BehaviorSubject<List<ServiceModel>>();

  List<ServiceModel> _allServices = [];

  @override
  void initState() {
    super.initState();
    _fetchServices(); // Fetch services initially
    _searchController.addListener(_filterServices);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _servicesController.close();
    super.dispose();
  }

  Future<void> _fetchServices() async {
    final url = Uri.parse("http://192.168.124.164:3000/listar");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body);
      final List<ServiceModel> services = json.map((item) {
        return ServiceModel.fromJson(item);
      }).toList();
      _allServices = services;
      _servicesController.sink.add(_allServices);
    } else {
      // Handle error
    }
  }

  void _filterServices() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      _servicesController.sink.add(_allServices);
    } else {
      final filteredServices = _allServices.where((service) {
        final nameLower = service.service?.toLowerCase();
        return nameLower!.contains(query);
      }).toList();
      _servicesController.sink.add(filteredServices);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, title: "Buscar Serviços"),
      body: SingleChildScrollView(child: bodyAddService(context)),
    );
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
          controller: _searchController,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            labelText: "Nome do serviço",
            icon: Icon(Icons.search),
            border: OutlineInputBorder(),
            hintText: "Digite o serviço que você deseja procurar...",
          ),
        ),
        const SizedBox(height: 15),
        StreamBuilder<List<ServiceModel>>(
          stream: _servicesController.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final services = snapshot.data!;
              return ListView.builder(
                shrinkWrap: true,
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final service = services[index];
                  return GestureDetector(
                    onTap: () {
                      _navigateToServiceDetail(service);
                    },
                    child: Padding(
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
                              '${service.service}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text('\$${service.price}'),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return const Text('Erro ao carregar serviços');
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ],
    );
  }

  void _navigateToServiceDetail(ServiceModel service) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServiceDetailPage(service: service),
      ),
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
          backgroundColor: const Color.fromRGBO(20, 28, 95, 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: Text(
            style: const TextStyle(fontSize: 18, color: Colors.white), label),
      ));
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
