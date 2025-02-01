import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mobile_app/models/zaposlenik.dart';
import 'package:mobile_app/screens/sve_recenzije_usluznika.dart';
import 'package:mobile_app/screens/usluga_details.dart';
import 'package:mobile_app/widgets/master_screen.dart';
import '../models/usluga.dart';
import '../utils/util.dart';

class UsluznikDetails extends StatefulWidget {
  Zaposlenik? usluznik;
  String? prosjecnaOcjena;
  String? totalReviws;
  Usluga? usluga;
  UsluznikDetails(
      {super.key,
      this.usluznik,
      this.prosjecnaOcjena,
      this.totalReviws,
      this.usluga});

  @override
  State<UsluznikDetails> createState() => _UsluznikDetailsState();
}

class _UsluznikDetailsState extends State<UsluznikDetails> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  List<Usluga>? _postojeceUsluge;
  bool isLoading = true;

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
      title: "Detalji uslužnika",
      child: _buildDetails(),
    );
  }

  Widget _naslov() {
    return Text(
      "${widget.usluznik?.korisnik?.ime} ${widget.usluznik?.korisnik?.prezime}",
      textAlign: TextAlign.center,
      style: const TextStyle(
          //fontFamily: 'BeckyTahlia',
          fontSize: 26,
          color: Colors.pinkAccent),
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

  _Biografija() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Biografija:"),
      initialValue: widget.usluznik?.biografija,
      enabled: false,
      maxLines: null,
      keyboardType: TextInputType.multiline,
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

  _ProsjecnaOcjena() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Prosječna ocjena:"),
      initialValue: "${widget.prosjecnaOcjena}",
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

  displayAverageGrade(x) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        // Determine the star type
        if (index < x.floor()) {
          // Full star
          return Icon(
            Icons.star,
            color: Colors.amber,
            size: 20,
          );
        } else if (index < x) {
          // Half star
          return Icon(
            Icons.star_half,
            color: Colors.amber,
            size: 20,
          );
        } else {
          // Empty star
          return Icon(
            Icons.star_border,
            color: Colors.grey,
            size: 20,
          );
        }
      }),
    );
  }

  _buildDetails() {
    return Container(
      width: 800,
      height: 800,
      child: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.all(15.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Container(
                width: 800,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      dugmeNazad(),
                      _naslov(),
                      SizedBox(height: 20),
                      _Slika(),
                      SizedBox(height: 10),
                      _Ime(),
                      SizedBox(height: 10),
                      _Prezime(),
                      SizedBox(
                        height: 10,
                      ),
                      _Biografija(),
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
                      Row(
                        children: [
                          displayAverageGrade(
                              double.parse(widget.prosjecnaOcjena ?? "0")),
                          SizedBox(
                            width: 5,
                          ),
                          Text("${widget.prosjecnaOcjena ?? "0"}"),
                          SizedBox(
                            width: 5,
                          ),
                          Text("(${widget.totalReviws.toString()})"),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SveRecenzijeUsluznika(
                                      zaposlenik: widget.usluznik,
                                      prosjecnaOcjena: widget.prosjecnaOcjena,
                                      totalReviws: widget.totalReviws,
                                      usluga: widget.usluga,
                                    )));
                          },
                          child: Text("Pogledajte sve recenzije za uslužnika"))
                    ],
                  ),
                ),
              ),
      )),
    );
  }

  dugmeNazad() {
    return Row(
      children: [
        TextButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => UslugaDetails(
                        usluga: widget.usluga,
                      )));
            },
            child: Icon(Icons.arrow_back)),
      ],
    );
  }
}
