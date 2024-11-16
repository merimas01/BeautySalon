import 'package:desktop_app/models/search_result.dart';
import 'package:desktop_app/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/recenzija_usluge.dart';
import '../models/recenzija_usluznika.dart';
import '../models/usluga.dart';
import '../models/zaposlenik.dart';
import '../providers/recenzija_usluznika_provider.dart';
import '../providers/recenzije_usluga_provider.dart';
import '../providers/usluge_provider.dart';
import '../providers/zaposlenici_provider.dart';

class RecenzijeListScreen extends StatefulWidget {
  const RecenzijeListScreen({super.key});

  @override
  State<RecenzijeListScreen> createState() => _RecenzijeListScreenState();
}

class _RecenzijeListScreenState extends State<RecenzijeListScreen> {
  late RecenzijaUslugeProvider _recenzijeUslugeProvider;
  late RecenzijaUsluznikaProvider _recenzijeUsluznikaProvider;
  late UslugeProvider _uslugeProvider;
  late ZaposleniciProvider _zaposleniciProvider;
  SearchResult<RecenzijaUsluge>? _recenzijaUslugeResult;
  SearchResult<RecenzijaUsluznika>? _recenzijaUsluznikaResult;
  SearchResult<Usluga>? _uslugeResult;
  SearchResult<Zaposlenik>? _usluzniciResult;
  TextEditingController _ftsController1 = new TextEditingController();
  TextEditingController _ftsController2 = new TextEditingController();
  bool isLoadingUsluge = true;
  bool isLoadingUsluznici = true;
  Usluga? selectedUsluga;
  Zaposlenik? selectedUsluznik;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _uslugeProvider = context.read<UslugeProvider>();
    _zaposleniciProvider = context.read<ZaposleniciProvider>();
    getUsluge();
    getUsluznici();
  }

  getUsluge() async {
    var usluge = await _uslugeProvider.get();
    setState(() {
      _uslugeResult = usluge;
      isLoadingUsluge = false;
    });
  }

  getUsluznici() async {
    var usluznici = await _zaposleniciProvider.get(filter: {'isUsluznik': true}); 
    setState(() {
      _usluzniciResult = usluznici;
      isLoadingUsluznici = false;
    });
  }

  Widget searchByUsluga() {
    print("search by usluga");
    if (isLoadingUsluge == false) {
      return Container(
        padding: EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey),
        ),
        child: Center(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Usluga>(
              hint: Text("Izaberi uslugu"),
              value: selectedUsluga,
              onChanged: (Usluga? newValue) {
                setState(() {
                  selectedUsluga = newValue;
                  print(selectedUsluga?.naziv);
                });
              },
              items: _uslugeResult?.result
                  .map<DropdownMenuItem<Usluga>>((Usluga service) {
                return DropdownMenuItem<Usluga>(
                  value: service,
                  child: Text(service.naziv!),
                );
              }).toList(),
            ),
          ),
        ),
      );
    }
    return Container();
  }

Widget searchByUsluznik() {
    print("search by usluznik");
    if (isLoadingUsluznici == false) {
      return Container(
        padding: EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey),
        ),
        child: Center(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Zaposlenik>(
              hint: Text("Izaberi uslužnika"),
              value: selectedUsluznik,
              onChanged: (Zaposlenik? newValue) {
                setState(() {
                  selectedUsluznik = newValue;
                  print(selectedUsluznik?.zaposlenikId);
                });
              },
              items: _usluzniciResult?.result
                  .map<DropdownMenuItem<Zaposlenik>>((Zaposlenik service) {
                return DropdownMenuItem<Zaposlenik>(
                  value: service,
                  child: Text("${service.korisnik!.ime!} ${service.korisnik!.prezime!}"), 
                );
              }).toList(),
            ),
          ),
        ),
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                bottom: const TabBar(
                  tabs: [
                    Tab(text: "Recenzije usluga", icon: Icon(Icons.reviews)),
                    Tab(text: "Recenzije uslužnika", icon: Icon(Icons.people)),
                  ],
                ),
                title: const Text('Recenzije'),
              ),
              body: TabBarView(
                children: [
                  Column(
                    children: [
                      _getRecenzijeUsluge(),
                      _showResultUslugeCount(),
                      _buildRecenzijeUslugaListView(),
                    ],
                  ),
                  Column(children: [
                    _getRecenzijeUsluznika(),
                    _showResultUsluzniciCount(),
                    _buildRecenzijeUsluznikaListView()
                  ])
                ],
              ),
            )));
  }

  Widget _getRecenzijeUsluge() {
    _recenzijeUslugeProvider = context.read<RecenzijaUslugeProvider>();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                labelText: "",
              ),
              controller: _ftsController1,
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: searchByUsluga(),
          ),
          SizedBox(width: 8),
          selectedUsluga != null
              ? TextButton(
                  onPressed: () {
                    setState(() {
                      selectedUsluga = null;
                    });
                  },
                  child: Tooltip(
                    child: Text(
                      "X",
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                    message: "Poništi selekciju",
                  ),
                )
              : Container(),
          SizedBox(width: 10),
          ElevatedButton(
              onPressed: () async {
                print("pritisnuto dugme trazi rec. usluge");

                var data = await _recenzijeUslugeProvider.get(filter: {
                  'FTS': _ftsController1.text,
                  'uslugaId': selectedUsluga?.uslugaId
                });
                print(
                    "fts: ${_ftsController1.text}, uslugaId: ${selectedUsluga?.uslugaId}");

                setState(() {
                  _recenzijaUslugeResult = data;
                });
              },
              child: Text("Traži")),
          SizedBox(
            width: 8,
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => HomePage()));
              },
              child: Text("Izvještaj recenzija usluga")),
          SizedBox(
            width: 8,
          ),
        ],
      ),
    );
  }

  Widget _buildRecenzijeUslugaListView() {
    return Expanded(
        child: SingleChildScrollView(
      child: DataTable(
          columns: [
            DataColumn(
                label: Expanded(
              child: Text("Korisnik"),
            )),
            DataColumn(
                label: Expanded(
              child: Text("Usluga"),
            )),
            DataColumn(
                label: Expanded(
              child: Text("Datum kreiranja"),
            )),
            DataColumn(
                label: Expanded(
              child: Text("Datum modifikovanja"),
            )),
            DataColumn(
                label: Expanded(
              child: Text("Ocjena"),
            )),
            DataColumn(
                label: Expanded(
              child: Text("Komentar"),
            )),
            DataColumn(
                label: Expanded(
              child: Text(""),
            ))
          ],
          rows: _recenzijaUslugeResult?.result
                  .map((RecenzijaUsluge e) => DataRow(cells: [
                        DataCell(Container(
                          width: 150,
                          child:
                              Text("${e.korisnik?.ime} ${e.korisnik?.prezime}"),
                        )),
                        DataCell(Container(
                            width: 150, child: Text(e.usluga?.naziv ?? ""))),
                        DataCell(Container(
                            width: 80,
                            child: Text((e.datumKreiranja == null
                                ? "-"
                                : "${e.datumKreiranja?.day}.${e.datumKreiranja?.month}.${e.datumKreiranja?.year}")))),
                        DataCell(Container(
                            width: 80,
                            child: Text((e.datumModificiranja == null
                                ? "-"
                                : "${e.datumModificiranja?.day}.${e.datumModificiranja?.month}.${e.datumModificiranja?.year}")))),
                        DataCell(Text(e.ocjena.toString())),
                        DataCell(Tooltip(
                            message: "${e.komentar ?? ""}",
                            child: Container(
                              width: 200,
                              child: Text(e.komentar ?? ""),
                            ))),
                        DataCell(
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            onPressed: () async {
                              _deleteRecenzijaUsluge(e);
                            },
                            child: Text('Obriši'),
                          ),
                        ),
                      ]))
                  .toList() ??
              []),
    ));
  }

  void _deleteRecenzijaUsluge(e) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text('Potvrda o brisanju zapisa'),
              content: Text('Jeste li sigurni da želite izbrisati ovaj zapis?'),
              actions: <Widget>[
                TextButton(
                  child: Text('Ne'),
                  onPressed: () {
                    Navigator.of(context).pop(); //zatvori dijalog
                  },
                ),
                TextButton(
                  child: Text('Da'),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  onPressed: () async {
                    Navigator.of(context).pop(); //zatvori dijalog
                    _obrisiRecenzijaUsluge(e);
                  },
                ),
              ],
            ));
  }

  void _obrisiRecenzijaUsluge(e) async {
    print("delete recenzija usluge id: ${e.recenzijaUslugeId}");
    var deleted = await _recenzijeUslugeProvider.delete(e.recenzijaUslugeId);
    print('deleted? ${deleted}');

    //treba da se osvjezi lista
    var data = await _recenzijeUslugeProvider.get(filter: {
      'FTS': _ftsController1.text,
      'uslugaId': selectedUsluga?.uslugaId
    });

    setState(() {
      _recenzijaUslugeResult = data;
    });
  }

  Widget _getRecenzijeUsluznika() {
    _recenzijeUsluznikaProvider = context.read<RecenzijaUsluznikaProvider>();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                labelText: "",
              ),
              controller: _ftsController2,
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: searchByUsluznik(),
          ),
          SizedBox(width: 8),
          selectedUsluznik != null
              ? TextButton(
                  onPressed: () {
                    setState(() {
                      selectedUsluznik = null;
                    });
                  },
                  child: Tooltip(
                    child: Text(
                      "X",
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                    message: "Poništi selekciju",
                  ),
                )
              : Container(),
          SizedBox(width: 10),
          ElevatedButton(
              onPressed: () async {
                print("pritisnuto dugme trazi rec. usluznika");

                var data = await _recenzijeUsluznikaProvider
                    .get(filter: {'FTS': _ftsController2.text, 'usluznikId': selectedUsluznik?.zaposlenikId});

                print("fts: ${_ftsController2.text}");

                setState(() {
                  _recenzijaUsluznikaResult = data;
                });
              },
              child: Text("Traži")),
          SizedBox(
            width: 8,
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => HomePage()));
              },
              child: Text("Izvještaj recenzija uslužnika")),
          SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildRecenzijeUsluznikaListView() {
    return Expanded(
        child: SingleChildScrollView(
      child: DataTable(
          columns: [
            DataColumn(
                label: Expanded(
              child: Text("Korisnik"),
            )),
            DataColumn(
                label: Expanded(
              child: Text("Uslužnik"),
            )),
            DataColumn(
                label: Expanded(
              child: Text("Datum kreiranja"),
            )),
            DataColumn(
                label: Expanded(
              child: Text("Datum modifikovanja"),
            )),
            DataColumn(
                label: Expanded(
              child: Text("Ocjena"),
            )),
            DataColumn(
                label: Expanded(
              child: Text("Komentar"),
            )),
            DataColumn(
                label: Expanded(
              child: Text(""),
            ))
          ],
          rows: _recenzijaUsluznikaResult?.result
                  .map((RecenzijaUsluznika e) => DataRow(cells: [
                        DataCell(Container(
                          width: 150,
                          child:
                              Text("${e.korisnik?.ime} ${e.korisnik?.prezime}"),
                        )),
                        DataCell(Container(
                            width: 150,
                            child: Text(
                                "${e.usluznik?.korisnik?.ime} ${e.usluznik?.korisnik?.prezime}"))),
                        DataCell(Container(
                            width: 80,
                            child: Text((e.datumKreiranja == null
                                ? "-"
                                : "${e.datumKreiranja?.day}.${e.datumKreiranja?.month}.${e.datumKreiranja?.year}")))),
                        DataCell(Container(
                            width: 80,
                            child: Text((e.datumModificiranja == null
                                ? "-"
                                : "${e.datumModificiranja?.day}.${e.datumModificiranja?.month}.${e.datumModificiranja?.year}")))),
                        DataCell(Text(e.ocjena.toString())),
                        DataCell(Tooltip(
                            message: "${e.komentar ?? ""}",
                            child: Container(
                              width: 200,
                              child: Text(e.komentar ?? ""),
                            ))),
                        DataCell(
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            onPressed: () async {
                              _deleteRecenzijaUsluge(e);
                            },
                            child: Text('Obriši'),
                          ),
                        ),
                      ]))
                  .toList() ??
              []),
    ));
  }

  void _deleteRecenzijaUsluznika(e) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text('Potvrda o brisanju zapisa'),
              content: Text('Jeste li sigurni da želite izbrisati ovaj zapis?'),
              actions: <Widget>[
                TextButton(
                  child: Text('Ne'),
                  onPressed: () {
                    Navigator.of(context).pop(); //zatvori dijalog
                  },
                ),
                TextButton(
                  child: Text('Da'),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  onPressed: () async {
                    Navigator.of(context).pop(); //zatvori dijalog
                    _obrisiRecenzijaUsluznika(e);
                  },
                ),
              ],
            ));
  }

  void _obrisiRecenzijaUsluznika(e) async {
    print("delete recenzija usluznika id: ${e.recenzijaUsluznikaId}");
    var deleted = await _recenzijeUslugeProvider.delete(e.recenzijaUsluznikaId);
    print('deleted? ${deleted}');

    //treba da se osvjezi lista
    var data = await _recenzijeUsluznikaProvider
        .get(filter: {'FTS': _ftsController2.text, 'usluznikId': selectedUsluznik?.zaposlenikId});

    setState(() {
      _recenzijaUsluznikaResult = data;
    });
  }

  Widget _showResultUslugeCount() {
    return RichText(
        text: TextSpan(
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
            children: [
          TextSpan(
            text:
                'Broj rezultata: ${_recenzijaUslugeResult?.count == null ? 0 : _recenzijaUslugeResult?.count}',
            style: TextStyle(fontWeight: FontWeight.normal),
          )
        ]));
  }

  Widget _showResultUsluzniciCount() {
    return RichText(
        text: TextSpan(
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
            children: [
          TextSpan(
            text:
                'Broj rezultata: ${_recenzijaUsluznikaResult?.count == null ? 0 : _recenzijaUsluznikaResult?.count}',
            style: TextStyle(fontWeight: FontWeight.normal),
          )
        ]));
  }
}
