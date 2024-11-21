import 'package:desktop_app/screens/zaposlenici_details_screen.dart';
import 'package:desktop_app/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/korisnik_uloga.dart';
import '../models/search_result.dart';
import '../models/zaposlenik.dart';
import '../models/zaposlenik_usluga.dart';
import '../providers/zaposlenici_provider.dart';
import '../utils/util.dart';

class ZaposleniciListScreen extends StatefulWidget {
  const ZaposleniciListScreen({super.key});

  @override
  State<ZaposleniciListScreen> createState() => _ZaposleniciListScreenState();
}

class _ZaposleniciListScreenState extends State<ZaposleniciListScreen> {
  late ZaposleniciProvider _zaposleniciProvider;
  bool isLoadingData = true;
  SearchResult<Zaposlenik>? result;
  TextEditingController _ftsController = new TextEditingController();

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _zaposleniciProvider = context.read<ZaposleniciProvider>();
    getData();
  }

  void getData() async {
    var data = await _zaposleniciProvider.get(filter: {'FTS': ''});

    setState(() {
      result = data;
      isLoadingData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: Container(
        child: Column(children: [
          _builSearch(),
          _showResultCount(),
          isLoadingData == false
              ? _buildDataListView()
              : Container(child: CircularProgressIndicator()),
        ]),
      ),
      title_widget: Text("Zaposlenici"),
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
                labelText: "ime/prezime",
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

                var data = await _zaposleniciProvider
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
                          zaposlenik: null,
                          korisnik: null,
                        )));
              },
              child: Text("Registruj novog zaposlenika")),
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
              child: Text("Slika"),
            )),
            DataColumn(
                label: Expanded(
              child: Text("Zadužen za"),
            )),
            DataColumn(
                label: Expanded(
              child: Text("Uloga"),
            )),
            DataColumn(
                label: Expanded(
              child: Text("Email"),
            )),
            DataColumn(
                label: Expanded(
              child: Text("Datum zaposlenja"),
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
                  .map((Zaposlenik e) => DataRow(cells: [
                        DataCell(Container(
                            width: 100,
                            child: Text(
                                "${e.korisnik?.ime} ${e.korisnik?.prezime}"))),
                        DataCell(e.korisnik?.slikaProfila?.slika != null
                            ? Container(
                                width: 100,
                                height: 100,
                                child: ImageFromBase64String(
                                    e.korisnik!.slikaProfila!.slika),
                              )
                            : Text("")),
                        DataCell(Container(
                            width: 300,
                            child: _zaduzenZa(e.zaposlenikUslugas,
                                e.korisnik?.korisnikUlogas))),
                        DataCell(Container(
                            width: 100,
                            child: Text(
                                joinUlogaNaziv(e.korisnik?.korisnikUlogas)))),
                        DataCell(Text(e.korisnik?.email ?? "")),
                        DataCell(Container(
                            width: 100,
                            child: Text((e.datumZaposlenja == null
                                ? "-"
                                : "${e.datumZaposlenja?.day}.${e.datumZaposlenja?.month}.${e.datumZaposlenja?.year}")))),
                        DataCell(
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.green,
                            ),
                            onPressed: () async {
                              print(
                                  "modifikuj ${e} zaposlenikId: ${e.zaposlenikId} korisnikId ${e.korisnik?.korisnikId}");

                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      ZaposleniciDetailsScreen(
                                        zaposlenik: e,
                                        korisnik: e.korisnik!,
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
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Da'),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    _obrisiZapis(e);
                  },
                ),
              ],
            ));
  }

  void _obrisiZapis(e) async {
    print("delete id: ${e.zaposlenikId}");
    var deleted = await _zaposleniciProvider.delete(e.zaposlenikId!);
    print('deleted? ${deleted}');

    //treba da se osvjezi lista
    var data =
        await _zaposleniciProvider.get(filter: {'FTS': _ftsController.text});

    setState(() {
      result = data;
    });
  }

  String joinUslugaNaziv(List<ZaposlenikUsluga>? list) {
    if (list == null) return "";
    return list
        .map((z) => z.usluga?.naziv)
        .where((naziv) => naziv != null)
        .join(", ");
  }

  String joinUlogaNaziv(List<KorisnikUloga>? list) {
    if (list == null) return "";
    return list
        .map((z) => z.uloga?.naziv)
        .where((naziv) => naziv != null)
        .join(", ");
  }

  Widget _zaduzenZa(List<ZaposlenikUsluga>? zaposlenik_usluge,
      List<KorisnikUloga>? korisnik_uloge) {
    var x = zaposlenik_usluge?.length != 0;
    if (x == true) {
      return Text(joinUslugaNaziv(zaposlenik_usluge));
    } else {
      var z = korisnik_uloge?.length != 0
          ? korisnik_uloge?.map((z) => z.uloga?.opis).toList()[0]
          : "";
      return Text(z!);
    }
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
