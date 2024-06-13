import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:beauty_pro/model/service.dart';
import 'package:beauty_pro/page/edit_account.dart';
import 'package:beauty_pro/page/edit_add_service_page.dart';
import 'package:beauty_pro/services/user_authentication.dart';

class HomePage extends StatefulWidget {
  String? email;
  HomePage({super.key, this.email});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController customer = TextEditingController();
  TextEditingController service = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController hour = TextEditingController();
  final _serviceController = BehaviorSubject<List<ServiceModel>>();

  List<ServiceModel>? services;

  final _userAuthentication = UserAuthentication();

  late String userID = _userAuthentication.getCurrentUserId() ?? "";
  // final _controller = HomeController();

  final Map<DateTime, List<ServiceModel>> _eventsMap = {};

  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    initHome();
    loadServices();
  }

  Map<String, String> extrairDiaEMes(String dataISO) {
    DateTime data = DateTime.parse(dataISO);
    int dia = data.day;
    int mes = data.month;

    List<String> meses = [
      'janeiro',
      'fevereiro',
      'março',
      'abril',
      'maio',
      'junho',
      'julho',
      'agosto',
      'setembro',
      'outubro',
      'novembro',
      'dezembro'
    ];

    return {
      'dia': dia.toString(),
      'mes': meses[mes - 1],
    };
  }

  Future<void> initHome() async {
    services = await _getEvents();
    if (services != null) {
      _serviceController.sink.add(services!);
    } else {
      log("Não foi possível carregar os serviços");
    }
  }

  Future<List<ServiceModel>?> _getEvents() async {
    final url = Uri.parse("http://192.168.124.164:3000/listar/$userID");
    final response = await http.get(url);

    try {
      if (response.statusCode == 200) {
        final List<dynamic> json = jsonDecode(response.body);

        final services = json.map<ServiceModel>((item) {
          return ServiceModel.fromJson(item);
        }).toList();

        return services;
      } else {
        log("Erro na resposta: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      log("Erro ao buscar eventos: $e");
      return null;
    }
  }

  Future<void> loadServices() async {
    try {
      final services = await _getEvents();
      final Map<DateTime, List<ServiceModel>> _services = {};
      for (ServiceModel service in services!) {
        // Convertendo a string de data para DateTime
        DateTime dateTime = DateTime.parse(service.date!);
        DateTime dateKey =
            DateTime.utc(dateTime.year, dateTime.month, dateTime.day);
        _services.putIfAbsent(dateKey, () => []).add(service);
      }
      setState(() {
        _eventsMap.clear();
        _eventsMap.addAll(_services);
        _serviceController.sink.add(_getEventsForDay(_selectedDay));
      });
    } catch (error) {
      setState(() {});
    }
  }

  List<ServiceModel> _getEventsForDay(DateTime dateKey) {
    return _eventsMap[dateKey] ?? [];
  }

  Future<void> sendServiceToApi(
      String userIdApi,
      String custumerApi,
      String serviceApi,
      String dataApi,
      String hourApi,
      String valueApi,
      int avaliacaoApi) async {
    final url = Uri.parse("http://192.168.124.164:3000/registrar");
    final response = await http.post(url,
        headers: {'Content-Type': "application/json"},
        body: json.encode({
          'userId': userIdApi,
          'customer': custumerApi,
          'service': serviceApi,
          'date': dataApi,
          'hour': hourApi,
          'price': valueApi,
          'avaliacao': avaliacaoApi
        }));
    if (response.statusCode != 200) {
      log("Não foi possível registrar o serviço no banco de dados");
    } else {
      final model = ServiceModel(
          customer: custumerApi,
          service: serviceApi,
          date: dataApi,
          hour: hourApi,
          price: valueApi);
      services?.add(model);

      // Atualizar o StreamController com a nova lista de serviços
      _serviceController.sink.add(List.from(services!));

      // Recarregar os eventos no calendário
      loadServices();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, title: "Agenda"),
      drawer: Drawer(
          backgroundColor: const Color.fromRGBO(20, 28, 95, 1),
          child: drawerOpitions(context, widget.email!)),
      floatingActionButton: floatingActionButton(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TableCalendar(
                eventLoader: (day) {
                  return _getEventsForDay(day);
                },
                locale: 'pt_BR',
                firstDay: DateTime.utc(2000, 1, 1),
                lastDay: DateTime.utc(2100, 1, 1),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                  _serviceController.sink.add(_getEventsForDay(_focusedDay));
                },
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                headerVisible: true,
              ),
              StreamBuilder<List<ServiceModel>>(
                stream: _serviceController.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<ServiceModel> services = snapshot.data ?? [];
                    return SizedBox(
                      height: MediaQuery.of(context).size.height / 2,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: services.length,
                        itemBuilder: (context, index) {
                          ServiceModel service = services[index];
                          Map<String, String> dataSeparada =
                              extrairDiaEMes(service.date!);

                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              width: 150,
                              height: 100,
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(20, 28, 95, 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          dataSeparada['dia'] ?? "na",
                                          style: const TextStyle(
                                            fontSize: 26,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Color.fromRGBO(20, 28, 95, 1),
                                          ),
                                        ),
                                        Text(
                                          dataSeparada['mes'] ?? "na",
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            service.customer ??
                                                "Não encontrado",
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            service.service ?? "Não encontrado",
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: Text(
                                              '\$${service.price}',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return const Text('Não foi possível carregar os Serviços');
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
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

  Widget createButton(String label, VoidCallback onPressed) {
    return SizedBox(
        height: 50,
        width: 150,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(20, 28, 95, 1),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
          child: Text(
              style: const TextStyle(fontSize: 18, color: Colors.white), label),
        ));
  }

  Widget drawerOpitions(BuildContext context, String email) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 128, 5, 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.work, size: 40, color: Colors.white),
            label: const Text(
              "IJob",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
          TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditAccount()),
              );
            },
            icon: const Icon(Icons.person, size: 40, color: Colors.white),
            label: Text(
              email,
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
          TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const EditAddServicePage()),
              );
            },
            icon: const Icon(Icons.search, size: 40, color: Colors.white),
            label: const Text(
              'Buscar serviços',
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

  Widget floatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                scrollable: true,
                title: const Text('Adicionar serviço'),
                content: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: customer,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                            labelText: "Cliente", border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: hour,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                            labelText: "Horario", border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: service,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                            labelText: "Serviço", border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: price,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                            labelText: "Preço", border: OutlineInputBorder()),
                      ),
                    ],
                  ),
                ),
                actions: [
                  Center(
                    child: createButton("Adicionar", () {
                      sendServiceToApi(
                              userID.toString(),
                              customer.text,
                              service.text,
                              _selectedDay.toIso8601String(),
                              hour.text,
                              price.text,
                              0)
                          .catchError((error) => ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(
                                  content: Text(
                                      'Falha ao adicionar evento: $error'))));

                      Navigator.of(context).pop();
                      customer.clear();
                      service.clear();
                      hour.clear();
                      price.clear();
                    }),
                  ),
                ],
              );
            });
      },
      child: const Icon(Icons.add),
    );
  }
}
