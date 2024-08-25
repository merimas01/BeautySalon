import 'package:flutter/cupertino.dart';

import '../models/usluga.dart';
import '../widgets/master_screen.dart';

class UslugeDetaljiScreen extends StatefulWidget {
  Usluga? usluga;

  UslugeDetaljiScreen({super.key, this.usluga});

  @override
  State<UslugeDetaljiScreen> createState() => _UslugeDetaljiScreenState();
}

class _UslugeDetaljiScreenState extends State<UslugeDetaljiScreen> {
  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: Text("Usluge detalji"),
      title: this.widget.usluga?.naziv ?? "Detalji usluge",
    );
  }
}