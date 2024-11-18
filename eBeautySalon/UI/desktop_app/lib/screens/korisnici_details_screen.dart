import 'dart:convert';
import 'dart:typed_data';

import 'package:desktop_app/screens/korisnici_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../models/korisnik.dart';
import '../models/search_result.dart';
import '../models/slika_profila.dart';
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
      title: "Korisnici",
        child: Center(
          child: isLoading
              ? Container(child: CircularProgressIndicator())
              : _buildForm(),
        ));
  }

  Widget _nazadNaKorisnike() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 255, 255, 255)),
                foregroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 139, 132, 134)),
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => KorisniciListScreen()));
              },
              child: Text("Nazad na korisnike")),
        ],
      ),
    );
  }

    Widget _naslov() {
    var naslov = this.widget.korisnik != null
        ? "Detalji korisnika: ${widget.korisnik?.ime} ${widget.korisnik?.prezime}"
        : "";
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 244, 201, 215), // Set background color
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
          child: Center(
            child: RichText(
                text: TextSpan(
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.pink,
                    ),
                    children: [
                  TextSpan(
                    text: naslov,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ])),
          ),
        ),
      ),
    );
  }


  Widget _buildForm() {
    return FormBuilder(
        key: _formKey,
        initialValue: _initialValue,
        child: Container(
          width: 500,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _naslov(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                    _nazadNaKorisnike(),
                  ],
                ),
              ),
            ),
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
