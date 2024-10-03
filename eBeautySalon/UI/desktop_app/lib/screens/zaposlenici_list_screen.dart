import 'package:desktop_app/screens/zaposlenici_details_screen.dart';
import 'package:desktop_app/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/search_result.dart';
import '../models/zaposlenik.dart';
import '../models/zaposlenik_usluga.dart';
import '../providers/zaposlenici_provider.dart';
import '../providers/zaposlenici_usluge_provider.dart';
import '../utils/util.dart';

class ZaposleniciListScreen extends StatefulWidget {
  const ZaposleniciListScreen({super.key});

  @override
  State<ZaposleniciListScreen> createState() => _ZaposleniciListScreenState();
}

class _ZaposleniciListScreenState extends State<ZaposleniciListScreen> {
  late ZaposleniciUslugeProvider _zaposleniciUslugeProvider;
  late ZaposleniciProvider _zaposleniciProvider;
  bool isLoading = true;
  SearchResult<ZaposlenikUsluga>? result;
  TextEditingController _ftsController = new TextEditingController();

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _zaposleniciUslugeProvider = context.read<ZaposleniciUslugeProvider>();
    _zaposleniciProvider = context.read<ZaposleniciProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: Container(
        child: Column(children: [
          _builSearch(),
          _buildDataListView(),
        ]),
      ),
      title_widget: Text("Zaposlenici i usluge"),
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
                labelText: "Bilo šta",
              ),
              controller: _ftsController,
            ),
          ),
          SizedBox(
            width: 8,
          ),
          ElevatedButton(
              onPressed: () async {
                print("pritisnuto dugme Trazi");

                var data = await _zaposleniciUslugeProvider
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
                    builder: (context) => ZaposleniciDetailsScreen(
                          zaposlenikUsluga: null,
                          zaposlenik: null,
                          usluga: null,
                          korisnik: null,
                        )));
              },
              child: Text("Dodaj zaposlenika i novu uslugu")),
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
              child: Text("Zaposlenik"),
            )),
            DataColumn(
                label: Expanded(
              child: Text("Zadužen za"),
            )),
            DataColumn(
                label: Expanded(
              child: Text("Broj telefona"),
            )),
            DataColumn(
                label: Expanded(
              child: Text("Email"),
            )),
            DataColumn(
                label: Expanded(
              child: Text("Datum zaposlenja"),
            )),
            // DataColumn(
            //     label: Expanded(
            //   child: Text("Slika"),
            // )),
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
                  .map((ZaposlenikUsluga e) => DataRow(cells: [
                        DataCell(Container(
                            width: 150,
                            child: Text(
                                "${e.zaposlenik?.korisnik?.ime} ${e.zaposlenik?.korisnik?.prezime}"))),
                        DataCell(Container(
                            width: 250, child: Text(e.usluga?.naziv ?? ""))),
                        DataCell(Text(e.zaposlenik?.korisnik?.telefon ?? "")),
                        DataCell(Text(e.zaposlenik?.korisnik?.email ?? "")),
                        DataCell(Container(
                            width: 100,
                            child: Text((e.zaposlenik?.datumZaposlenja == null
                                ? "-"
                                : "${e.zaposlenik?.datumZaposlenja?.day}.${e.zaposlenik?.datumZaposlenja?.month}.${e.zaposlenik?.datumZaposlenja?.year}")))),
                        // DataCell(
                        //     e.zaposlenik?.korisnik?.slikaProfila?.slika != null
                        //         ? Container(
                        //             width: 100,
                        //             height: 100,
                        //             child: ImageFromBase64String(e.zaposlenik!
                        //                 .korisnik!.slikaProfila!.slika),
                        //           )
                        //         : Text("")),
                        DataCell(
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.green,
                            ),
                            onPressed: () async {
                              print(
                                  "modifikuj ${e.zaposlenik} zaposlenikId: ${e.zaposlenikId}");

                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ZaposleniciDetailsScreen(
                                        zaposlenikUsluga: e,
                                        zaposlenik: e.zaposlenik,
                                        usluga: e.usluga,
                                        korisnik: e.zaposlenik!.korisnik,
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
    print("delete id: ${e.zaposlenikUslugaId}");
    var deleted =
        await _zaposleniciUslugeProvider.delete(e.zaposlenikUslugaId!);
        //zaposlenik se brise samo ako nema vise usluga za njega - uraditi na backendu
    print('deleted? ${deleted}');

    //treba da se osvjezi lista
    var data = await _zaposleniciUslugeProvider
        .get(filter: {'FTS': _ftsController.text});

    setState(() {
      result = data;
    });
  }
}
