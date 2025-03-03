import 'dart:convert';
import 'dart:typed_data';
import 'package:desktop_app/screens/korisnici_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '../models/korisnik.dart';
import '../widgets/master_screen.dart';
import 'korisnici_aktivnost_screen.dart';

class KorisniciDetailsScreen extends StatefulWidget {
  Korisnik? korisnik;
  KorisniciDetailsScreen({super.key, this.korisnik});

  @override
  State<KorisniciDetailsScreen> createState() => _KorisniciDetailsScreenState();
}

class _KorisniciDetailsScreenState extends State<KorisniciDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
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

  Widget _aktivnostKorisnika() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        KorisniciAktivnostScreen(korisnik: widget.korisnik)));
              },
              child: Text("Aktivnost korisnika")),
        ],
      ),
    );
  }

  Widget _naslov() {
    var naslov = this.widget.korisnik != null
        ? "Detalji korisnika: ${widget.korisnik?.sifra}"
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
          width: 600,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Color.fromARGB(255, 211, 17, 17)),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => KorisniciListScreen()));
                            },
                            child: Icon(Icons.close)),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    _naslov(),
                    widget.korisnik != null &&
                            widget.korisnik?.slikaProfila != null &&
                            widget.korisnik?.slikaProfila?.slika != null &&
                            widget.korisnik?.slikaProfila?.slika != ""
                        ? Center(
                            child: Image.memory(
                              displayCurrentImage(),
                              width: null,
                              height: 250,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Center(
                            child: displayNoImage(),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _nazadNaKorisnike(),
                        _aktivnostKorisnika(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Image displayNoImage() {
    return Image.asset(
      "assets/images/noImage.jpg",
      height: 250,
      width: null,
      fit: BoxFit.cover,
    );
  }

  Uint8List displayCurrentImage() {
    Uint8List imageBytes = base64Decode(widget.korisnik!.slikaProfila!.slika);
    return imageBytes;
  }
}
