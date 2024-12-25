import 'package:flutter/material.dart';
import 'package:mobile_app/screens/home_page.dart';
import 'package:mobile_app/screens/pretraga_page.dart';

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
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (_currentIndex == 0) {
      Navigator.pushNamed(context, HomePage.routeName);
    } else if (_currentIndex == 1) {
      Navigator.pushNamed(context, PretragaPage.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
            child: widget.title_widget ??
                (widget.title != null ? Text(widget.title!) : Text(""))),
      ),
      body: SafeArea(
        child: widget.child!,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Početna stranica',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Pretraga',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Rezervacije',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
