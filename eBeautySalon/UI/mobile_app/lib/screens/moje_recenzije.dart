import 'package:flutter/material.dart';
import 'package:mobile_app/screens/profil_page.dart';
import 'package:mobile_app/widgets/master_screen.dart';
import 'package:provider/provider.dart';

import '../models/kategorija.dart';
import '../models/recenzija_usluge.dart';
import '../models/recenzija_usluznika.dart';
import '../models/search_result.dart';
import '../models/usluga.dart';
import '../providers/kategorije_provider.dart';
import '../providers/recenzije_usluga_provider.dart';
import '../providers/recenzije_usluznika_provider.dart';
import '../providers/usluge_provider.dart';
import '../utils/util.dart';
import 'edit_recenzija_usluge.dart';
import 'edit_recenzija_usluznika.dart';

class MojeRecenzije extends StatefulWidget {
  MojeRecenzije({super.key});

  @override
  State<MojeRecenzije> createState() => _MojeRecenzijeState();
}

class _MojeRecenzijeState extends State<MojeRecenzije> {
  late RecenzijaUslugeProvider _recenzijeUslugeProvider;
  late RecenzijaUsluznikaProvider _recenzijeUsluznikaProvider;
  late KategorijeProvider _kategorijaProvider;
  late UslugeProvider _uslugeProvider;
  SearchResult<RecenzijaUsluge>? _recenzijaUslugeResult;
  SearchResult<RecenzijaUsluznika>? _recenzijaUsluznikaResult;
  bool isLoadingData = true;
  String? search1 = "";
  String? search2 = "";
  Kategorija? selectedKategorija;
  SearchResult<Kategorija>? _kategorije;
  Usluga? selectedUsluga;
  SearchResult<Usluga>? _usluge;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _recenzijeUslugeProvider = context.read<RecenzijaUslugeProvider>();
    _recenzijeUsluznikaProvider = context.read<RecenzijaUsluznikaProvider>();
    _kategorijaProvider = context.read<KategorijeProvider>();
    _uslugeProvider = context.read<UslugeProvider>();
    getData();
  }

  void getData() async {
    var recenzijeUsluge = await _recenzijeUslugeProvider.get(filter: {
      'korisnikId': LoggedUser.id,
    });
    var recenzijeUsluznika = await _recenzijeUsluznikaProvider.get(filter: {
      'korisnikId': LoggedUser.id,
    });

    var kategorije = await _kategorijaProvider.get();
    var usluge = await _uslugeProvider.get();

    setState(() {
      _recenzijaUslugeResult = recenzijeUsluge;
      _recenzijaUsluznikaResult = recenzijeUsluznika;
      isLoadingData = false;
      _kategorije = kategorije;
      _usluge = usluge;
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
                      isLoadingData == false
                          ? SingleChildScrollView(
                              child: Column(
                                children: [
                                  dugmeNazad(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Row(
                                        children: [
                                          _searchByKategorija(),
                                          SizedBox(width: 8),
                                          selectedKategorija != null
                                              ? TextButton(
                                                  onPressed: () async {
                                                    setState(() {
                                                      selectedKategorija = null;
                                                    });
                                                    var recenzijeUsluge =
                                                        await _recenzijeUslugeProvider
                                                            .get(filter: {
                                                      'korisnikId':
                                                          LoggedUser.id,
                                                      'kategorijaId': null
                                                    });

                                                    setState(() {
                                                      _recenzijaUslugeResult =
                                                          recenzijeUsluge;
                                                    });
                                                  },
                                                  child: Tooltip(
                                                    child: Icon(
                                                      Icons.close,
                                                      color: Colors.red,
                                                    ),
                                                    message:
                                                        "Poništi selekciju",
                                                  ),
                                                )
                                              : Container(),
                                        ],
                                      ),
                                    ],
                                  ),
                                  _buildRecenzijeUslugaListView()
                                ],
                              ),
                            )
                          : Container(
                              child: CircularProgressIndicator(),
                            ),
                      isLoadingData == false
                          ? SingleChildScrollView(
                              child: Column(children: [
                                dugmeNazad(),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Row(
                                        children: [
                                          _searchByUsluga(),
                                          SizedBox(width: 8),
                                          selectedUsluga != null
                                              ? TextButton(
                                                  onPressed: () async {
                                                    setState(() {
                                                      selectedUsluga = null;
                                                    });
                                                    var recenzijeUsluznika =
                                                        await _recenzijeUsluznikaProvider
                                                            .get(filter: {
                                                      'korisnikId':
                                                          LoggedUser.id,
                                                      'uslugaId': null
                                                    });

                                                    setState(() {
                                                      _recenzijaUsluznikaResult =
                                                          recenzijeUsluznika;
                                                    });
                                                  },
                                                  child: Tooltip(
                                                    child: Icon(
                                                      Icons.close,
                                                      color: Colors.red,
                                                    ),
                                                    message:
                                                        "Poništi selekciju",
                                                  ),
                                                )
                                              : Container()
                                        ],
                                      ),
                                    ]),
                                _buildRecenzijeUsluznikaListView()
                              ]),
                            )
                          : Container(
                              child: CircularProgressIndicator(),
                            ),
                    ],
                  ),
                ),
              ],
            )));
  }

  _searchByKategorija() {
    if (isLoadingData == false) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          width: 250,
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey),
          ),
          child: Center(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<Kategorija>(
                hint: Text("Pretraži po kategoriji usluga"),
                value: selectedKategorija,
                isExpanded: true,
                onChanged: (Kategorija? newValue) async {
                  setState(() {
                    selectedKategorija = newValue;
                    print(selectedKategorija?.naziv);
                  });

                  var recenzijeUsluge = await _recenzijeUslugeProvider.get(
                      filter: {
                        'korisnikId': LoggedUser.id,
                        'kategorijaId': newValue?.kategorijaId
                      });

                  setState(() {
                    _recenzijaUslugeResult = recenzijeUsluge;
                  });
                },
                items: _kategorije?.result
                    .map<DropdownMenuItem<Kategorija>>((Kategorija service) {
                  return DropdownMenuItem<Kategorija>(
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
        ),
      );
    }
    return Container(child: CircularProgressIndicator());
  }

  Widget _searchByUsluga() {
    if (isLoadingData == false) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          width: 250,
          padding: EdgeInsets.symmetric(horizontal: 10),
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
                onChanged: (Usluga? newValue) async {
                  setState(() {
                    selectedUsluga = newValue;
                    print(selectedUsluga?.naziv);
                  });
                  var recenzijeUsluznika = await _recenzijeUsluznikaProvider
                      .get(filter: {
                    'korisnikId': LoggedUser.id,
                    'uslugaId': newValue?.uslugaId
                  });

                  setState(() {
                    _recenzijaUsluznikaResult = recenzijeUsluznika;
                  });
                },
                items: _usluge?.result
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
        ),
      );
    }
    return Container(child: CircularProgressIndicator());
  }

  Widget noResultsWidget() {
    return Container(
      width: 300,
      height: 300,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          "Ups!",
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(
          height: 20,
        ),
        Text("Nije pronađen nijedan zapis. 😔", style: TextStyle(fontSize: 16))
      ]),
    );
  }

  List<Widget> _buildUslugaList(data) {
    if (data.length == 0) {
      return [noResultsWidget()];
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
                                poslaniKorisnikId: LoggedUser.id,
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
      return [noResultsWidget()];
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
                                poslaniKorisnikId: LoggedUser.id,
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
    var data = await _recenzijeUslugeProvider
        .get(filter: {'korisnikId': LoggedUser.id});

    setState(() {
      _recenzijaUslugeResult = data;
    });
  }

  void _obrisiZapisRecenzijaUsluznika(e) async {
    var deleted =
        await _recenzijeUsluznikaProvider.delete(e.recenzijaUsluznikaId!);
    print('deleted? ${deleted}');

    //treba da se osvjezi lista
    var data = await _recenzijeUsluznikaProvider
        .get(filter: {'korisnikId': LoggedUser.id});

    setState(() {
      _recenzijaUsluznikaResult = data;
    });
  }

  dugmeNazad() {
    return Row(
      children: [
        TextButton(
            onPressed: () {
              {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ProfilPage()));
              }
            },
            child: Icon(Icons.arrow_back)),
      ],
    );
  }
}
