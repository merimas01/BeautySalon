import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:mobile_app/models/search_result.dart';
import 'package:mobile_app/models/zaposlenik.dart';
import 'package:mobile_app/providers/recenzije_usluga_provider.dart';
import 'package:mobile_app/providers/zaposlenici_provider.dart';
import 'package:mobile_app/screens/sve_recenzije_usluge.dart';
import 'package:mobile_app/screens/sve_recenzije_usluznika.dart';
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
      title: "",
      child: _showDetails(),
    );
  }

  _showDetails() {
    return isLoading == false
        ? Container(
            width: 800,
            // child: Card(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(children: [
                  Text(
                    "${widget.usluga?.naziv ?? ""}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontFamily: 'BeckyTahlia',
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
                        fontFamily: 'BeckyTahlia',
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
                      _getTotalReviewsUsluga() != 0
                          ? ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => SveRecenzijeUsluge(
                                          usluga: widget.usluga,
                                        )));
                              },
                              child: Text(
                                "Pogledajte sve recenzije za ovu uslugu",
                                style: TextStyle(fontSize: 16),
                              ))
                          : Container(),
                    ],
                  ),

                  _createTableUsluznci(),
                  //recommender
                ]),
              ),
            )
            //),
            )
        : Center(
            child: CircularProgressIndicator(),
          );
  }

  _findUsluznikeForUsluga() {
    var usluznici = [];

    for (var zaposlenik in _resultZaposlenici!.result) {
      for (var o in listProsjecneOcjeneUsluznika) {
        if (zaposlenik.zaposlenikId == o['usluznikId']) {
          var usluznik = {'usluznik': zaposlenik, 'objekat': o};
          usluznici.add(usluznik);
        }
      }
    }
    return usluznici;
  }

  _createTableUsluznci() {
    return _findUsluznikeForUsluga().length != 0
        ? DataTable(
            columns: [
              DataColumn(
                  label: Expanded(
                child: Text("Usluznik"),
              )),
              DataColumn(
                  label: Expanded(
                child: Text("Prosjek"),
              )),
              DataColumn(
                  label: Expanded(
                child: Text("Recenzije"),
              )),
            ],
            rows: _findUsluznikeForUsluga().map<DataRow>((item) {
              return DataRow(
                cells: [
                  DataCell(Text("${item['objekat']['nazivUsluznik']}")),
                  DataCell(Text(
                      "${item['objekat']['prosjecnaOcjena']} (${item['objekat']['sveOcjene'].length})")),
                  DataCell(
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.pink,
                      ),
                      onPressed: () async {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => UsluznikDetails(
                                usluznik: item['usluznik'],
                                prosjecnaOcjena: item['objekat']
                                        ['prosjecnaOcjena']
                                    .toString(),
                                totalReviws: item['objekat']['sveOcjene']
                                    .length
                                    .toString())));
                      },
                      child: Icon(Icons.comment),
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
}
