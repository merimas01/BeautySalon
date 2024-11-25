import 'package:desktop_app/screens/kategorije_list_screen.dart';
import 'package:desktop_app/screens/korisnici_list_screen.dart';
import 'package:desktop_app/screens/novosti_list_screen.dart';
import 'package:desktop_app/screens/profil_page.dart';
import 'package:desktop_app/screens/recenzije_list_screen.dart';
import 'package:desktop_app/screens/usluge_list_screen.dart';
import 'package:desktop_app/screens/usluge_termini_list_screen.dart';
import 'package:desktop_app/screens/zaposlenici_list_screen.dart';
import 'package:flutter/material.dart';

import '../screens/home_page.dart';
import '../screens/rezervacije_list_screen.dart';

class MasterScreenWidget extends StatefulWidget {
  Widget? child;
  String? title;
  Widget? title_widget;
  MasterScreenWidget(
      {required this.child, this.title, this.title_widget, super.key});

  @override
  State<MasterScreenWidget> createState() => _MasterScreenWidgetState();
}

class _MasterScreenWidgetState extends State<MasterScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
              child: widget.title_widget ??
                  (widget.title != null ? Text(widget.title!) : Text(""))),
          Image.asset(
            "assets/images/slika4.png",
            width: 55,
            height: 55,
          ),
          Text(
            "Salon ljepote 'Precious'",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'BeckyTahlia', fontSize: 26, color: Colors.white),
          ),
        ]),
      ),
      drawer: Drawer(
        backgroundColor: Color.fromARGB(255, 255, 206, 223),
        child: ListView(
          children: [
            ListTile(
              title: Icon(Icons.home, color: Colors.black),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const HomePage()));
              },
            ),
            ListTile(
              title: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8, 
                children: [
                  Icon(Icons.category, color: Colors.black),
                  Text(
                    'Kategorije',
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const KategorijeListScreen()));
              },
            ),
            ListTile(
              title: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8, 
                children: [
                  Icon(Icons.face_retouching_natural, color: Colors.black),
                  Text(
                    'Usluge',
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const UslugeListScreen()));
              },
            ),
            ListTile(
              title: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8, 
                children: [
                  Icon(Icons.notes_outlined, color: Colors.black),
                  Text(
                    'Rezervacije',
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const RezervacijeListScreen()));
              },
            ),
            ListTile(
              title: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8, 
                children: [
                  Icon(Icons.calendar_month, color: Colors.black),
                  Text(
                    'Termini',
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const UslugeTerminiListScreen()));
              },
            ),
            ListTile(
              title: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8, 
                children: [
                  Icon(Icons.star, color: Colors.black),
                  Text(
                    'Recenzije',
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const RecenzijeListScreen()));
              },
            ),
            ListTile(
              title: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8, 
                children: [
                  Icon(Icons.people, color: Colors.black),
                  Text(
                    'Korisnici',
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const KorisniciListScreen()));
              },
            ),
            ListTile(
              title: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8, 
                children: [
                  Icon(Icons.work, color: Colors.black),
                  Text(
                    'Zaposlenici',
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ZaposleniciListScreen()));
              },
            ),
            ListTile(
              title: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8, 
                children: [
                  Icon(Icons.screen_search_desktop_rounded, color: Colors.black),
                  Text(
                    'Novosti',
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const NovostiListScreen()));
              },
            ),
            ListTile(
              title: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8, 
                children: [
                  Icon(Icons.person, color: Colors.black),
                  Text(
                    'Profil',
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ProfilPage()));
              },
            ),
          ],
        ),
      ),
      body: widget.child!,
    );
  }
}
