import 'package:desktop_app/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/korisnik.dart';
import '../models/recenzija_usluge.dart';
import '../models/recenzija_usluznika.dart';
import '../models/rezervacija.dart';
import '../models/search_result.dart';
import '../providers/recenzija_usluznika_provider.dart';
import '../providers/recenzije_usluga_provider.dart';
import '../providers/rezarvacije_provider.dart';
import 'korisnici_details_screen.dart';

class KorisniciAktivnostScreen extends StatefulWidget {
  Korisnik? korisnik;
  KorisniciAktivnostScreen({super.key, this.korisnik});

  @override
  State<KorisniciAktivnostScreen> createState() =>
      _KorisniciAktivnostScreenState();
}

class _KorisniciAktivnostScreenState extends State<KorisniciAktivnostScreen> {
  Map<String, dynamic> _initialValue = {};
  late RecenzijaUslugeProvider _recenzijeUslugeProvider;
  late RecenzijaUsluznikaProvider _recenzijeUsluznikaProvider;
  late RezervacijeProvider _rezervacijeProvider;
  SearchResult<RecenzijaUsluge>? _recenzijaUslugeResult;
  SearchResult<RecenzijaUsluznika>? _recenzijaUsluznikaResult;
  SearchResult<Rezervacija>? _rezervacijeResult;
  TextEditingController _ftsController1 = new TextEditingController();
  TextEditingController _ftsController2 = new TextEditingController();
  TextEditingController _ftsController3 = new TextEditingController();
  bool isLoadingUsluge = true;
  bool isLoadingUsluznici = true;
  bool isLoadingData = true;
  String? search1 = "";
  String? search2 = "";
  String? search3 = "";

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        title: "Aktivnost korisnika: ${widget.korisnik?.sifra ?? ""}",
        child: _tabBars());
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print("Korisnik: ${widget.korisnik?.korisnikId}");
    _recenzijeUslugeProvider = context.read<RecenzijaUslugeProvider>();
    _recenzijeUsluznikaProvider = context.read<RecenzijaUsluznikaProvider>();
    _rezervacijeProvider = context.read<RezervacijeProvider>();
    getData();
  }

  void getData() async {
    var recenzijeUsluge =
        await _recenzijeUslugeProvider.GetRecenzijeUslugeByKorisnikId(
            widget.korisnik!.korisnikId, _ftsController1.text);
    var recenzijeUsluznika =
        await _recenzijeUsluznikaProvider.GetRecenzijeUsluznikaByKorisnikId(
            widget.korisnik!.korisnikId, _ftsController2.text);
    var rezervacije = await _rezervacijeProvider.GetRezervacijeByKorisnikId(
        widget.korisnik!.korisnikId, _ftsController3.text);

    print("rec ul.: ${recenzijeUsluge.result[0].korisnikId}");

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

    // Add a listener to get the value whenever the text changes
    _ftsController3.addListener(() {
      String currentText = _ftsController2.text; // Access the current text
      setState(() {
        search3 = currentText;
      });
      print('Current Text: $currentText');
    });

    setState(() {
      _recenzijaUslugeResult = recenzijeUsluge;
      _recenzijaUsluznikaResult = recenzijeUsluznika;
      _rezervacijeResult = rezervacije;
      isLoadingData = false;
    });
  }

  Widget _nazad() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
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
                  builder: (context) => KorisniciDetailsScreen(
                        korisnik: widget.korisnik,
                      )));
            },
            child: Text("Nazad na korisnika")),
      ],
    );
  }

  Widget _tabBars() {
    return Container(
        child: DefaultTabController(
            length: 3,
            child: Column(
              children: [
                Container(
                    color: Colors.pink,
                    child: const TabBar(
                      labelColor: Colors.white, // Color for selected tab
                      unselectedLabelColor: Color.fromARGB(
                          255, 0, 0, 0), // Color for unselected tabs
                      indicatorColor: Colors.white,
                      tabs: [
                        Tab(
                            text: "Njegove recenzije usluga",
                            icon: Icon(Icons.reviews)),
                        Tab(
                            text: "Njegove recenzije uslužnika",
                            icon: Icon(Icons.people)),
                        Tab(
                            text: "Njegove rezervacije",
                            icon: Icon(Icons.people)),
                      ],
                    )),
                Expanded(
                  child: TabBarView(
                    children: [
                      Column(
                        children: [
                          _getRecenzijeUsluge(),
                          _showResultUslugeCount(),
                          isLoadingData == false
                              ? _buildRecenzijeUslugaListView()
                              : Container(child: CircularProgressIndicator()),
                        ],
                      ),
                      Column(children: [
                        _getRecenzijeUsluznika(),
                        _showResultUsluzniciCount(),
                        isLoadingData == false
                            ? _buildRecenzijeUsluznikaListView()
                            : Container(child: CircularProgressIndicator()),
                      ]),
                      Column(
                        children: [
                          _getRezervacije(),
                          _showResultRezervacijeCount(),
                          isLoadingData == false
                              ? _buildRezervacijeListView()
                              : Container(child: CircularProgressIndicator()),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }

  Widget _getRecenzijeUsluge() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                labelText: "usluga/ocjena/komentar",
              ),
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
          SizedBox(width: 10),
          ElevatedButton(
              onPressed: () async {
                print("pritisnuto dugme trazi rec. usluge");

                var data = await _recenzijeUslugeProvider
                    .GetRecenzijeUslugeByKorisnikId(
                        widget.korisnik!.korisnikId!, _ftsController1.text);

                setState(() {
                  _recenzijaUslugeResult = data;
                });
              },
              child: Text("Traži")),
          SizedBox(
            width: 8,
          ),
          _nazad(),
        ],
      ),
    );
  }

  Widget _getRecenzijeUsluznika() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                labelText: "uslužnik/ocjena/komentar",
              ),
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
          SizedBox(width: 10),
          ElevatedButton(
              onPressed: () async {
                print("pritisnuto dugme trazi rec. usluznika");

                var data = await _recenzijeUsluznikaProvider
                    .GetRecenzijeUsluznikaByKorisnikId(
                        widget.korisnik!.korisnikId!, _ftsController2.text);

                setState(() {
                  _recenzijaUsluznikaResult = data;
                });
              },
              child: Text("Traži")),
          SizedBox(
            width: 8,
          ),
          _nazad(),
        ],
      ),
    );
  }

  Widget _getRezervacije() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                labelText: "usluga/termin",
              ),
              controller: _ftsController3,
            ),
          ),
          search3 != ""
              ? TextButton(
                  onPressed: () {
                    setState(() {
                      _ftsController3.text = '';
                      search3 = _ftsController3.text;
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
          SizedBox(width: 10),
          ElevatedButton(
              onPressed: () async {
                print("pritisnuto dugme trazi rezervacije");

                var data =
                    await _rezervacijeProvider.GetRezervacijeByKorisnikId(
                        widget.korisnik!.korisnikId!, _ftsController3.text);

                setState(() {
                  _rezervacijeResult = data;
                });
              },
              child: Text("Traži")),
          SizedBox(
            width: 8,
          ),
          _nazad(),
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
          ],
          rows: _recenzijaUslugeResult?.result
                  .map((RecenzijaUsluge e) => DataRow(cells: [
                        DataCell(Text(
                            "${e.usluga?.sifra ?? ""} - ${e.usluga?.naziv ?? ""}")),
                        DataCell(Container(
                            width: 150,
                            child: Text((e.datumKreiranja == null
                                ? "-"
                                : "${e.datumKreiranja?.day}.${e.datumKreiranja?.month}.${e.datumKreiranja?.year}")))),
                        DataCell(Container(
                            width: 150,
                            child: Text((e.datumModificiranja == null
                                ? "-"
                                : "${e.datumModificiranja?.day}.${e.datumModificiranja?.month}.${e.datumModificiranja?.year}")))),
                        DataCell(Text(e.ocjena.toString())),
                        DataCell(Text("${e.komentar ?? ""}")),
                      ]))
                  .toList() ??
              []),
    ));
  }

  Widget _buildRecenzijeUsluznikaListView() {
    return Expanded(
        child: SingleChildScrollView(
      child: DataTable(
          columns: [
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
          ],
          rows: _recenzijaUsluznikaResult?.result
                  .map((RecenzijaUsluznika e) => DataRow(cells: [
                        DataCell(Text(
                            "${e.usluznik?.korisnik?.sifra ?? ""} - ${e.usluznik?.korisnik?.ime ?? ""} ${e.usluznik?.korisnik?.prezime ?? ""}")),
                        DataCell(Container(
                            width: 150,
                            child: Text((e.datumKreiranja == null
                                ? "-"
                                : "${e.datumKreiranja?.day}.${e.datumKreiranja?.month}.${e.datumKreiranja?.year}")))),
                        DataCell(Container(
                            width: 150,
                            child: Text((e.datumModificiranja == null
                                ? "-"
                                : "${e.datumModificiranja?.day}.${e.datumModificiranja?.month}.${e.datumModificiranja?.year}")))),
                        DataCell(Text(e.ocjena.toString())),
                        DataCell(Text("${e.komentar ?? ""}")),
                      ]))
                  .toList() ??
              []),
    ));
  }

  Widget _buildRezervacijeListView() {
    return Expanded(
        child: SingleChildScrollView(
      child: DataTable(
          columns: [
            DataColumn(
                label: Expanded(
              child: Text("Usluga"),
            )),
            DataColumn(
                label: Expanded(
              child: Text("Termin"),
            )),
            DataColumn(
                label: Expanded(
              child: Text("Datum kreiranja"),
            )),
          ],
          rows: _rezervacijeResult?.result
                  .map((Rezervacija e) => DataRow(cells: [
                        DataCell(Text(
                            "${e.usluga?.sifra ?? ""} - ${e.usluga?.naziv ?? ""}")),
                        DataCell(Text(
                            "${e.termin?.sifra ?? ""} - ${e.termin?.opis ?? ""}")),
                        DataCell(Container(
                            width: 150,
                            child: Text((e.datumRezervacije == null
                                ? "-"
                                : "${e.datumRezervacije?.day}.${e.datumRezervacije?.month}.${e.datumRezervacije?.year}")))),
                      ]))
                  .toList() ??
              []),
    ));
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

  Widget _showResultRezervacijeCount() {
    return RichText(
        text: TextSpan(
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
            children: [
          TextSpan(
            text:
                'Broj rezultata: ${_rezervacijeResult?.count == null ? 0 : _rezervacijeResult?.count}',
            style: TextStyle(fontWeight: FontWeight.normal),
          )
        ]));
  }
}
