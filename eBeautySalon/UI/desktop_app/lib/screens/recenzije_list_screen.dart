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
import '../utils/util.dart';
import '../widgets/master_screen.dart';

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
  bool isLoadingData = true;
  Usluga? selectedUsluga;
  Zaposlenik? selectedUsluznik;
  String? search1 = "";
  String? search2 = "";
  bool authorised = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _uslugeProvider = context.read<UslugeProvider>();
    _zaposleniciProvider = context.read<ZaposleniciProvider>();
    _recenzijeUslugeProvider = context.read<RecenzijaUslugeProvider>();
    _recenzijeUsluznikaProvider = context.read<RecenzijaUsluznikaProvider>();
    getData();
    getUsluge();
    getUsluznici();

    setState(() {
      if (LoggedUser.uloga == "Administrator") {
        authorised = true;
      } else {
        authorised = false;
      }

      print("authorised: $authorised");
    });
  }

  void getData() async {
    var recenzijeUsluge =
        await _recenzijeUslugeProvider.get(filter: {'FTS': ''});
    var recenzijeUsluznika =
        await _recenzijeUsluznikaProvider.get(filter: {'FTS': ''});

    // Add a listener to get the value whenever the text changes
    _ftsController1.addListener(() {
      String currentText = _ftsController1.text; // Access the current text
      setState(() {
        search1 = currentText;
      });
      print('Current Text: $currentText');
    });

    // Add a listener to get the value whenever the text changes
    _ftsController2.addListener(() {
      String currentText = _ftsController2.text; // Access the current text
      setState(() {
        search2 = currentText;
      });
      print('Current Text: $currentText');
    });

    setState(() {
      _recenzijaUslugeResult = recenzijeUsluge;
      _recenzijaUsluznikaResult = recenzijeUsluznika;
      isLoadingData = false;
    });
  }

  getUsluge() async {
    var usluge = await _uslugeProvider.get();
    setState(() {
      _uslugeResult = usluge;
      isLoadingUsluge = false;
    });
  }

  getUsluznici() async {
    var usluznici =
        await _zaposleniciProvider.get(filter: {'isUsluznik': true});
    setState(() {
      _usluzniciResult = usluznici;
      isLoadingUsluznici = false;
    });
  }

  Widget searchByUsluga() {
    print("search by usluga");
    if (isLoadingUsluge == false) {
      return Container(
        width: 400,
        height: 55,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey),
        ),
        child: Center(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Usluga>(
              hint: Text("Pretraži po usluzi"),
              value: selectedUsluga,
              isExpanded: true,
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
                  child: Text(
                    service.naziv!,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      );
    }
    return Center(child: CircularProgressIndicator());
  }

  Widget searchByUsluznik() {
    print("search by usluznik");
    if (isLoadingUsluznici == false) {
      return Container(
        width: 400,
        height: 55,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey),
        ),
        child: Center(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Zaposlenik>(
              hint: Text("Pretraži po uslužniku"),
              value: selectedUsluznik,
              isExpanded: true,
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
                  child: Text(
                    "${service.korisnik!.ime!} ${service.korisnik!.prezime!}",
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      );
    }
    return Center(child: CircularProgressIndicator());
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

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Recenzije",
      child: isLoadingData == false
          ? authorised == true
              ? Container(
                  child: DefaultTabController(
                      length: 2,
                      child: Column(
                        children: [
                          Container(
                              color: Colors.pink,
                              child: const TabBar(
                                labelColor:
                                    Colors.white, // Color for selected tab
                                unselectedLabelColor: Color.fromARGB(
                                    255, 0, 0, 0), // Color for unselected tabs
                                indicatorColor: Colors.white,
                                tabs: [
                                  Tab(
                                      text: "Recenzije usluga",
                                      icon: Icon(Icons.reviews)),
                                  Tab(
                                      text: "Recenzije uslužnika",
                                      icon: Icon(Icons.people)),
                                ],
                              )),
                          Expanded(
                            child: TabBarView(
                              children: [
                                Column(
                                  children: [
                                    _getRecenzijeUsluge(),
                                    Text(
                                      "Za pretragu zapisa pritisnite dugme Traži",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    SizedBox(height: 3,),
                                    _showResultUslugeCount(),
                                    _buildRecenzijeUslugaListView()
                                  ],
                                ),
                                Column(children: [
                                  _getRecenzijeUsluznika(),
                                  Text(
                                    "Za pretragu zapisa pritisnite dugme Traži",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  SizedBox(height: 3,),
                                  _showResultUsluzniciCount(),
                                  _buildRecenzijeUsluznikaListView()
                                ])
                              ],
                            ),
                          ),
                        ],
                      )))
              : buildAuthorisation()
          : Center(child: CircularProgressIndicator()),
    );
  }

  Widget _getRecenzijeUsluge() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                  labelText: "korisnik/ocjena/komentar",
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  hoverColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey))),
              controller: _ftsController1,
            ),
          ),
          search1 != ""
              ? TextButton(
                  onPressed: () {
                    setState(() {
                      _ftsController1.text = '';
                      search1 = _ftsController1.text;
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
            width: 8,
          ),
          searchByUsluga(),
          SizedBox(width: 8),
          selectedUsluga != null
              ? TextButton(
                  onPressed: () {
                    setState(() {
                      selectedUsluga = null;
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
              child: Text("Slika korisnika"),
            )),
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
                        DataCell(e.korisnik?.slikaProfila?.slika != null &&
                                e.korisnik?.slikaProfila?.slika != ""
                            ? Container(
                                width: 100,
                                height: 100,
                                child: ImageFromBase64String(
                                    e.korisnik!.slikaProfila!.slika),
                              )
                            : Container(
                                child: Image.asset(
                                "assets/images/noImage.jpg",
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ))),
                        DataCell(Text(
                          "${e.korisnik?.ime ?? ""} ${e.korisnik?.prezime ?? ""}",
                        )),
                        DataCell(Text("${e.usluga?.naziv ?? ""}")),
                        DataCell(Container(
                            width: 150,
                            child: Text((e.datumKreiranja == null
                                ? "-"
                                : formatDate(e.datumKreiranja!))))),
                        DataCell(Container(
                            width: 150,
                            child: Text((e.datumModificiranja == null
                                ? "-"
                                : formatDate(e.datumModificiranja!))))),
                        DataCell(Text(e.ocjena.toString())),
                        DataCell(Text("${e.komentar ?? ""}")),
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
              title: Text(
                'Potvrda o brisanju zapisa',
                textAlign: TextAlign.center,
              ),
              content: Text('Jeste li sigurni da želite izbrisati ovaj zapis?',
                  textAlign: TextAlign.center),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.grey),
                  child: Text('Ne'),
                  onPressed: () {
                    Navigator.of(context).pop(); //zatvori dijalog
                  },
                ),
                TextButton(
                  child: Text('Da'),
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red),
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                  labelText: "korisnik/ocjena/komentar",
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  hoverColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey))),
              controller: _ftsController2,
            ),
          ),
          search2 != ""
              ? TextButton(
                  onPressed: () {
                    setState(() {
                      _ftsController2.text = '';
                      search2 = _ftsController2.text;
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
            width: 8,
          ),
          searchByUsluznik(),
          SizedBox(width: 8),
          selectedUsluznik != null
              ? TextButton(
                  onPressed: () {
                    setState(() {
                      selectedUsluznik = null;
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
          SizedBox(width: 10),
          ElevatedButton(
              onPressed: () async {
                print("pritisnuto dugme trazi rec. usluznika");

                var data = await _recenzijeUsluznikaProvider.get(filter: {
                  'FTS': _ftsController2.text,
                  'usluznikId': selectedUsluznik?.zaposlenikId
                });

                print("fts: ${_ftsController2.text}");

                setState(() {
                  _recenzijaUsluznikaResult = data;
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

  Widget _buildRecenzijeUsluznikaListView() {
    return Expanded(
        child: SingleChildScrollView(
      child: DataTable(
          columns: [
            DataColumn(
                label: Expanded(
              child: Text("Slika korisnika"),
            )),
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
                        DataCell(e.korisnik?.slikaProfila?.slika != null &&
                                e.korisnik?.slikaProfila?.slika != ""
                            ? Container(
                                width: 100,
                                height: 100,
                                child: ImageFromBase64String(
                                    e.korisnik!.slikaProfila!.slika),
                              )
                            : Container(
                                child: Image.asset(
                                "assets/images/noImage.jpg",
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ))),
                        DataCell(Text(
                          " ${e.korisnik?.ime ?? ""} ${e.korisnik?.prezime ?? ""}",
                        )),
                        DataCell(Text(
                            "${e.usluznik?.korisnik?.ime ?? ""} ${e.usluznik?.korisnik?.prezime ?? ""}")),
                        DataCell(Container(
                            width: 150,
                            child: Text((e.datumKreiranja == null
                                ? "-"
                                : formatDate(e.datumKreiranja!))))),
                        DataCell(Container(
                            width: 150,
                            child: Text((e.datumModificiranja == null
                                ? "-"
                                : formatDate(e.datumModificiranja!))))),
                        DataCell(Text(e.ocjena.toString())),
                        DataCell(Text("${e.komentar ?? ""}")),
                        DataCell(
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            onPressed: () async {
                              _deleteRecenzijaUsluznika(e);
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
              title: Text(
                'Potvrda o brisanju zapisa',
                textAlign: TextAlign.center,
              ),
              content: Text(
                'Jeste li sigurni da želite izbrisati ovaj zapis?',
                textAlign: TextAlign.center,
              ),
              actions: <Widget>[
                ElevatedButton(
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.grey),
                  child: Text('Ne'),
                  onPressed: () {
                    Navigator.of(context).pop(); //zatvori dijalog
                  },
                ),
                ElevatedButton(
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red),
                  child: Text('Da'),
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
    var deleted = await _recenzijeUsluznikaProvider.delete(e.recenzijaUsluznikaId);
    print('deleted? ${deleted}');

    //treba da se osvjezi lista
    var data = await _recenzijeUsluznikaProvider.get(filter: {
      'FTS': _ftsController2.text,
      'usluznikId': selectedUsluznik?.zaposlenikId
    });

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
