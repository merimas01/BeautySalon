import 'package:desktop_app/models/novost.dart';
import 'package:desktop_app/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/search_result.dart';
import '../providers/novosti_provider.dart';
import '../utils/util.dart';
import 'novosti_details_screen.dart';

class NovostiListScreen extends StatefulWidget {
  const NovostiListScreen({super.key});

  @override
  State<NovostiListScreen> createState() => _NovostiListScreenState();
}

class _NovostiListScreenState extends State<NovostiListScreen> {
  late NovostiProvider _novostiProvider;
  SearchResult<Novost>? result;
  TextEditingController _ftsController = new TextEditingController();
  bool isLoadingData = true;
  String? search="";

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _novostiProvider = context.read<NovostiProvider>();
    getData();
  }

  void getData() async {
    var data = await _novostiProvider.get(filter: {'FTS': ''});

    // Add a listener to get the value whenever the text changes
    _ftsController.addListener(() {
      String currentText = _ftsController.text; // Access the current text
      setState(() {
        search = currentText;
      });
      print('Current Text: $currentText');
    });

    setState(() {
      result = data;
      isLoadingData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Novosti",
      child: Column(
        children: [
          _buildSearch(),
          _showResultCount(),
          isLoadingData == false
              ? _buildDataListView()
              : Container(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                labelText: "Bilo šta",
              ),
              controller: _ftsController,
            ),
          ),
          SizedBox(
            width: 8,
          ),
          search != ""
              ? TextButton(
                  onPressed: () {
                    setState(() {
                      _ftsController.text = '';
                      search = _ftsController.text;
                    });
                  },
                  child: Tooltip(
                    child: Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
                    message: "Izbriši tekst",
                  ),
                )
              : Container(),
          ElevatedButton(
              onPressed: () async {
                print("pritisnuto dugme Trazi");

                var data = await _novostiProvider
                    .get(filter: {'FTS': _ftsController.text});

                print("fts: ${_ftsController.text}");

                setState(() {
                  result = data;
                });
              },
              child: Text("Traži")),
          SizedBox(
            width: 8,
          ),
          ElevatedButton(
              onPressed: () async {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NovostiDetailsScreen(
                          novost: null,
                        )));
              },
              child: Text("Dodaj novost")),
        ],
      ),
    );
  }

  Expanded _buildDataListView() {
    return Expanded(
        child: SingleChildScrollView(
      child: DataTable(
          columns: [
            DataColumn(
                label: Expanded(
              child: Text("Naslov"),
            )),
            DataColumn(
                label: Expanded(
              child: Text("Slika"),
            )),
            DataColumn(
                label: Expanded(
              child: Text("Sadržaj"),
            )),
            DataColumn(
                label: Expanded(
              child: Text("Datum izmjene"),
            )),
            DataColumn(
                label: Expanded(
              child: Text("Autor"),
            )),
            DataColumn(
                label: Expanded(
              child: Text(""),
            )),
            DataColumn(
                label: Expanded(
              child: Text(""),
            )),
          ],
          rows: result?.result
                  .map((Novost e) => DataRow(cells: [
                        DataCell(
                            Container(width: 200, child: Text(e.naslov ?? ""))),
                        DataCell(e.slikaNovost?.slika != null
                            ? Container(
                                width: 100,
                                height: 100,
                                child:
                                    ImageFromBase64String(e.slikaNovost!.slika),
                              )
                            : Text("")),
                        DataCell(Container(
                          width: 260,
                          child: Text(e.sadrzaj ?? ""),
                        )),
                        DataCell(Container(
                            child: e.datumModificiranja == null
                                ? Text(
                                    "${e.datumKreiranja?.day}.${e.datumKreiranja?.month}.${e.datumKreiranja?.year}")
                                : Text(
                                    "${e.datumModificiranja?.day}.${e.datumModificiranja?.month}.${e.datumModificiranja?.year}"))),
                        DataCell(Container(
                          child:
                              Text("${e.korisnik?.ime} ${e.korisnik?.prezime}"),
                        )),
                        DataCell(
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.green,
                            ),
                            onPressed: () async {
                              print(
                                  "modifikuj ${e.naslov} novostId: ${e.novostId}");

                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => NovostiDetailsScreen(
                                        novost: e,
                                      )));
                            },
                            child: Text('Modifikuj'),
                          ),
                        ),
                        DataCell(
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            onPressed: () async {
                              _deleteConfirmationDialog(e);
                            },
                            child: Text('Obriši'),
                          ),
                        ),
                      ]))
                  .toList() ??
              []),
    ));
  }

  void _deleteConfirmationDialog(e) {
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
                    _obrisiZapis(e);
                  },
                ),
              ],
            ));
  }

  void _obrisiZapis(e) async {
    print("delete novostId: ${e.novostId}, naslov: ${e.naslov}");
    var deleted = await _novostiProvider.delete(e.novostId!);
    print('deleted? ${deleted}');

    //treba da se osvjezi lista
    var data = await _novostiProvider.get(filter: {'FTS': _ftsController.text});

    setState(() {
      result = data;
    });
  }

  Widget _showResultCount() {
    return RichText(
        text: TextSpan(
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
            children: [
          TextSpan(
            text:
                'Broj rezultata: ${result?.count == null ? 0 : result?.count}',
            style: TextStyle(fontWeight: FontWeight.normal),
          )
        ]));
  }
}
