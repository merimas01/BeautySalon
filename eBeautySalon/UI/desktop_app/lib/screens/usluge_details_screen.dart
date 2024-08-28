import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../models/usluga.dart';
import '../widgets/master_screen.dart';

class UslugeDetaljiScreen extends StatefulWidget {
  Usluga? usluga;

  UslugeDetaljiScreen({super.key, this.usluga});

  @override
  State<UslugeDetaljiScreen> createState() => _UslugeDetaljiScreenState();
}

class _UslugeDetaljiScreenState extends State<UslugeDetaljiScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialValue = {
      'uslugaId': widget.usluga?.uslugaId == null
          ? "0"
          : widget.usluga?.uslugaId.toString(),
      'naziv': widget.usluga?.naziv,
      'opis': widget.usluga?.opis,
      'cijena': widget.usluga?.cijena!.toString(), //mora biti toString()
    };
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: _buildForm(),
      title: this.widget.usluga?.naziv ?? "Detalji usluge",
    );
  }

  FormBuilder _buildForm() {
    return FormBuilder(
        key: _formKey,
        initialValue: _initialValue,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                      width: 100,
                      child: FormBuilderTextField(
                        decoration: InputDecoration(labelText: "Usluga ID:"),
                        name: "uslugaId",
                        enabled: false,
                      )),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                      child: FormBuilderTextField(
                    decoration: InputDecoration(labelText: "Naziv:"),
                    name: "naziv",
                  )),
                ],
              ),
              FormBuilderTextField(
                name: "cijena",
                decoration: InputDecoration(labelText: "Cijena:"),
              ),
              FormBuilderTextField(
                name: "opis",
                decoration: InputDecoration(labelText: "Opis:"),
              ),
            ],
          ),
        )
        );
  }
}
