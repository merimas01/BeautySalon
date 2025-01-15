import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:mobile_app/models/zaposlenik.dart';
import 'package:mobile_app/widgets/master_screen.dart';

class SveRecenzijeUsluznika extends StatefulWidget {
  Zaposlenik? zaposlenik;
  SveRecenzijeUsluznika({super.key, this.zaposlenik});

  @override
  State<SveRecenzijeUsluznika> createState() => _SveRecenzijeUsluznikaState();
}

class _SveRecenzijeUsluznikaState extends State<SveRecenzijeUsluznika> {
  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(child: Container());

    //prikazati dijalog box ocijeni zaposlenika
        //kao moje rezervacije
  }
}