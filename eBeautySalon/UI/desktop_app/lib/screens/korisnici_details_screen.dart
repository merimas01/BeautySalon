import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../models/korisnik.dart';
import '../models/search_result.dart';
import '../models/slika_profila.dart';
import '../providers/korisnik_provider.dart';
import '../providers/slika_profila_provider.dart';
import '../widgets/master_screen.dart';

class KorisniciDetailsScreen extends StatefulWidget {
  Korisnik? korisnik;
  KorisniciDetailsScreen({super.key, this.korisnik});

  @override
  State<KorisniciDetailsScreen> createState() => _KorisniciDetailsScreenState();
}

class _KorisniciDetailsScreenState extends State<KorisniciDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};

  late SlikaProfilaProvider _slikaProfilaProvider;
  SearchResult<SlikaProfila>? _slikaProfilaResult;

  bool isLoading = true;
  bool isLoadingImage = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initialValue = {
      'ime': widget.korisnik?.ime,
      'prezime': widget.korisnik?.prezime,
      'korisnickoIme': widget.korisnik?.korisnickoIme,
      'telefon': widget.korisnik?.telefon,
      'email': widget.korisnik?.email,
      'status': widget.korisnik?.status == true ? "Ne" : "Da",
      'slikaProfilaId': widget.korisnik?.slikaProfilaId,
    };

    _slikaProfilaProvider = context.read<SlikaProfilaProvider>();

    initForm();
  }

  Future initForm() async {
    _slikaProfilaResult = await _slikaProfilaProvider.get();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "${widget.korisnik?.ime} ${widget.korisnik?.prezime}",
      child: Column(
        children: [
          isLoading ? Container() : _buildForm(),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return FormBuilder(
        key: _formKey,
        initialValue: _initialValue,
        child: Padding(
          padding: const EdgeInsets.only(
              right: 10.0, top: 10.0, left: 10.0, bottom: 5.0),
          child: Column(
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      Image.memory(
                        displayCurrentImage(),
                        width: null,
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                    ],
                  )
                ],
              ),
              FormBuilderTextField(
                decoration: InputDecoration(labelText: "Ime:"),
                name: "ime",
                enabled: false,
              ),
              FormBuilderTextField(
                name: "prezime",
                enabled: false,
                decoration: InputDecoration(labelText: "Prezime:"),
              ),
              FormBuilderTextField(
                name: "telefon",
                enabled: false,
                decoration: InputDecoration(labelText: "Telefon:"),
              ),
              FormBuilderTextField(
                name: "email",
                enabled: false,
                decoration: InputDecoration(labelText: "Email:"),
              ),
              FormBuilderTextField(
                name: "status",
                enabled: false,
                decoration: InputDecoration(labelText: "Blokiran/a?:"),
              ),
            ],
          ),
        ));
  }

  Uint8List displayCurrentImage() {
    if (widget.korisnik != null) {
      Uint8List imageBytes = base64Decode(widget.korisnik!.slikaProfila!.slika);
      return imageBytes;
    } else {
      Uint8List imageBytes = base64Decode(_slikaProfilaResult!.result[0].slika);
      return imageBytes;
    }
  }
}
