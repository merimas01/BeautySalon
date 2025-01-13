import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mobile_app/models/zaposlenik.dart';
import 'package:mobile_app/widgets/master_screen.dart';

import '../models/usluga.dart';
import '../utils/constants.dart';
import '../utils/util.dart';

class UsluznikDetails extends StatefulWidget {
  Zaposlenik? usluznik;
  UsluznikDetails({super.key, this.usluznik});

  @override
  State<UsluznikDetails> createState() => _UsluznikDetailsState();
}

class _UsluznikDetailsState extends State<UsluznikDetails> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  List<Usluga>? _postojeceUsluge;
  bool isLoading = true;

//biografija - NOVI ATRIBUT
//prosjecna ocjena usluznika
//dugme koje vodi na stranicu svih recenzija za tog usluznika

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _postojeceUsluge =
        widget.usluznik?.zaposlenikUslugas?.map((e) => e.usluga!).toList();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "",
      child: _buildDetails(),
    );
  }

  Widget _naslov() {
    return Text(
      "Detalji usluznika",
      textAlign: TextAlign.center,
      style: const TextStyle(
          fontFamily: 'BeckyTahlia', fontSize: 26, color: Colors.pinkAccent),
    );
  }

  _Ime() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Ime:"),
      initialValue: widget.usluznik?.korisnik?.ime,
      enabled: false,
    );
  }

  _Prezime() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Prezime:"),
      initialValue: widget.usluznik?.korisnik?.prezime,
      enabled: false,
    );
  }

  _Telefon() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Telefon:"),
      initialValue: widget.usluznik?.korisnik?.telefon,
      enabled: false,
    );
  }

  _Email() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Email:"),
      initialValue: widget.usluznik?.korisnik?.email,
      enabled: false,
    );
  }

  _DatumRodjenja() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Datum rođenja:"),
      initialValue: "${formatDate(widget.usluznik!.datumRodjenja!)}",
      enabled: false,
    );
  }

  _DatumZaposlenja() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Zaposlen od:"),
      initialValue: "${formatDate(widget.usluznik!.datumZaposlenja!)}",
      enabled: false,
    );
  }

  _Slika() {
    return widget.usluznik?.korisnik != null &&
            (widget.usluznik?.korisnik?.slikaProfila != null &&
                widget.usluznik?.korisnik?.slikaProfila?.slika != null) &&
            widget.usluznik?.korisnik?.slikaProfila?.slika != ""
        ? Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle, 
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.memory(
              displayCurrentImage(),
              width: null,
              height: 250,
              fit: BoxFit.cover,
            ),
          )
        : Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle, 
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(
              "assets/images/noImage.jpg",
              height: 250,
              width: null,
              fit: BoxFit.cover,
            ),
          );
  }

  Uint8List displayCurrentImage() {
    Uint8List imageBytes =
        base64Decode(widget.usluznik!.korisnik!.slikaProfila!.slika);
    return imageBytes;
  }

  _Usluge() {
    if (_postojeceUsluge == null) return "";
    var text = _postojeceUsluge!.map((u) => u.naziv).join(", ");

    return TextFormField(
      decoration: InputDecoration(
        labelText: "Usluge:",
        //border: OutlineInputBorder(),
      ),
      initialValue: "${text}",
      enabled: false,
      maxLines: null,
      keyboardType: TextInputType.multiline,
    );
  }

  _buildDetails() {
    return Container(
      width: 800,
      height: 800,
      child: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.all(8.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Container(
                width: 800,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _naslov(),
                          SizedBox(height: 10),
                          _Slika(),
                          SizedBox(height: 10),
                          _Ime(),
                          SizedBox(height: 10),
                          _Prezime(),
                          SizedBox(height: 10),
                          _Telefon(),
                          SizedBox(height: 10),
                          _Email(),
                          SizedBox(height: 10),
                          _DatumRodjenja(),
                          SizedBox(height: 10),
                          _DatumZaposlenja(),
                          SizedBox(height: 10),
                          _Usluge(),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      )),
    );
  }
}
