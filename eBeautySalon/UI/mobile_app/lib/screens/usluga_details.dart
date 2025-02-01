import 'package:flutter/material.dart';
import 'package:mobile_app/models/search_result.dart';
import 'package:mobile_app/models/zaposlenik.dart';
import 'package:mobile_app/providers/recenzije_usluga_provider.dart';
import 'package:mobile_app/providers/zaposlenici_provider.dart';
import 'package:mobile_app/screens/pretraga_page.dart';
import 'package:mobile_app/screens/sve_recenzije_usluge.dart';
import 'package:mobile_app/screens/usluznik_details.dart';
import 'package:mobile_app/widgets/master_screen.dart';
import 'package:provider/provider.dart';
import '../models/usluga.dart';
import '../providers/recenzije_usluznika_provider.dart';
import '../utils/util.dart';

class UslugaDetails extends StatefulWidget {
  Usluga? usluga;
  UslugaDetails({super.key, this.usluga});

  @override
  State<UslugaDetails> createState() => _UslugaDetailsState();
}

class _UslugaDetailsState extends State<UslugaDetails> {
  late ZaposleniciProvider _zaposleniciProvider;
  late RecenzijaUslugeProvider _recenzijaUslugeProvider;
  late RecenzijaUsluznikaProvider _recenzijaUsluznikaProvider;
  SearchResult<Zaposlenik>? _resultZaposlenici;
  List<dynamic> listProsjecneOcjeneUsluga = [];
  List<dynamic> listProsjecneOcjeneUsluznika = [];
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _zaposleniciProvider = context.read<ZaposleniciProvider>();
    _recenzijaUslugeProvider = context.read<RecenzijaUslugeProvider>();
    _recenzijaUsluznikaProvider = context.read<RecenzijaUsluznikaProvider>();

    loadData();
  }

  loadData() async {
    var usluge = await _recenzijaUslugeProvider.GetProsjecnaOcjena();
    var usluznici = await _recenzijaUsluznikaProvider.GetProsjecnaOcjena();
    var zaposlenici = await _zaposleniciProvider
        .get(filter: {'uslugaId': widget.usluga?.uslugaId});

    setState(() {
      listProsjecneOcjeneUsluga = usluge;
      listProsjecneOcjeneUsluznika = usluznici;
      _resultZaposlenici = zaposlenici;
    });

    if (usluge.length != 0 && usluznici.length != 0 && zaposlenici != 0) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Detalji usluge",
      child: _showDetails(),
    );
  }

  _showDetails() {
    return isLoading == false
        ? Container(
            width: 800,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(children: [
                  dugmeNazad(),
                  Text(
                    "${widget.usluga?.naziv ?? ""}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        //fontFamily: 'BeckyTahlia',
                        fontSize: 26,
                        color: Colors.pinkAccent),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${widget.usluga?.kategorija?.naziv ?? ""}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        //fontFamily: 'BeckyTahlia',
                        fontSize: 20,
                        color: Colors.pinkAccent),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  widget.usluga?.slikaUsluge != null &&
                          widget.usluga?.slikaUsluge?.slika != null &&
                          widget.usluga?.slikaUsluge?.slika != ""
                      ? Container(
                          height: 200,
                          width: 200,
                          child: ImageFromBase64String(
                              widget.usluga!.slikaUsluge!.slika),
                        )
                      : Container(
                          child: Image.asset(
                            "assets/images/noImage.jpg",
                          ),
                          height: 200,
                          width: 200,
                        ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Cijena:"),
                    initialValue: "${formatNumber(widget.usluga?.cijena)}KM",
                    enabled: false,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Opis"),
                    initialValue: "${widget.usluga?.opis}",
                    enabled: false,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          displayAverageGrade(_getAverageGradeUsluga()),
                          SizedBox(
                            width: 5,
                          ),
                          Text("${_getAverageGradeUsluga()}"),
                          SizedBox(
                            width: 5,
                          ),
                          Text("(${_getTotalReviewsUsluga()})"),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SveRecenzijeUsluge(
                                      usluga: widget.usluga,
                                    )));
                          },
                          child: Text(
                            "Pogledajte sve recenzije za ovu uslugu",
                            style: TextStyle(fontSize: 16),
                          )),
                    ],
                  ),
                  _createTableUsluznci(),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Recommender...",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ]),
              ),
            ))
        : Center(
            child: CircularProgressIndicator(),
          );
  }

  _findUsluznikeForUsluga() {
    var usluznici = [];
    dynamic objProsjecnaOcjenaUsluznika = null;

    for (var zaposlenik in _resultZaposlenici!.result) {
      for (var o in listProsjecneOcjeneUsluznika) {
        if (zaposlenik.zaposlenikId == o['usluznikId']) {
          objProsjecnaOcjenaUsluznika = o;
        }
      }
      var usluznik = {
        'usluznik': zaposlenik,
        'objekat': objProsjecnaOcjenaUsluznika
      };
      usluznici.add(usluznik);
      objProsjecnaOcjenaUsluznika = null;
    }
    return usluznici;
  }

  _createTableUsluznci() {
    return _findUsluznikeForUsluga().length != 0
        ? DataTable(
            columns: [
              DataColumn(
                  label: Expanded(
                child: Text("Uslužnik"),
              )),
              DataColumn(
                  label: Expanded(
                child: Text("Prosječna_ocjena"),
              )),
              DataColumn(
                  label: Expanded(
                child: Text("Detalji"),
              )),
            ],
            rows: _findUsluznikeForUsluga().map<DataRow>((item) {
              return DataRow(
                cells: [
                  DataCell(Text("${item['usluznik'].korisnik?.ime ?? ""}")),
                  DataCell(Text(item['objekat'] != null
                      ? "${item['objekat']['prosjecnaOcjena']} (${item['objekat']['sveOcjene'].length})"
                      : "-")),
                  DataCell(
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.pink,
                      ),
                      onPressed: () async {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => UsluznikDetails(
                                usluga: widget.usluga,
                                usluznik: item['usluznik'],
                                prosjecnaOcjena: item['objekat'] != null
                                    ? item['objekat']['prosjecnaOcjena']
                                        .toString()
                                    : "0",
                                totalReviws: item['objekat'] != null
                                    ? item['objekat']['sveOcjene']
                                        .length
                                        .toString()
                                    : "0")));
                      },
                      child: Icon(Icons.info),
                    ),
                  ),
                ],
              );
            }).toList(),
          )
        : Container();
  }

  _getAverageGradeUsluga() {
    var usluge = listProsjecneOcjeneUsluga
        .where(
          (item) => item['uslugaId'] == widget.usluga?.uslugaId,
        )
        .toList();

    var usluga = usluge.length != 0 ? usluge[0] : null;
    final prosjecnaOcjena = usluga != null ? usluga['prosjecnaOcjena'] : 0;
    return prosjecnaOcjena;
  }

  _getTotalReviewsUsluga() {
    var usluge = listProsjecneOcjeneUsluga
        .where(
          (item) => item['uslugaId'] == widget.usluga?.uslugaId,
        )
        .toList();
    var usluga = usluge.length != 0 ? usluge[0] : null;
    final totalReviws = usluga != null ? usluga['sveOcjene'].length : 0;
    return totalReviws;
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

  dugmeNazad() {
    return Row(
      children: [
        TextButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PretragaPage()));
            },
            child: Icon(Icons.arrow_back)),
      ],
    );
  }
}
