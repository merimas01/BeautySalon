import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:mobile_app/models/korisnik.dart';
import 'package:mobile_app/screens/profil_page.dart';
import 'package:mobile_app/screens/usluga_details.dart';
import 'package:mobile_app/screens/usluznik_details.dart';
import 'package:mobile_app/widgets/master_screen.dart';
import 'package:provider/provider.dart';

import '../models/recenzija_usluge.dart';
import '../models/recenzija_usluznika.dart';
import '../models/search_result.dart';
import '../providers/recenzije_usluga_provider.dart';
import '../providers/recenzije_usluznika_provider.dart';
import '../utils/util.dart';
import 'edit_recenzija_usluge.dart';
import 'edit_recenzija_usluznika.dart';

class MojeRecenzije extends StatefulWidget {
  Korisnik? korisnik;
  MojeRecenzije({super.key, this.korisnik});

  @override
  State<MojeRecenzije> createState() => _MojeRecenzijeState();
}

class _MojeRecenzijeState extends State<MojeRecenzije> {
  late RecenzijaUslugeProvider _recenzijeUslugeProvider;
  late RecenzijaUsluznikaProvider _recenzijeUsluznikaProvider;
  SearchResult<RecenzijaUsluge>? _recenzijaUslugeResult;
  SearchResult<RecenzijaUsluznika>? _recenzijaUsluznikaResult;
  TextEditingController _ftsController1 = new TextEditingController();
  TextEditingController _ftsController2 = new TextEditingController();
  bool isLoadingUsluge = true;
  bool isLoadingUsluznici = true;
  bool isLoadingData = true;
  String? search1 = "";
  String? search2 = "";
  int _ratingUsluga = 0;
  int _ratingUsluznik = 0;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print("Korisnik: ${widget.korisnik?.korisnikId}");
    _recenzijeUslugeProvider = context.read<RecenzijaUslugeProvider>();
    _recenzijeUsluznikaProvider = context.read<RecenzijaUsluznikaProvider>();
    getData();
  }

  void getData() async {
    var recenzijeUsluge = await _recenzijeUslugeProvider.get(filter: {
      'FTS': _ftsController1.text,
      'korisnikId': widget.korisnik!.korisnikId,
    });
    var recenzijeUsluznika = await _recenzijeUsluznikaProvider.get(filter: {
      'FTS': _ftsController2.text,
      'korisnikId': widget.korisnik!.korisnikId,
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

    setState(() {
      _recenzijaUslugeResult = recenzijeUsluge;
      _recenzijaUsluznikaResult = recenzijeUsluznika;
      isLoadingData = false;
    });
  }

  Widget _tabBars() {
    return Container(
        child: DefaultTabController(
            length: 2,
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
                            text: "Moje recenzije usluga",
                            icon: Icon(Icons.reviews)),
                        Tab(
                            text: "Moje recenzije uslužnika",
                            icon: Icon(Icons.people)),
                      ],
                    )),
                Expanded(
                  child: TabBarView(
                    children: [
                      Column(
                        children: [
                          _searchByCategories(),
                          isLoadingData == false
                              ? _buildRecenzijeUslugaListView()
                              : Container(child: CircularProgressIndicator()),
                        ],
                      ),
                      Column(children: [
                        _searchByUsluge(), //na backendu, recenzijaUsluznika, treba koristiti korisnikId i uslugaId
                        isLoadingData == false
                            ? _buildRecenzijeUsluznikaListView()
                            : Container(child: CircularProgressIndicator()),
                      ]),
                    ],
                  ),
                ),
              ],
            )));
  }

  _searchByUsluge() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButton<String>(
        value: selectedValue,
        hint: Text('Izaberite uslugu'),
        dropdownColor: Colors.grey[200], // Background color of dropdown
        style: TextStyle(color: Colors.black, fontSize: 16), // Text style
        icon: Icon(Icons.arrow_drop_down, color: Colors.blue), // Custom icon
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedValue = newValue;
          });
        },
      ),
    );
  }

  //SEARCH PO KATEGORIJAMA (recenzije - desktop)
  String? selectedValue; // Selected item value
  List<String> items = ['Option 1', 'Option 2', 'Option 3', 'Option 4'];

  _searchByCategories() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButton<String>(
        value: selectedValue,
        hint: Text('Izaberite kategoriju'),
        dropdownColor: Colors.grey[200], // Background color of dropdown
        style: TextStyle(color: Colors.black, fontSize: 16), // Text style
        icon: Icon(Icons.arrow_drop_down, color: Colors.blue), // Custom icon
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedValue = newValue;
          });
        },
      ),
    );
  }

  List<Widget> _buildUslugaList(data) {
    if (data.length == 0) {
      return [Text("Ucitavanje...")];
    }

    List<Widget> list = data
        .map((x) => Container(
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EditRecenzijaUsluge(
                                recenzijaUsluge: x,
                              )));
                    },
                    child: x.usluga.slikaUsluge != null &&
                            x.usluga.slikaUsluge?.slika != null &&
                            x.usluga.slikaUsluge?.slika != ""
                        ? Container(
                            height: 170,
                            width: 170,
                            child: ImageFromBase64String(
                                x.usluga.slikaUsluge!.slika),
                          )
                        : Container(
                            child: Image.asset(
                              "assets/images/noImage.jpg",
                            ),
                            height: 170,
                            width: 170,
                          ),
                  ),
                  Text(x?.usluga.naziv ?? ""),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        child: Icon(
                          Icons.star,
                          color: index < x.ocjena ? Colors.amber : Colors.grey,
                          size: 20,
                        ),
                      );
                    }),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          _deleteConfirmationDialog(x, true);
                        },
                        child: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ))
        .cast<Widget>()
        .toList();

    return list;
  }

  List<Widget> _buildUsluznikList(data) {
    if (data.length == 0) {
      return [Text("Ucitavanje...")];
    }

    List<Widget> list = data
        .map((x) => Container(
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EditRecenzijaUsluznika(
                                recenzijaUsluznika: x,
                              )));
                    },
                    child: x.usluznik.korisnik.slikaProfila != null &&
                            x.usluznik.korisnik.slikaProfila?.slika != null &&
                            x.usluznik.korisnik.slikaProfila?.slika != ""
                        ? Container(
                            height: 170,
                            width: 170,
                            child: ImageFromBase64String(
                                x.usluznik.korisnik.slikaProfila!.slika),
                          )
                        : Container(
                            child: Image.asset(
                              "assets/images/noImage.jpg",
                            ),
                            height: 170,
                            width: 170,
                          ),
                  ),
                  Text(
                      "${x?.usluznik.korisnik.ime} ${x?.usluznik.korisnik.prezime}"),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        child: Icon(
                          Icons.star,
                          color: index < x.ocjena ? Colors.amber : Colors.grey,
                          size: 20,
                        ),
                      );
                    }),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          _deleteConfirmationDialog(x, false);
                        },
                        child: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ))
        .cast<Widget>()
        .toList();

    return list;
  }

  Widget _buildRecenzijeUslugaListView() {
    return Container(
      width: 800,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 550,
            child: GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 4 / 3,
                  // crossAxisSpacing: 8,
                  mainAxisSpacing: 10),
              scrollDirection: Axis.vertical,
              children: _buildUslugaList(_recenzijaUslugeResult!.result),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecenzijeUsluznikaListView() {
    return Container(
      width: 800,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 550,
            child: GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 3 / 2,
                  // crossAxisSpacing: 8,
                  mainAxisSpacing: 10),
              scrollDirection: Axis.vertical,
              children: _buildUsluznikList(_recenzijaUsluznikaResult!.result),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Moje recenzije",
      child: _tabBars(),
    );
  }

  void _deleteConfirmationDialog(e, isUsluge) {
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
                    isUsluge == true
                        ? _obrisiZapisRecenzijaUsluge(e)
                        : _obrisiZapisRecenzijaUsluznika(e);
                  },
                ),
              ],
            ));
  }

  void _obrisiZapisRecenzijaUsluge(e) async {
    var deleted = await _recenzijeUslugeProvider.delete(e.recenzijaUslugeId!);
    print('deleted? ${deleted}');

    //treba da se osvjezi lista
    var data = await _recenzijeUslugeProvider.get(filter: {
      'FTS': _ftsController1.text,
      'korisnikId': widget.korisnik!.korisnikId
    });

    setState(() {
      _recenzijaUslugeResult = data;
    });
  }

  void _obrisiZapisRecenzijaUsluznika(e) async {
    var deleted =
        await _recenzijeUsluznikaProvider.delete(e.recenzijaUsluznikaId!);
    print('deleted? ${deleted}');

    //treba da se osvjezi lista
    var data = await _recenzijeUsluznikaProvider.get(filter: {
      'FTS': _ftsController1.text,
      'korisnikId': widget.korisnik!.korisnikId
    });

    setState(() {
      _recenzijaUsluznikaResult = data;
    });
  }
}
