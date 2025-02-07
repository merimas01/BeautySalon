import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mobile_app/models/zaposlenik.dart';
import 'package:mobile_app/screens/sve_recenzije_usluznika.dart';
import 'package:mobile_app/screens/usluga_details.dart';
import 'package:mobile_app/widgets/master_screen.dart';
import 'package:provider/provider.dart';
import '../models/usluga.dart';
import '../providers/recenzije_usluznika_provider.dart';
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
  late RecenzijaUsluznikaProvider _recenzijaUsluznikaProvider;
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  List<Usluga>? _postojeceUsluge;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _recenzijaUsluznikaProvider = context.read<RecenzijaUsluznikaProvider>();

    _postojeceUsluge =
        widget.usluznik?.zaposlenikUslugas?.map((e) => e.usluga!).toList();

    setState(() {
      isLoading = false;
    });

    getProsjecnaOcjenaITotalReviews();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      selectedIndex: 1,
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
      initialValue: prosjecnaOcjena == ""
          ? "${widget.prosjecnaOcjena}"
          : "${prosjecnaOcjena}",
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
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SveRecenzijeUsluznika(
                  zaposlenik: widget.usluznik,
                  prosjecnaOcjena: widget.prosjecnaOcjena,
                  totalReviws: widget.totalReviws,
                  usluga: widget.usluga,
                )));
      },
      child: Row(
        children: List.generate(5, (index) {
          // Determine the star type
          if (index < x.floor()) {
            // Full star
            return Icon(
              Icons.star,
              color: Colors.amber,
              size: 30,
            );
          } else if (index < x) {
            // Half star
            return Icon(
              Icons.star_half,
              color: Colors.amber,
              size: 30,
            );
          } else {
            // Empty star
            return Icon(
              Icons.star_border,
              color: Colors.grey,
              size: 30,
            );
          }
        }),
      ),
    );
  }

  List<dynamic> listProsjecneOcjeneUsluznika = [];
  String prosjecnaOcjena = "0";
  String totalReviws = "0";
  bool isLoadingProsjecnaOcjena = true;

  getProsjecnaOcjenaITotalReviews() async {
    var usluznici = await _recenzijaUsluznikaProvider.GetProsjecnaOcjena();
    setState(() {
      listProsjecneOcjeneUsluznika = usluznici;
    });
    if (listProsjecneOcjeneUsluznika.length != 0) {
      for (var o in listProsjecneOcjeneUsluznika) {
        if (widget.usluznik?.zaposlenikId == o['usluznikId']) {
          setState(() {
            prosjecnaOcjena = o['prosjecnaOcjena'].toString();
            totalReviws = o['sveOcjene'].length.toString();
          });
        }
      }
    } else {
      setState(() {
        prosjecnaOcjena = widget.prosjecnaOcjena.toString();
        totalReviws = widget.totalReviws.toString();
      });
    }

    print("${prosjecnaOcjena} ${totalReviws}");
    setState(() {
      isLoadingProsjecnaOcjena = false;
    });
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
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          prosjecnaOcjena != ""
                              ? displayAverageGrade(
                                  double.parse(prosjecnaOcjena))
                              : displayAverageGrade(
                                  double.parse(widget.prosjecnaOcjena ?? "0")),
                          SizedBox(
                            width: 5,
                          ),
                          prosjecnaOcjena != ""
                              ? Text(prosjecnaOcjena)
                              : Text("${widget.prosjecnaOcjena ?? "0"}"),
                          SizedBox(
                            width: 5,
                          ),
                          totalReviws != ""
                              ? Text("(${totalReviws})")
                              : Text("(${widget.totalReviws.toString()})"),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
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
