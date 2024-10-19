import 'package:desktop_app/screens/kategorije_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/kategorija.dart';
import '../models/search_result.dart';
import '../providers/kategorije_provider.dart';
import '../widgets/master_screen.dart';

class KategorijeListScreen extends StatefulWidget {
  const KategorijeListScreen({super.key});

  @override
  State<KategorijeListScreen> createState() => _KategorijeListScreenState();
}

class _KategorijeListScreenState extends State<KategorijeListScreen> {
  late KategorijeProvider _kategorijeProvider;
  SearchResult<Kategorija>? result;
  TextEditingController _ftsController = new TextEditingController();

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _kategorijeProvider = context.read<KategorijeProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: Column(children: [
        _builSearch(),
        _buildDataListView(),
      ]),
      title: "Kategorije",
    );
  }

  Widget _builSearch() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                labelText: "Naziv ili opis",
              ),
              controller: _ftsController,
            ),
          ),
          SizedBox(
            width: 8,
          ),
          ElevatedButton(
              onPressed: () async {
                print("pritisnuto dugme Dugme");

                var data = await _kategorijeProvider
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
                    builder: (context) => KategorijeDetailsScreen(
                          kategorija: null,
                        )));
              },
              child: Text("Dodaj kategoriju")),
        ],
      ),
    );
  }

  Widget _buildDataListView() {
    return Expanded(
        child: SingleChildScrollView(
      child: DataTable(
          columns: [
            DataColumn(
                label: Expanded(
              child: Text("Kategorija"),
            )),
            DataColumn(
                label: Expanded(
              child: Text("Opis"),
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
              child: Text(""),
            )),
            DataColumn(
                label: Expanded(
              child: Text(""),
            ))
          ],
          rows: result?.result
                  .map((Kategorija e) => DataRow(cells: [
                        DataCell(Text(e.naziv ?? "")),
                        DataCell(Text(e.opis ?? "")),
                        DataCell(Container(
                            width: 80,
                            child: Text((e.datumKreiranja == null
                                ? "-"
                                : "${e.datumKreiranja?.day}.${e.datumKreiranja?.month}.${e.datumKreiranja?.year}")))),
                        DataCell(Container(
                            width: 80,
                            child: Text((e.datumModifikovanja == null
                                ? "-"
                                : "${e.datumModifikovanja?.day}.${e.datumModifikovanja?.month}.${e.datumModifikovanja?.year}")))),
                        DataCell(TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.green,
                          ),
                          child: Text("Modifikuj"),
                          onPressed: () {
                            print(
                                "modifikacija: ${e.naziv}, id: ${e.kategorijaId}");
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => KategorijeDetailsScreen(
                                      kategorija: e,
                                    )));
                          },
                        )),
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
    print("delete kategorijaId: ${e.kategorijaId}, naziv: ${e.naziv}");
    var deleted = await _kategorijeProvider.delete(e.kategorijaId);
    print('deleted? ${deleted}');

    //treba da se osvjezi lista
    var data =
        await _kategorijeProvider.get(filter: {'FTS': _ftsController.text});

    setState(() {
      result = data;
    });
  }
}
