import 'package:desktop_app/providers/usluge_provider.dart';
import 'package:desktop_app/utils/util.dart';
import 'package:provider/provider.dart';

import './screens/usluge_list_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => UslugeProvider())],
    child: const MyMaterialApp(),
  ));
}

class MyMaterialApp extends StatelessWidget {
  const MyMaterialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neki naslov',
      theme: ThemeData(primarySwatch: Colors.pink),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  TextEditingController _korisnickoImeController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  late UslugeProvider _uslugeProvider;

  @override
  Widget build(BuildContext context) {
    _uslugeProvider = context.read<UslugeProvider>();

    return Scaffold(
        appBar: AppBar(
          title: Text("Prijava"),
        ),
        body: Center(
          child: Container(
              constraints: BoxConstraints(maxWidth: 400, maxHeight: 500),
              child: Card(
                  child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Image.asset(
                      "assets/images/slika4.png",
                      height: 170,
                      width: 170,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Salon Ljepote 'Grace'",
                      style: TextStyle(fontFamily: 'Playwrite Argentina'),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text("Prijavite se putem sljedeće forme:"),
                    SizedBox(
                      height: 8,
                    ),
                    TextField(
                      decoration: InputDecoration(
                          labelText: "Korisničko ime",
                          prefixIcon: Icon(Icons.email)),
                      controller: _korisnickoImeController,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextField(
                      decoration: InputDecoration(
                          labelText: "Lozinka",
                          prefixIcon: Icon(Icons.password)),
                      controller: _passwordController,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          print("pritisnuto dugme");

                          var korisnickoIme = _korisnickoImeController.text;
                          var password = _passwordController.text;

                          print(" $korisnickoIme $password");

                          Authorization.username = korisnickoIme;
                          Authorization.password = password;

                          try {
                            await _uslugeProvider.get();

                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    const UslugeListScreen()));
                          } on Exception catch (e) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                      title: Text("Error"),
                                      content: Text(e.toString()),
                                      actions: [
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text("Ok"))
                                      ],
                                    ));
                          }
                        },
                        child: Text("Prijavi se"))
                  ],
                ),
              ))),
        ));
  }
}
