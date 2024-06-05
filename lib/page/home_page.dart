
import 'dart:developer';
import 'package:beauty_pro/model/event.dart';
import 'package:beauty_pro/page/dashboard_page.dart';
import 'package:beauty_pro/page/edit_account.dart';
import 'package:beauty_pro/page/edit_add_service_page.dart';
import 'package:beauty_pro/page/event_details_page.dart';
import 'package:beauty_pro/services/user_authentication.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController customer = TextEditingController();
  TextEditingController service = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController hour = TextEditingController();
  
final _userAuthentication = UserAuthentication();



late String userID = _userAuthentication.getCurrentUserId() ?? "";
  // final _controller = HomeController();


Map<DateTime, List<Event>> _eventsMap = {};
bool _isLoading = true;

  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now().toUtc();
    _selectedDay = DateTime.now().toUtc();
    loadEvents();
   
  }




 Future<void> loadEvents() async {
    try {
      final events = await _userAuthentication.fetchEventsFromFirestore(userID);
      final Map<DateTime, List<Event>> _events = {};
      for (Event event in events) {
        DateTime dateKey = DateTime.utc(event.date.year, event.date.month, event.date.day);
        _events.putIfAbsent(dateKey, () => []).add(event);
      }
      setState(() {
        _eventsMap = _events;
        _isLoading = false;
      });
    } catch (error) {
      print('Error loading events: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }
  List<Event> _getEventsForDay(DateTime dateKey) {
    return _eventsMap[dateKey] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    
    if(_isLoading) {
      return const Center(child:  CircularProgressIndicator());
    }
    return Scaffold(
      appBar: customAppBar(context, title: "Agenda"),
      drawer: Drawer(
        backgroundColor: const Color.fromRGBO(39, 144, 176, 1),
        child: drawerOpitions(context)
      ),
      floatingActionButton: floatingActionButton(),
      body: Column(
        children: [
          TableCalendar(
            eventLoader: (day) {
              final events = _getEventsForDay(day);
                print('Day selected: $day');
                print('Events: $events');
                print('Events Map: $_eventsMap');
                return events;
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
          const SizedBox(height: 20),
          // Lista de eventos para o dia selecionado
        if (!_isLoading)
            Expanded(
              child: _buildEventList(_selectedDay),
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
            backgroundColor: const Color.fromRGBO(39, 144, 176, 1),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
          child: Text(
              style: const TextStyle(fontSize: 18, color: Colors.white), label),
        ));
  }

  Widget drawerOpitions (BuildContext context){
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 128, 5, 5),
      child: Column(
              
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              /*
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EditAccount()),
                    );
                  },
                  icon: const Icon(Icons.person , size: 40, color: Colors.white),
                  label: const Text('Editar conta',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white
                  ),
                  ),
                ),
                */
              
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DashboardPage()),
                    );
                  },
                  icon: const Icon(Icons.dashboard , size: 40, color: Colors.white),
                  label: const Text('Dashboard',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white
                  ),
                  ),
                ),
      
                /*
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EditAddServicePage()),
                  );
                  },
                  icon: const Icon(Icons.settings , size: 40, color: Colors.white),
                  label: const Text('Gerenciar serviços',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white
                  ),
                  ),
                ),
                */
            
                TextButton.icon(
                  onPressed: () => UserAuthentication().logout(),
                  icon: const Icon(Icons.exit_to_app, size: 40, color: Colors.white), 
                  label: const Text('Sair',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white
                  ),
                  ),
                ),
              ],
            ),
    );
      
  }

  Widget floatingActionButton() {
    return FloatingActionButton(
      backgroundColor: const Color.fromRGBO(39, 144, 176, 1),
      foregroundColor: Colors.white,
      onPressed: () {
        showDialog(
        context: context,
        builder: (context){
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
                            keyboardType: TextInputType.number,
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
                      _userAuthentication.addEventToUser(userID, customer.text, service.text, _selectedDay, hour.text, double.parse(price.text));
                    setState(() {
                      loadEvents();
                    });
                     ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Atendimento agendado com sucesso'),
                      duration: Duration(seconds: 4),
                      backgroundColor: Colors.green, // Defina a duração do SnackBar
                    ),
                  );    
                  Navigator.of(context).pop();
                  customer.clear();
                  service.clear();
                  hour.clear();
                  price.clear();
                  }),
                )
                ,
                
                ],
          );
        } );
      },
      child: const Icon(Icons.add),
    );
  }

  Widget _buildEventList(DateTime day) {
    final selectedEvents = _getEventsForDay(day);
    
    return ListView.builder(
      itemCount: selectedEvents.length,
      itemBuilder: (context, index) {
        final event = selectedEvents[index];
        return GestureDetector(
           onTap: () {
    Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => EventDetailsPage(event: event),
  ),
).then((_) {
  setState(() {
    loadEvents();
  });
});
  },
          child: Container(
            margin: EdgeInsets.fromLTRB(16, 8, 16, 0),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.lightBlue[50], // Define a cor de fundo como azul claro
              borderRadius: BorderRadius.circular(10), // Define a borda arredondada
              border: Border.all(color: Colors.lightBlue[200]!), // Define a cor e a largura da borda
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Horário
                Expanded(
          flex: 1,
          child: Text(
            event.hour,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
                ),
                // Informações do Cliente e Serviço
                Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cliente: ${event.customer}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                'Serviço: ${event.service}',
              ),
            ],
          ),
                ),
                // Valor
                Expanded(
          flex: 1,
          child: Text(
            'R\$ ${event.price.toStringAsFixed(2)}',
            textAlign: TextAlign.end,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
                ),
              ],
            ),
          ),
        );

      },
    );
  }
}




