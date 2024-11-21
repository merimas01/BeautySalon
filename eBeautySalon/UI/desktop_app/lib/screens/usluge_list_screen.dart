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
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: Container(
        child: Column(children: [
          _builSearch(),
          _showResultCount(),
          isLoadingData == false
              ? _buildDataListView()
              : Container(child: CircularProgressIndicator()),
        ]),
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
                labelText: "usluga/opis/cijena",
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
          Expanded(
            child: searchByKategorije(),
          ),
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
                        DataCell(
                            Container(width: 200, child: Text(e.naziv ?? ""))),
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
              title: Text('Potvrda o brisanju zapisa'),
              content: Text('Jeste li sigurni da želite izbrisati ovaj zapis?'),
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
        padding: EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey),
        ),
        child: Center(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Kategorija>(
              hint: Text("Izaberi kategoriju"),
              value: selectedKategorija,
              onChanged: (Kategorija? newValue) {
                setState(() {
                  selectedKategorija = newValue;
                });
              },
              items: _kategorijeResult?.result
                  .map<DropdownMenuItem<Kategorija>>((Kategorija service) {
                return DropdownMenuItem<Kategorija>(
                  value: service,
                  child: Text(service.naziv!),
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
