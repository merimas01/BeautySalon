import 'package:flutter/material.dart';
import 'package:mobile_app/widgets/master_screen.dart';

class PretragaPage extends StatefulWidget {
  static const String routeName = "/search";
  const PretragaPage({super.key});

  @override
  State<PretragaPage> createState() => _PretragaPageState();
}

class _PretragaPageState extends State<PretragaPage> {
  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(title: "Pretraži usluge", child: Container());
  }
}
