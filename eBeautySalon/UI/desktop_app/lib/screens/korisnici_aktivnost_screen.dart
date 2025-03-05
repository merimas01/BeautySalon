import 'package:desktop_app/models/novost_like_comment.dart';
import 'package:desktop_app/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/korisnik.dart';
import '../models/recenzija_usluge.dart';
import '../models/recenzija_usluznika.dart';
import '../models/rezervacija.dart';
import '../models/search_result.dart';
import '../providers/novost_like_comment_provider.dart';
import '../providers/recenzija_usluznika_provider.dart';
import '../providers/recenzije_usluga_provider.dart';
import '../providers/rezarvacije_provider.dart';
import '../utils/util.dart';
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
  late NovostLikeCommentProvider _novostLikeCommentProvider;
  SearchResult<RecenzijaUsluge>? _recenzijaUslugeResult;
  SearchResult<RecenzijaUsluznika>? _recenzijaUsluznikaResult;
  SearchResult<Rezervacija>? _rezervacijeResult;
  SearchResult<NovostLikeComment>? _novostLikeCommentResult;
  TextEditingController _ftsController1 = new TextEditingController();
  TextEditingController _ftsController2 = new TextEditingController();
  TextEditingController _ftsController3 = new TextEditingController();
  TextEditingController _ftsController4 = new TextEditingController();
  bool isLoadingUsluge = true;
  bool isLoadingUsluznici = true;
  bool isLoadingData = true;
  bool isLoadingLikeComment = true;
  String? search1 = "";
  String? search2 = "";
  String? search3 = "";
  String? search4 = "";

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
    _novostLikeCommentProvider = context.read<NovostLikeCommentProvider>();
    getData();
  }

  void getData() async {
    var recenzijeUsluge = await _recenzijeUslugeProvider.get(filter: {
      'FTS': _ftsController1.text,
      'korisnikId': widget.korisnik!.korisnikId
    });
    var recenzijeUsluznika = await _recenzijeUsluznikaProvider.get(filter: {
      'FTS': _ftsController2.text,
      'korisnikId': widget.korisnik!.korisnikId
    });
    var rezervacije = await _rezervacijeProvider.get(filter: {
      'FTS': _ftsController3.text,
      'korisnikId': widget.korisnik!.korisnikId
    });
    var novostLikeComment = await _novostLikeCommentProvider.get(filter: {
      'FTS': _ftsController4.text,
      'korisnikId': widget.korisnik!.korisnikId,
      'isNovostIncluded': true
    });

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
      String currentText = _ftsController3.text; // Access the current text
      setState(() {
        search3 = currentText;
      });
      print('Current Text: $currentText');
    });

    // Add a listener to get the value whenever the text changes
    _ftsController4.addListener(() {
      String currentText = _ftsController4.text; // Access the current text
      setState(() {
        search4 = currentText;
      });
      print('Current Text: $currentText');
    });

    setState(() {
      _recenzijaUslugeResult = recenzijeUsluge;
      _recenzijaUsluznikaResult = recenzijeUsluznika;
      _rezervacijeResult = rezervacije;
      _novostLikeCommentResult = novostLikeComment;
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
            length: 4,
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
                            icon: Icon(Icons.notes_outlined)),
                        Tab(
                            text: "Njegovi komentari/lajkovi za novosti",
                            icon: Icon(Icons.thumb_up)),
                      ],
                    )),
                Expanded(
                  child: TabBarView(
                    children: [
                      Column(
                        children: [
                          _getRecenzijeUsluge(),
                          _showResultCount(_recenzijaUslugeResult),
                          isLoadingData == false
                              ? _buildRecenzijeUslugaListView()
                              : Container(child: CircularProgressIndicator()),
                        ],
                      ),
                      Column(children: [
                        _getRecenzijeUsluznika(),
                        _showResultCount(_recenzijaUsluznikaResult),
                        isLoadingData == false
                            ? _buildRecenzijeUsluznikaListView()
                            : Container(child: CircularProgressIndicator()),
                      ]),
                      Column(
                        children: [
                          _getRezervacije(),
                          _showResultCount(_rezervacijeResult),
                          isLoadingData == false
                              ? _buildRezervacijeListView()
                              : Container(child: CircularProgressIndicator()),
                        ],
                      ),
                      Column(
                        children: [
                          _getNovostLikeComments(),
                          _showResultCount(_novostLikeCommentResult),
                          isLoadingData == false
                              ? _buildNovostLikeCommentListView()
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
          _nazad(),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                  labelText: "šifra usluge/usluga/ocjena/komentar",
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
          SizedBox(width: 10),
          ElevatedButton(
              onPressed: () async {
                print("pritisnuto dugme trazi rec. usluge");

                var data = await _recenzijeUslugeProvider.get(filter: {
                  'FTS': _ftsController1.text,
                  'korisnikId': widget.korisnik!.korisnikId
                });
                setState(() {
                  _recenzijaUslugeResult = data;
                });
              },
              child: Text("Traži")),
        ],
      ),
    );
  }

  Widget _getRecenzijeUsluznika() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          _nazad(),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                  labelText: "šifra uslužnika/uslužnik/ocjena/komentar",
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
          SizedBox(width: 10),
          ElevatedButton(
              onPressed: () async {
                print("pritisnuto dugme trazi rec. usluznika");

                var data = await _recenzijeUsluznikaProvider.get(filter: {
                  'FTS': _ftsController2.text,
                  'korisnikId': widget.korisnik!.korisnikId
                });

                setState(() {
                  _recenzijaUsluznikaResult = data;
                });
              },
              child: Text("Traži")),
        ],
      ),
    );
  }

  Widget _getRezervacije() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          _nazad(),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                  labelText:
                      "šifra rezervacije/šifra usluge/usluga/termin/status",
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  hoverColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey))),
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

                var data = await _rezervacijeProvider.get(filter: {
                  'FTS': _ftsController3.text,
                  'korisnikId': widget.korisnik!.korisnikId
                });

                setState(() {
                  _rezervacijeResult = data;
                });
              },
              child: Text("Traži")),
        ],
      ),
    );
  }

  Widget _getNovostLikeComments() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          _nazad(),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                  labelText: "šifra novosti/novost/komentar",
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  hoverColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey))),
              controller: _ftsController4,
            ),
          ),
          search4 != ""
              ? TextButton(
                  onPressed: () {
                    setState(() {
                      _ftsController4.text = '';
                      search4 = _ftsController4.text;
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
                print("pritisnuto dugme trazi novostlikecomment");

                var data = await _novostLikeCommentProvider.get(filter: {
                  'FTS': _ftsController4.text,
                  'korisnikId': widget.korisnik!.korisnikId,
                  'isNovostIncluded': true
                });

                setState(() {
                  _novostLikeCommentResult = data;
                });
              },
              child: Text("Traži")),
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
                                : formatDate(e.datumKreiranja!))))),
                        DataCell(Container(
                            width: 150,
                            child: Text((e.datumModificiranja == null
                                ? "-"
                                : formatDate(e.datumModificiranja!))))),
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
                                : formatDate(e.datumKreiranja!))))),
                        DataCell(Container(
                            width: 150,
                            child: Text((e.datumModificiranja == null
                                ? "-"
                                : formatDate(e.datumModificiranja!))))),
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
              child: Text("Rezervacija"),
            )),
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
            DataColumn(
                label: Expanded(
              child: Text("Status"),
            )),
          ],
          rows: _rezervacijeResult?.result
                  .map((Rezervacija e) =>
                      DataRow(color: _obojiRedove(e), cells: [
                        DataCell(Text("${e.sifra}")),
                        DataCell(Text(
                            "${e.usluga?.sifra ?? ""} - ${e.usluga?.naziv ?? ""}")),
                        DataCell(Text("${e.termin?.opis ?? ""}")),
                        DataCell(Container(
                            width: 150,
                            child: Text((e.datumRezervacije == null
                                ? "-"
                                : formatDate(e.datumRezervacije!))))),
                        DataCell(Text("${e.status?.opis}")),
                      ]))
                  .toList() ??
              []),
    ));
  }

  Widget _buildNovostLikeCommentListView() {
    return Expanded(
        child: SingleChildScrollView(
      child: DataTable(
          columns: [
            DataColumn(
                label: Expanded(
              child: Text("Novost"),
            )),
            DataColumn(
                label: Expanded(
              child: Icon(Icons.thumb_up),
            )),
            DataColumn(
                label: Expanded(
              child: Icon(Icons.comment),
            )),
            DataColumn(
                label: Expanded(
              child: Text("Datum kreiranja"),
            )),
            DataColumn(
                label: Expanded(
              child: Text("Datum modifikovanja"),
            )),
          ],
          rows: _novostLikeCommentResult?.result
                  .map((NovostLikeComment e) => DataRow(cells: [
                        DataCell(Text(
                            "${e.novost?.sifra} - ${e.novost?.naslov ?? ""}")),
                        DataCell(e.isLike == true
                            ? Icon(Icons.thumb_up_alt_outlined)
                            : Text("")),
                        DataCell(Text("${e.komentar ?? ""}")),
                        DataCell(Container(
                            width: 150,
                            child: Text((e.datumKreiranja == null
                                ? "-"
                                : formatDate(e.datumKreiranja!))))),
                        DataCell(Container(
                            width: 150,
                            child: Text((e.datumModifikovanja == null
                                ? "-"
                                : formatDate(e.datumModifikovanja!))))),
                      ]))
                  .toList() ??
              []),
    ));
  }

  Widget _showResultCount(data) {
    return RichText(
        text: TextSpan(
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
            children: [
          TextSpan(
            text: 'Broj rezultata: ${data?.count == null ? 0 : data?.count}',
            style: TextStyle(fontWeight: FontWeight.normal),
          )
        ]));
  }

  _obojiRedove(Rezervacija e) {
    if (e.status?.opis == "Prihvacena")
      return MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          return Colors.green[100];
        },
      );
    else if (e.status?.opis == "Odbijena")
      return MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          return Colors.red[100];
        },
      );
    else if (e.status?.opis == "Otkazana")
      return MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          return Colors.grey[100];
        },
      );
    else if (e.status?.opis == "Nova")
      return MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          return Colors.yellow[100];
        },
      );
  }
}
