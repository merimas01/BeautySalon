import 'package:desktop_app/screens/zaposlenici_details_screen.dart';
import 'package:desktop_app/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/korisnik_uloga.dart';
import '../models/search_result.dart';
import '../models/uloga.dart';
import '../models/usluga.dart';
import '../models/zaposlenik.dart';
import '../models/zaposlenik_usluga.dart';
import '../providers/uloge_provider.dart';
import '../providers/usluge_provider.dart';
import '../providers/zaposlenici_provider.dart';
import '../utils/util.dart';

class ZaposleniciListScreen extends StatefulWidget {
  const ZaposleniciListScreen({super.key});

  @override
  State<ZaposleniciListScreen> createState() => _ZaposleniciListScreenState();
}

class _ZaposleniciListScreenState extends State<ZaposleniciListScreen> {
  late ZaposleniciProvider _zaposleniciProvider;
  late UslugeProvider _uslugeProvider;
  late UlogeProvider _ulogeProvider;
  bool isLoadingData = true;
  SearchResult<Zaposlenik>? result;
  SearchResult<Usluga>? _uslugeResult;
  SearchResult<Uloga>? _ulogeResult;
  TextEditingController _ftsController = new TextEditingController();
  String? search = "";
  Usluga? selectedUsluga;
  Uloga? selectedUloga;
  bool isLoadingUsluge = true;
  bool isLoadingUloge = true;
  bool authorised = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _zaposleniciProvider = context.read<ZaposleniciProvider>();
    _uslugeProvider = context.read<UslugeProvider>();
    _ulogeProvider = context.read<UlogeProvider>();
    getData();
    getUsluge();
    getUloge();
  }

  void getData() async {
    var data = await _zaposleniciProvider.get(filter: {'FTS': ''});

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
      if (LoggedUser.uloga != "Administrator") {
        authorised = false;
      } else {
        authorised = true;
      }

      print("authorised: $authorised");
    });
  }

  getUsluge() async {
    var usluge = await _uslugeProvider.get();
    setState(() {
      _uslugeResult = usluge;
      isLoadingUsluge = false;
    });
  }

  getUloge() async {
    var uloge = await _ulogeProvider.get();
    setState(() {
      _ulogeResult = uloge;
      isLoadingUloge = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: Container(
        child: isLoadingData == false
            ? authorised == true
                ? Column(children: [
                    _builSearch(),
                    Text(
                      "Za pretragu zapisa pritisnite dugme Traži",
                      style: TextStyle(color: Colors.red),
                    ),
                    SizedBox(height: 3,),
                    _showResultCount(),
                    _buildDataListView()
                  ])
                : buildAuthorisation()
            : Center(child: CircularProgressIndicator()),
      ),
      title_widget: Text("Zaposlenici"),
    );
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

  Widget searchByUsluga() {
    print("search by usluga");
    if (isLoadingUsluge == false) {
      return Container(
        width: 350,
        height: 55,
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

  Widget searchByUloga() {
    print("search by uloga");
    if (isLoadingUloge == false) {
      return Container(
        width: 200,
        height: 55,
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey),
        ),
        child: Center(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Uloga>(
              hint: Text("Pretraži po ulozi"),
              value: selectedUloga,
              isExpanded: true,
              onChanged: (Uloga? newValue) {
                setState(() {
                  selectedUloga = newValue;
                  print(selectedUloga?.naziv);
                });
              },
              items: _ulogeResult?.result
                  .map<DropdownMenuItem<Uloga>>((Uloga service) {
                return DropdownMenuItem<Uloga>(
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

  Widget _builSearch() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                  labelText: "šifra/ime/prezime/korisničko ime",
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  hoverColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey))),
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
          SizedBox(width: 8),
          searchByUloga(),
          SizedBox(width: 8),
          selectedUloga != null
              ? TextButton(
                  onPressed: () {
                    setState(() {
                      selectedUloga = null;
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
                print("pritisnuto dugme Trazi");

                var data = await _zaposleniciProvider.get(filter: {
                  'FTS': _ftsController.text,
                  'uslugaId': selectedUsluga?.uslugaId,
                  'ulogaId': selectedUloga?.ulogaId,
                });

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
              child: Text("Šifra"),
            )),
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
                        DataCell(Text(e.korisnik?.sifra ?? "")),
                        DataCell(
                            Text("${e.korisnik?.ime} ${e.korisnik?.prezime}")),
                        DataCell(e.korisnik?.slikaProfila?.slika != null &&
                                e.korisnik?.slikaProfila?.slika != ""
                            ? Container(
                                width: 50,
                                child: ImageFromBase64String(
                                    e.korisnik!.slikaProfila!.slika),
                              )
                            : Image.asset(
                                width: 50,
                                "assets/images/noImage.jpg",
                                gaplessPlayback: true
                              )),
                        DataCell(_zaduzenZa(
                            e.zaposlenikUslugas, e.korisnik?.korisnikUlogas)),
                        DataCell(
                            Text(joinUlogaNaziv(e.korisnik?.korisnikUlogas))),
                        DataCell(Text(e.korisnik?.email ?? "")),
                        DataCell(Container(
                            width: 120,
                            child: Text(
                              (e.datumZaposlenja == null
                                  ? "-"
                                  : formatDate(e.datumZaposlenja!)),
                              textAlign: TextAlign.center,
                            ))),
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
    print("delete id: ${e.zaposlenikId}");
    var deleted = await _zaposleniciProvider.delete(e.zaposlenikId!);
    print('deleted? ${deleted}');

    //treba da se osvjezi lista
    var data = await _zaposleniciProvider.get(filter: {
      'FTS': _ftsController.text,
      'uslugaId': selectedUsluga?.uslugaId,
      'ulogaId': selectedUloga?.ulogaId,
    });

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
