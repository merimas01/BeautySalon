import 'package:desktop_app/screens/kategorije_details_screen.dart';
import 'package:flutter/cupertino.dart';
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
              child: Text("ID"),
            )),
            DataColumn(
                label: Expanded(
              child: Text("Naziv"),
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
                label: SizedBox(
              width: 100,
              child: Text("Datum modifikovanja"),
            )),
          ],
          rows: result?.result
                  .map((Kategorija e) => DataRow(
                          onSelectChanged: (selected) => {
                                if (selected == true)
                                  {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                KategorijeDetailsScreen(
                                                  kategorija: e,
                                                )))
                                  }
                              },
                          cells: [
                            DataCell(Text(e.kategorijaId?.toString() ?? "")),
                            DataCell(Text(e.naziv ?? "")),
                            DataCell(Text(e.opis ?? "")),
                            DataCell(Text((e.datumKreiranja == null
                                ? "-"
                                : "${e.datumKreiranja?.day}.${e.datumKreiranja?.month}.${e.datumKreiranja?.year}"))),
                            DataCell(Text((e.datumModifikovanja == null
                                ? "-"
                                : "${e.datumModifikovanja?.day}.${e.datumModifikovanja?.month}.${e.datumModifikovanja?.year}"))),
                          ]))
                  .toList() ??
              []),
    ));
  }
}
