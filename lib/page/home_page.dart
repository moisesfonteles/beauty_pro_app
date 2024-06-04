import 'dart:convert';
import 'dart:developer';
import 'package:beauty_pro/model/event.dart';
import 'package:beauty_pro/model/service.dart';
import 'package:beauty_pro/page/dashboard_page.dart';
import 'package:beauty_pro/page/edit_account.dart';
import 'package:beauty_pro/page/edit_add_service_page.dart';
import 'package:beauty_pro/services/user_authentication.dart';
import 'package:rxdart/rxdart.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  final Map<DateTime, List<Event>> _eventsMap = {};

  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    initHome();
  }

  Future<void> initHome() async {
    services = await _getEvents();
    _serviceController.sink.add(services ?? []);
  }

  Future<List<ServiceModel>?> _getEvents() async {
    final url = Uri.parse("http://192.168.124.197:3000/listar/$userID");
    final response = await http.get(url);

    try{
      if (response.statusCode == 200) {
        log(response.body);
        final json = jsonDecode(response.body);
        return json.map((item) => ServiceModel.fromJson(item));
      } else {
        log("${response.statusCode}");
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  List<Event> _getEventsForDay(DateTime dateKey) {
    return _eventsMap[dateKey] ?? [];
  }

  Future<void> sendServiceToApi(
      String userIdApi,
      String custumerApi,
      String serviceApi,
      String dataApi,
      String hourApi,
      String valueApi) async {
    final url = Uri.parse("http://192.168.124.197:3000/registrar");
    final response = await http.post(url,
        headers: {'Content-Type': "application/json"},
        body: json.encode({
          'userId': userIdApi,
          'customer': custumerApi,
          'service': serviceApi,
          'date': dataApi,
          'hour': hourApi,
          'price': valueApi
        }));
    if (response.statusCode != 200) {
      log("Não foi possível registrar o serviço no banco de dados");
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
      body: Column(
        children: [
          TableCalendar(
            eventLoader: (day) {
              final teste = _getEventsForDay(day);
              print(teste);
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
                return ListView.builder(
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    ServiceModel service = services[index];
                    return ListTile(
                      title: Text(service.customer ?? "Cliente indisponível"),
                      subtitle: Text(service.price ?? "Preço indisponível"),
                      trailing: Text('\$${service.service}'),
                    );
                  },
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
                MaterialPageRoute(
                    builder: (context) => const EditAddServicePage()),
              );
            },
            icon: const Icon(Icons.settings, size: 40, color: Colors.white),
            label: const Text(
              'Gerenciar serviços',
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
                title: const Text('Adiconar atendimento'),
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
                              price.text)
                          .catchError((error) => ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(
                                  content: Text(
                                      'Falha ao adicionar evento: $error'))));

                      setState(() {
                        _getEvents();
                      });
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
