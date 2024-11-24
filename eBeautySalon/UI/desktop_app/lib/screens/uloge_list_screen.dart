import 'package:desktop_app/screens/uloge_details_screen.dart';
import 'package:desktop_app/screens/zaposlenici_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/korisnik.dart';
import '../models/search_result.dart';
import '../models/uloga.dart';
import '../models/zaposlenik.dart';
import '../providers/uloge_provider.dart';
import '../widgets/master_screen.dart';

class UlogeListScreen extends StatefulWidget {
  Zaposlenik? zaposlenik;
  Korisnik? korisnik;
  UlogeListScreen({super.key, this.zaposlenik, this.korisnik});

  @override
  State<UlogeListScreen> createState() => _UlogeListScreenState();
}

class _UlogeListScreenState extends State<UlogeListScreen> {
  late UlogeProvider _ulogeProvider;
  SearchResult<Uloga>? result;
  TextEditingController _ftsController = new TextEditingController();
  bool isLoadingData = true;
  String? search = "";

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _ulogeProvider = context.read<UlogeProvider>();
    getData();
  }

  void getData() async {
    var data = await _ulogeProvider.get(filter: {'FTS': ''});

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
        title: "Upravljaj ulogama",
        child: Column(children: [
          _builSearch(),
          _showResultCount(),
          isLoadingData == false
              ? _buildDataListView()
              : Container(child: CircularProgressIndicator()),
        ]));
  }

  Widget _builSearch() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 255, 255, 255)),
                foregroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 139, 132, 134)),
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ZaposleniciDetailsScreen(
                          zaposlenik: widget.zaposlenik,
                          korisnik: widget.korisnik,
                        )));
              },
              child: Text("Nazad na zaposlenika")),
          SizedBox(
            width: 8,
          ),
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
          SizedBox(width: 8),
          ElevatedButton(
              onPressed: () async {
                print("pritisnuto dugme Dugme");

                var data = await _ulogeProvider
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
              style: TextButton.styleFrom(
                  foregroundColor: Colors.pink, backgroundColor: Colors.white),
              onPressed: () async {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => UlogeDetailsScreen(
                          uloga: null,
                          zaposlenik: this.widget.zaposlenik,
                          korisnik: this.widget.korisnik,
                        )));
              },
              child: Text("Dodaj ulogu")),
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
              child: Text("Uloga"),
            )),
            DataColumn(
                label: Expanded(
              child: Text("Opis"),
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
                  .map((Uloga e) => DataRow(cells: [
                        DataCell(Text(e.naziv ?? "")),
                        DataCell(Text(e.opis ?? "")),
                        DataCell(TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.green,
                          ),
                          child: Text("Modifikuj"),
                          onPressed: () {
                            print("modifikacija: ${e.naziv}, id: ${e.ulogaId}");
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => UlogeDetailsScreen(
                                      uloga: e,
                                      zaposlenik: this.widget.zaposlenik,
                                      korisnik: this.widget.korisnik,
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
              title: Text('Potvrda o brisanju zapisa',
                  textAlign: TextAlign.center),
              content: Text('Jeste li sigurni da želite izbrisati ovaj zapis?',
                  textAlign: TextAlign.center),
              actions: <Widget>[
                ElevatedButton(
                  child: Text('Ne'),
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.grey),
                  onPressed: () {
                    Navigator.of(context).pop(); //zatvori dijalog
                  },
                ),
                ElevatedButton(
                  child: Text('Da'),
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red),
                  onPressed: () async {
                    Navigator.of(context).pop(); //zatvori dijalog
                    _obrisiZapis(e);
                  },
                ),
              ],
            ));
  }

  void _obrisiZapis(e) async {
    print("delete ulogaId: ${e.ulogaId}, naziv: ${e.naziv}");

    try {
      var deleted = await _ulogeProvider.delete(e.ulogaId);
      //print('deleted? ${deleted}');
    } catch (e) {
      await showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: Text("Greška"),
                content: Text(
                    "Uloga se ne može izbrisati jer se već koristi kod pojedinih zaposlenika ili jednog zaposlenika."),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Ok"))
                ],
              ));
    }
    //treba da se osvjezi lista
    var data = await _ulogeProvider.get(filter: {'FTS': _ftsController.text});

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
