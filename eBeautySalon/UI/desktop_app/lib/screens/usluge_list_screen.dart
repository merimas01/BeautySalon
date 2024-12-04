import 'package:desktop_app/providers/usluge_provider.dart';
import 'package:desktop_app/screens/usluge_details_screen.dart';
import 'package:desktop_app/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/kategorija.dart';
import '../models/search_result.dart';
import '../models/usluga.dart';
import '../providers/kategorije_provider.dart';
import '../widgets/master_screen.dart';

class UslugeListScreen extends StatefulWidget {
  const UslugeListScreen({super.key});

  @override
  State<UslugeListScreen> createState() => _UslugeListScreenState();
}

class _UslugeListScreenState extends State<UslugeListScreen> {
  late UslugeProvider _uslugeProvider;
  late KategorijeProvider _kategorijeProvider;
  SearchResult<Usluga>? result;
  TextEditingController _ftsController = new TextEditingController();
  SearchResult<Kategorija>? _kategorijeResult;
  Kategorija? selectedKategorija;
  bool isLoadingKategorije = true;
  bool isLoadingData = true;
  String? search = "";
  bool? authorised = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _uslugeProvider = context.read<UslugeProvider>();
    _kategorijeProvider = context.read<KategorijeProvider>();

    getData();
  }

  void getData() async {
    var data = await _uslugeProvider.get(filter: {
      'FTS': '',
      'isSlikaIncluded': true,
    });
    var kategorije = await _kategorijeProvider.get();

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
      _kategorijeResult = kategorije;
      isLoadingKategorije = false;
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

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: Container(
        child: isLoadingData == false
            ? authorised == true
                ? Column(children: [
                    _builSearch(),
                    _showResultCount(),
                    _buildDataListView(),
                  ])
                : buildAuthorisation()
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
      title_widget: Text("Usluge"),
    );
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

  Widget _builSearch() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                labelText: "šifra/usluga/opis/cijena",
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
            width: 8,
          ),
          searchByKategorije(),
          SizedBox(width: 8),
          selectedKategorija != null
              ? TextButton(
                  onPressed: () {
                    setState(() {
                      selectedKategorija = null;
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
          SizedBox(
            width: 10,
          ),
          ElevatedButton(
              onPressed: () async {
                print("pritisnuto dugme Trazi");

                var data = await _uslugeProvider.get(filter: {
                  'FTS': _ftsController.text,
                  'kategorijaId': selectedKategorija?.kategorijaId.toString()
                });

                print(
                    "fts: ${_ftsController.text}, kategorijaId: ${selectedKategorija?.kategorijaId}");

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
                    builder: (context) => UslugeDetaljiScreen(
                          usluga: null,
                        )));
              },
              child: Text("Dodaj uslugu")),
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
              child: Text("Usluga"),
            )),
            DataColumn(
                label: Expanded(
              child: Text("Kategorija"),
            )),
            DataColumn(
                label: Expanded(
              child: Text("Cijena"),
            )),
            DataColumn(
                label: Expanded(
              child: Text("Opis"),
            )),
            DataColumn(
                label: Expanded(
              child: Text("Slika"),
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
                  .map((Usluga e) => DataRow(cells: [
                        DataCell(Text(e.sifra ?? "")),
                        DataCell(Text(e.naziv ?? "")),
                        DataCell(Text(e.kategorija!.naziv ?? "")),
                        DataCell(Text((formatNumber(e.cijena)))),
                        DataCell(Text(e.opis ?? "")),
                        DataCell(e.slikaUsluge?.slika != null
                            ? Container(
                                width: 100,
                                height: 100,
                                child:
                                    ImageFromBase64String(e.slikaUsluge!.slika),
                              )
                            : Text("")),
                        DataCell(
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.green,
                            ),
                            onPressed: () async {
                              print(
                                  "modifikuj ${e.naziv} uslugaId: ${e.uslugaId}");

                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => UslugeDetaljiScreen(
                                        usluga: e,
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
    print("delete uslugaId: ${e.uslugaId}, naziv: ${e.naziv}");
    var deleted = await _uslugeProvider.delete(e.uslugaId!);
    print('deleted? ${deleted}');

    //treba da se osvjezi lista
    var data = await _uslugeProvider.get(filter: {
      'FTS': _ftsController.text,
      'kategorijaId': selectedKategorija?.kategorijaId.toString(),
      'isSlikaIncluded': true,
    });

    print(
        "fts: ${_ftsController.text}, kategorijaId: ${selectedKategorija?.kategorijaId}");

    setState(() {
      result = data;
    });
  }

  Widget searchByKategorije() {
    print("search by kategorije");
    if (isLoadingKategorije == false) {
      return Container(
        width: 300,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey),
        ),
        child: Center(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Kategorija>(
              hint: Text("Pretraži po kategoriji"),
              value: selectedKategorija,
              isExpanded: true,
              onChanged: (Kategorija? newValue) {
                setState(() {
                  selectedKategorija = newValue;
                });
              },
              items: _kategorijeResult?.result
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
      );
    }
    return Center(child: CircularProgressIndicator());
  }
}
