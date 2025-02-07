import 'package:flutter/material.dart';
import 'package:mobile_app/screens/home_page.dart';
import 'package:mobile_app/screens/pretraga_page.dart';
import 'package:mobile_app/screens/profil_page.dart';
import 'package:mobile_app/screens/rezervacije_page.dart';

class MasterScreenWidget extends StatefulWidget {
  Widget? child;
  String? title;
  Widget? title_widget;
  int? selectedIndex;
  MasterScreenWidget(
      {required this.child,
      this.title,
      this.title_widget,
      super.key,
      this.selectedIndex});

  @override
  State<MasterScreenWidget> createState() => _MasterScreenWidgetState();
}

class _MasterScreenWidgetState extends State<MasterScreenWidget> {
  int currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
    if (currentIndex == 0) {
      Navigator.pushNamed(context, HomePage.routeName);
    } else if (currentIndex == 1) {
      Navigator.pushNamed(context, PretragaPage.routeName);
    } else if (currentIndex == 2)
      Navigator.pushNamed(context, RezervacijePage.routeName);
    else if (currentIndex == 3)
      Navigator.pushNamed(context, ProfilPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false, //removes back button
          backgroundColor: Colors.pink,
          title: widget.title_widget ??
              (widget.title != null ? Text(widget.title!) : Text(""))),
      body: SafeArea(
        child: widget.child!,
      ),
      bottomNavigationBar: 
          BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: Colors.pink,
            icon: Icon(Icons.home),
            label: 'Početna stranica',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.pink,
            icon: Icon(Icons.search_sharp),
            label: 'Pretraga usluga',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.pink,
            icon: Icon(Icons.calendar_month),
            label: 'Rezervacije',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.pink,
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        selectedItemColor: Colors.blue[200],
        currentIndex:
            widget.selectedIndex != null ? widget.selectedIndex! : currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }

}
