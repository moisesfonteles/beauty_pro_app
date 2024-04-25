
import 'package:beauty_pro/page/dashboard_page.dart';
import 'package:beauty_pro/page/edit_account.dart';
import 'package:beauty_pro/page/edit_add_service_page.dart';
import 'package:beauty_pro/page/login_page.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, title: "Agenda"),
      drawer: Drawer(
        backgroundColor: const Color.fromRGBO(39, 144, 176, 1),
        child: drawerOpitions(context)
      ),
      body:  Stack(
        children: [
        
          TableCalendar(
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
          
       
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
               showDialog(
                context: context,
                builder: (context){
                  return AlertDialog(
                    scrollable: true,
                    title: Text('Adiconar atendimento'),
                    content: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          TextFormField(
                                    textInputAction: TextInputAction.next,
                                    decoration: const InputDecoration(
                                        labelText: "Cliente", border: OutlineInputBorder()),
                                  ),
                                  const SizedBox(height: 15),
                                  TextFormField(
                                    textInputAction: TextInputAction.next,
                                    decoration: const InputDecoration(
                                        labelText: "Horario", border: OutlineInputBorder()),
                                  ),
                                  const SizedBox(height: 15),
                                  TextFormField(
                                    textInputAction: TextInputAction.next,
                                    decoration: const InputDecoration(
                                        labelText: "Serviço", border: OutlineInputBorder()),
                                  ),
                                 
                                 
                        ],
                      ),
                      ),
                      actions: [
                        Center(
                          child: createButton("Adicionar", () {
                          Navigator.of(context).pop();
                         }),
                        )
                        ,
                        
                        ],
                  );
                } );
              },
              child: Icon(Icons.add),
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
              
           
              TextButton.icon(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                (Route<dynamic> route) => false,
              );
                },
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