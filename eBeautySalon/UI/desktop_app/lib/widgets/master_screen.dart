import 'package:desktop_app/main.dart';
import 'package:desktop_app/screens/kategorije_list_screen.dart';
import 'package:desktop_app/screens/korisnici_list_screen.dart';
import 'package:desktop_app/screens/profil_page.dart';
import 'package:desktop_app/screens/usluge_list_screen.dart';
import 'package:flutter/material.dart';

import '../screens/home_page.dart';

class MasterScreenWidget extends StatefulWidget {
  Widget? child;
  String? title;
  Widget? title_widget;
  MasterScreenWidget({this.child, this.title, this.title_widget, super.key});

  @override
  State<MasterScreenWidget> createState() => _MasterScreenWidgetState();
}

class _MasterScreenWidgetState extends State<MasterScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.title_widget ?? Text(widget.title ?? ""),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text("Home page"),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => const HomePage()));
              },
            ),
            ListTile(
              title: Text("Usluge"),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const UslugeListScreen()));
              },
            ),
            ListTile(
              title: Text("Kategorije"),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const KategorijeListScreen()));
              },
            ),
            ListTile(
              title: Text("Korisnici"),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const KorisniciListScreen()));
              },
            ),
             ListTile(
              title: Text("Profil"),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ProfilPage()));
              },
            ),
            ListTile(
              title: Text("Odjava"),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => LoginPage()));
              },
            ),
          ],
        ),
      ),
      body: widget.child!,
    );
  }
}
