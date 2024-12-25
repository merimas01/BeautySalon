import 'package:flutter/material.dart';
import 'package:mobile_app/widgets/master_screen.dart';

class RezervacijePage extends StatefulWidget {
  static const String routeName = "/reservation";
  const RezervacijePage({super.key});

  @override
  State<RezervacijePage> createState() => _RezervacijePageState();
}

class _RezervacijePageState extends State<RezervacijePage> {
  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(title: "Zakaži termin", child: Container());
  }

}
