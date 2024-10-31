import 'package:desktop_app/models/search_result.dart';
import 'package:desktop_app/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/recenzija_usluge.dart';
import '../models/recenzija_usluznika.dart';
import '../providers/recenzija_usluznika_provider.dart';
import '../providers/recenzije_usluga_provider.dart';

class RecenzijeListScreen extends StatefulWidget {
  const RecenzijeListScreen({super.key});

  @override
  State<RecenzijeListScreen> createState() => _RecenzijeListScreenState();
}

class _RecenzijeListScreenState extends State<RecenzijeListScreen> {
  late RecenzijaUslugeProvider _recenzijeUslugeProvider;
  late RecenzijaUsluznikaProvider _recenzijeUsluznikaProvider;
  SearchResult<RecenzijaUsluge>? _recenzijaUslugeResult;
  SearchResult<RecenzijaUsluznika>? _recenzijaUsluznikaResult;
  TextEditingController _ftsController = new TextEditingController();

  //tooltip na komentar ako je veliki
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
                      _buildRecenzijeUslugaListView(),
                    ],
                  ),
                  Column(children: [
                    _getRecenzijeUsluznika(),
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
              controller: _ftsController,
            ),
          ),
          SizedBox(
            width: 8,
          ),
          ElevatedButton(
              onPressed: () async {
                print("pritisnuto dugme trazi rec. usluge");

                var data = await _recenzijeUslugeProvider
                    .get(filter: {'FTS': _ftsController.text});

                print("fts: ${_ftsController.text}");

                setState(() {
                  _recenzijaUslugeResult = data;
                });
              },
              child: Text("Traži")),
          SizedBox(
            width: 8,
          ),
          ElevatedButton(
              onPressed: () {}, child: Text("Izvještaj recenzija usluga")),
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
    var data = await _recenzijeUslugeProvider
        .get(filter: {'FTS': _ftsController.text});

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
              controller: _ftsController,
            ),
          ),
          SizedBox(
            width: 8,
          ),
          ElevatedButton(
              onPressed: () async {
                print("pritisnuto dugme trazi rec. usluznika");

                var data = await _recenzijeUsluznikaProvider
                    .get(filter: {'FTS': _ftsController.text});

                print("fts: ${_ftsController.text}");

                setState(() {
                  _recenzijaUsluznikaResult = data;
                });
              },
              child: Text("Traži")),
          SizedBox(
            width: 8,
          ),
          ElevatedButton(
              onPressed: () {}, child: Text("Izvještaj recenzija uslužnika")),
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
        .get(filter: {'FTS': _ftsController.text});

    setState(() {
      _recenzijaUsluznikaResult = data;
    });
  }
}
