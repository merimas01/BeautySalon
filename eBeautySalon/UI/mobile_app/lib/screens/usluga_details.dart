import 'package:flutter/material.dart';
import 'package:mobile_app/models/favoriti_usluge_insert.dart';
import 'package:mobile_app/models/search_result.dart';
import 'package:mobile_app/models/zaposlenik.dart';
import 'package:mobile_app/providers/favoriti_usluge_provider.dart';
import 'package:mobile_app/providers/recenzije_usluga_provider.dart';
import 'package:mobile_app/providers/usluge_provider.dart';
import 'package:mobile_app/providers/zaposlenici_provider.dart';
import 'package:mobile_app/screens/moji_favoriti.dart';
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
  int? poslaniKorisnikId;
  UslugaDetails({super.key, this.usluga, this.poslaniKorisnikId});

  @override
  State<UslugaDetails> createState() => _UslugaDetailsState();
}

class _UslugaDetailsState extends State<UslugaDetails> {
  late ZaposleniciProvider _zaposleniciProvider;
  late RecenzijaUslugeProvider _recenzijaUslugeProvider;
  late RecenzijaUsluznikaProvider _recenzijaUsluznikaProvider;
  late FavoritiUslugeProvider _favoritiUslugeProvider;
  late UslugeProvider _uslugeProvider;
  SearchResult<Zaposlenik>? _resultZaposlenici;
  List<Usluga> recommendLista = [];
  List<dynamic> listProsjecneOcjeneUsluga = [];
  List<dynamic> listProsjecneOcjeneUsluznika = [];
  bool isLoading = true;
  bool isFavorit = false;
  bool? obrisan;
  int new_favoritId = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _zaposleniciProvider = context.read<ZaposleniciProvider>();
    _recenzijaUslugeProvider = context.read<RecenzijaUslugeProvider>();
    _recenzijaUsluznikaProvider = context.read<RecenzijaUsluznikaProvider>();
    _uslugeProvider = context.read<UslugeProvider>();
    _favoritiUslugeProvider = context.read<FavoritiUslugeProvider>();

    loadData();

    var fav = widget.usluga?.favoritiUsluges?.any((obj) =>
            obj.korisnikId == LoggedUser.id &&
            obj.uslugaId == widget.usluga?.uslugaId) ==
        true;
    setState(() {
      isFavorit = fav;
      obrisan = fav == true ? false : true;
    });
  }

  loadData() async {
    var usluge = await _recenzijaUslugeProvider.GetProsjecnaOcjena();
    var usluznici = await _recenzijaUsluznikaProvider.GetProsjecnaOcjena();
    var zaposlenici = await _zaposleniciProvider
        .get(filter: {'uslugaId': widget.usluga?.uslugaId});
    var recommend =
        await _uslugeProvider.Recommend(widget.usluga!.uslugaId, LoggedUser.id);

    setState(() {
      listProsjecneOcjeneUsluga = usluge;
      listProsjecneOcjeneUsluznika = usluznici;
      _resultZaposlenici = zaposlenici;
      recommendLista = recommend;
    });

    print("recommend: ${recommendLista.length}");
    if (usluge.length != 0 && usluznici.length != 0 && zaposlenici != 0) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      selectedIndex: widget.poslaniKorisnikId != null ? 3 : 1,
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
                  Stack(
                    children: [
                      widget.usluga?.slikaUsluge != null &&
                              widget.usluga?.slikaUsluge?.slika != null &&
                              widget.usluga?.slikaUsluge?.slika != ""
                          ? imageContainer(
                              widget.usluga!.slikaUsluge!.slika, 300, 500)
                          : noImageContainer(300, 500),
                      Positioned(
                          top: 10, // Adjust position from the top
                          right: 10,
                          child: addToFavorites())
                    ],
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
                    ],
                  ),
                  _createTableUsluznci(),
                  SizedBox(
                    height: 20,
                  ),
                  recommendLista.length != 0
                      ? Text(
                          "Predlažemo Vam da pogledate sljedeće usluge:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      : Text("Za sada nema predloženih usluga 😞",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 10,
                  ),
                  recommendLista.length != 0
                      ? getRecommendedUsluge(recommendLista)
                      : SizedBox.shrink(),
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
                      : "0")),
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
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SveRecenzijeUsluge(
                  usluga: widget.usluga,
                  prosjecnaOcjena: _getAverageGradeUsluga().toString(),
                  totalReviws: _getTotalReviewsUsluga().toString(),
                )));
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
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

  dugmeNazad() {
    return Row(
      children: [
        TextButton(
            onPressed: () {
              if (widget.poslaniKorisnikId != null) {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => MojiFavoriti()));
              } else {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => PretragaPage()));
              }
            },
            child: Icon(Icons.arrow_back)),
      ],
    );
  }

  getRecommendedUsluge(data) {
    return data.length != 0
        ? Container(
            height: 200,
            child: GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 4 / 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 20),
              scrollDirection: Axis.horizontal,
              children: _buildUslugaList(data),
            ),
          )
        : Container(
            child: Text("Nema rezultata za trazenu uslugu."),
          );
  }

  List<Widget> _buildUslugaList(data) {
    if (data.length == 0) {
      return [Text("nema nijedna preporucena usluga.")];
    }

    List<Widget> list = data
        .map((x) => Container(
              key: ValueKey(x.uslugaId),
              child: Column(
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => UslugaDetails(
                                  usluga: x,
                                )));
                      },
                      child: Stack(
                        children: [
                          x.slikaUsluge != null &&
                                  x.slikaUsluge?.slika != null &&
                                  x.slikaUsluge?.slika != ""
                              ? imageContainer(x.slikaUsluge!.slika, 130, 300)
                              : noImageContainer(130, 300),
                          Positioned(
                            top: 10, // Adjust position from the top
                            right: 20, // Adjust position from the right
                            child: x.favoritiUsluges.any((obj) =>
                                        obj.korisnikId == LoggedUser.id &&
                                        obj.uslugaId == x.uslugaId) ==
                                    true
                                ? Icon(
                                    Icons.favorite,
                                    color: Colors.pink,
                                  )
                                : Icon(
                                    Icons.favorite,
                                    color: Colors.grey,
                                  ),
                          ),
                        ],
                      )),
                  Text(
                    x.naziv.split(' ').take(3).join(' ') ?? "",
                    textAlign: TextAlign.center,
                  ),
                  Text("${formatNumber(x?.cijena)}KM"),
                ],
              ),
            ))
        .cast<Widget>()
        .toList();

    return list;
  }

  addToFavorites() {
    return TextButton(
        onPressed: () async {
          if (isFavorit == true) {
            try {
              if (obrisan == false) {
                var favoritId = 0;
                if (widget.usluga?.favoritiUsluges?.length != 0) {
                  favoritId = widget.usluga?.favoritiUsluges
                          ?.firstWhere((element) =>
                              element.korisnikId == LoggedUser.id &&
                              element.uslugaId == widget.usluga!.uslugaId)
                          .favoritId ??
                      0;
                } else
                  favoritId = new_favoritId;

                var obj = await _favoritiUslugeProvider.delete(favoritId);

                var usluga =
                    await _uslugeProvider.getById(widget.usluga!.uslugaId!);
                setState(() {
                  isFavorit = false;
                  this.widget.usluga = usluga;
                  obrisan = true;
                });
              }
            } catch (err) {
              print(err);
            }
          } else {
            try {
              var request_insert =
                  FavoritiUslugeInsert(LoggedUser.id, widget.usluga!.uslugaId!);

              var obj = await _favoritiUslugeProvider.insert(request_insert);

              var usluga =
                  await _uslugeProvider.getById(widget.usluga!.uslugaId!);

              setState(() {
                isFavorit = true;
                this.widget.usluga = usluga;
                obrisan = false;
                new_favoritId = obj.favoritId!;
              });
            } catch (err) {
              print(err);
            }
          }
        },
        child: isFavorit == true
            ? Icon(
                Icons.favorite,
                color: Colors.pink,
              )
            : Icon(
                Icons.favorite,
                color: Colors.grey,
              ));
  }
}
