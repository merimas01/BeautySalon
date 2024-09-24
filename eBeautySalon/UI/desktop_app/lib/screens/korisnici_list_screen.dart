import 'package:desktop_app/models/korisnik_update.dart';
import 'package:desktop_app/screens/korisnici_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/korisnik.dart';
import '../models/search_result.dart';
import '../providers/korisnik_provider.dart';
import '../utils/util.dart';
import '../widgets/master_screen.dart';

class KorisniciListScreen extends StatefulWidget {
  const KorisniciListScreen({super.key});

  @override
  State<KorisniciListScreen> createState() => _KorisniciListScreenState();
}

class _KorisniciListScreenState extends State<KorisniciListScreen> {
  late KorisnikProvider _korisniciProvider;
  SearchResult<Korisnik>? result;
  TextEditingController _ftsController = new TextEditingController();
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _korisniciProvider = context.read<KorisnikProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        title: "Korisnici",
        child: Column(
          children: [_buildSearch(), _buildDataListView()],
        ));
  }

  Widget _buildSearch() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                labelText: "Ime/Prezime/Korisnicko ime",
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

                var data = await _korisniciProvider
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
                    builder: (context) => KorisniciDetailsScreen(
                          korisnik: null,
                        )));
              },
              child: Text("Dodaj korisnika")),
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
              child: Text("Korisnik"),
            )),
            DataColumn(
                label: Expanded(
              child: Text("Korisničko ime"),
            )),
            DataColumn(
                label: Expanded(
              child: Text("Telefon"),
            )),
            DataColumn(
                label: Expanded(
              child: Text("E-mail"),
            )),
            DataColumn(
                label: Expanded(
              child: Text("Slika"),
            )),
            DataColumn(
                label: Expanded(
              child: Text("Blokiran/a?"),
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
                  .map((Korisnik e) => DataRow(cells: [
                        DataCell(Text("${e.ime} ${e.prezime}")),
                        DataCell(Text(e.korisnickoIme ?? "")),
                        DataCell(Text(e.telefon ?? "")),
                        DataCell(Text(e.email ?? "")),
                        DataCell(e.slikaProfila?.slika != null
                            ? Container(
                                width: 100,
                                height: 100,
                                child: ImageFromBase64String(
                                    e.slikaProfila!.slika),
                              )
                            : Text("")),
                        DataCell(Text("${e.status == true ? "Ne" : "Da"}")),
                        DataCell(
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            onPressed: () async {
                              _blockConfirmationDialog(e);
                            },
                            child: Text('Blokiraj'),
                          ),
                        ),
                        DataCell(TextButton(
                          child: Text("Detalji"),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => KorisniciDetailsScreen(
                                      korisnik: e,
                                    )));
                          },
                        ))
                      ]))
                  .toList() ??
              []),
    ));
  }

  void _blockConfirmationDialog(e) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text('Potvrda o blokiranju korisnika'),
              content: Text(
                  'Jeste li sigurni da želite blokirati izabranog korisnika?'),
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
                    _blockUser(e);
                  },
                ),
              ],
            ));
  }

  void _blockUser(e) async {
    var request = KorisnikUpdate(e.ime, e.prezime, e.email, e.telefon, false,e.slikaProfilaId);
    var blocked =
        await _korisniciProvider.update(e.korisnikId, request);
    print('deleted? ${blocked}');

    //treba da se osvjezi lista
    var data =
        await _korisniciProvider.get(filter: {'FTS': _ftsController.text});

    setState(() {
      result = data;
    });
  }
}
