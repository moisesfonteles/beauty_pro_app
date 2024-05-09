import 'package:beauty_pro/page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class EditAccount extends StatefulWidget {
  const EditAccount({super.key});

  @override
  State<EditAccount> createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar(context, title: 'Editar conta'),
        backgroundColor: const Color.fromRGBO(244, 244, 244, 1),
        body: SingleChildScrollView(child: bodySignUp()));
  }

  Widget bodySignUp() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 25),
      child: Column(children: [signUpWidget()]),
    );
  }

  Widget signUpWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
              labelText: "Nome",
              border: OutlineInputBorder(),
              hintText: "user@email.com"),
        ),
        const SizedBox(height: 15),
        TextFormField(
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
              labelText: "Serviço/Profissão", border: OutlineInputBorder()),
        ),
        // const SizedBox(height: 15),
        // const Text(
        //   "Tema",
        //   style: TextStyle(
        //     fontSize: 16,
        //   ),
        // ),
        // switchTheme(),
        const SizedBox(height: 15),
        TextFormField(
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
              border: OutlineInputBorder(), labelText: "Telefone"),
        ),
        const SizedBox(height: 15),
        TextFormField(
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
              labelText: "Email", border: OutlineInputBorder()),
        ),
        const SizedBox(height: 15),
        TextFormField(
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
              labelText: "Senha", border: OutlineInputBorder()),
        ),
        const SizedBox(height: 15),
        TextFormField(
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
              labelText: "Confirmar senha", border: OutlineInputBorder()),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: createButton('Confirmar', () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
                (Route<dynamic> route) => false,
              );
          }),
        ),
      ],
    );
  }
}

Widget createButton(String label, VoidCallback onPressed) {
  return SizedBox(
      height: 65,
      width: double.infinity,
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

Widget switchTheme() {
  return ToggleSwitch(
    minHeight: 65,
    minWidth: double.infinity,
    cornerRadius: 8,
    activeBgColors: const [
      [Color.fromRGBO(20, 28, 95, 1)],
      [Color.fromRGBO(242, 88, 114, 1)]
    ],
    activeFgColor: Colors.white,
    inactiveBgColor: Colors.grey,
    inactiveFgColor: Colors.black,
    initialLabelIndex: 1,
    totalSwitches: 2,
    labels: const ['Azul', 'Rosa'],
    radiusStyle: true,
    onToggle: (index) {},
  );
}

