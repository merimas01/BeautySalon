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
  bool isLoadingData = true;
  String? search = "";
  bool authorised = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _korisniciProvider = context.read<KorisnikProvider>();
    getData();
  }

  void getData() async {
    var data = await _korisniciProvider
        .get(filter: {'FTS': '', 'isBlokiran': selectedOpis});

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

    setState(() {
      if (LoggedUser.uloga == "Administrator") {
        authorised = true;
      } else {
        authorised = false;
      }

      print("authorised: $authorised");
    });
  }

  Widget buildAuthorisation() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Container(
            width: 800,
            height: 300,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("🔐",
                          style: TextStyle(
                            fontSize: 40.0,
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Nažalost ne možete pristupiti ovoj stranici.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  var dropdown_lista = [
    {'opis': 'da', 'vrijednost': true},
    {'opis': 'ne', 'vrijednost': false}
  ];

  String? selectedOpis;

  Widget _showDropdownDialog() {
    return Container(
      width: 150,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      child: Center(
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedOpis,
            // isExpanded: true,
            hint: Text("Blokiran?"),
            items: dropdown_lista.map((item) {
              return DropdownMenuItem<String>(
                value: item['opis'] as String,
                child: Text(item['opis'] as String),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedOpis = value;
              });
              print(selectedOpis);
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        title: "Korisnici",
        child: isLoadingData == false
            ? authorised == true
                ? Column(
                    children: [
                      _buildSearch(),
                      _showResultCount(),
                      _buildDataListView()
                    ],
                  )
                : buildAuthorisation()
            : Center(child: CircularProgressIndicator()));
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

  Widget _buildSearch() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                labelText: "šifra/ime/prezime/korisničko ime",
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
          SizedBox(
            width: 20,
          ),
          _showDropdownDialog(),
          SizedBox(
            width: 10,
          ),
          selectedOpis != null
              ? TextButton(
                  onPressed: () {
                    setState(() {
                      selectedOpis = null;
                    });
                  },
                  child: Tooltip(
                    child: Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
                    message: "Poništi selekciju",
                  ),
                )
              : Container(),
          SizedBox(width: 20),
          ElevatedButton(
              onPressed: () async {
                print("pritisnuto dugme Trazi");

                var data = await _korisniciProvider.get(filter: {
                  'FTS': _ftsController.text,
                  'isBlokiran': selectedOpis
                });

                print(
                    "fts: ${_ftsController.text}, isBlokiran: ${selectedOpis}");

                setState(() {
                  result = data;
                });
              },
              child: Text("Traži")),
          SizedBox(
            width: 8,
          ),
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
              child: Text("Šifra"),
            )),
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
                        DataCell(Text(e.sifra ?? "")),
                        DataCell(Text("${e.ime} ${e.prezime}")),
                        DataCell(Text(e.korisnickoIme ?? "")),
                        DataCell(Text(e.telefon ?? "")),
                        DataCell(Text(e.email ?? "")),
                        DataCell(
                          e.slikaProfila?.slika != null &&
                                  e.slikaProfila?.slika != ""
                              ? Container(
                                  width: 100,
                                  height: 100,
                                  child: ImageFromBase64String(
                                      e.slikaProfila!.slika),
                                )
                              : Container(
                                  child: Image.asset(
                                  "assets/images/noImage.jpg",
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                )),
                        ),
                        DataCell(Text("${e.status == true ? "Ne" : "Da"}")),
                        DataCell(
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            onPressed: () async {
                              _blockConfirmationDialog(e);
                            },
                            child: Text(
                                '${e.status == true ? "Blokiraj" : "Odblokiraj"}'),
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
              title: e?.status == true
                  ? Text('Potvrda o blokiranju korisnika')
                  : Text('Potvrda o odblokiranju korisnika'),
              content: e?.status == true
                  ? Text(
                      'Jeste li sigurni da želite blokirati izabranog korisnika?')
                  : Text(
                      "Jeste li sigurni da želite odblokirati izabranog korisnika?"),
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
                    _blockUnblockUser(e);
                  },
                ),
              ],
            ));
  }

  void _blockUnblockUser(e) async {
    var status = e.status == true ? false : true;
    var request = KorisnikUpdate(
        e.ime, e.prezime, e.email, e.telefon, status, e.slikaProfilaId);
    var obj = await _korisniciProvider.update(e.korisnikId, request);
    print('status? ${obj.status}');

    //treba da se osvjezi dropdown_lista
    var data = await _korisniciProvider
        .get(filter: {'FTS': _ftsController.text, 'isBlokiran': selectedOpis});

    setState(() {
      result = data;
    });
  }
}
