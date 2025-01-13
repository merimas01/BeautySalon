import 'package:desktop_app/models/novost.dart';
import 'package:desktop_app/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/search_result.dart';
import '../providers/novosti_provider.dart';
import '../utils/util.dart';
import 'novosti_details_screen.dart';

class NovostiListScreen extends StatefulWidget {
  const NovostiListScreen({super.key});

  @override
  State<NovostiListScreen> createState() => _NovostiListScreenState();
}

class _NovostiListScreenState extends State<NovostiListScreen> {
  late NovostiProvider _novostiProvider;
  SearchResult<Novost>? result;
  TextEditingController _ftsController = new TextEditingController();
  bool isLoadingData = true;
  String? search = "";
  bool authorised = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _novostiProvider = context.read<NovostiProvider>();
    getData();
  }

  void getData() async {
    var data = await _novostiProvider.get(filter: {'FTS': ''});

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

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Novosti",
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
          : Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                labelText: "šifra/naslov/sadržaj",
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
          ElevatedButton(
              onPressed: () async {
                print("pritisnuto dugme Trazi");

                var data = await _novostiProvider
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
                    builder: (context) => NovostiDetailsScreen(
                          novost: null,
                        )));
              },
              child: Text("Dodaj novost")),
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
              child: Text("Naslov"),
            )),
            DataColumn(
                label: Expanded(
              child: Text("Slika"),
            )),
            DataColumn(
                label: Expanded(
              child: Text("Sadržaj"),
            )),
            DataColumn(
                label: Expanded(
              child: Text("Datum izmjene"),
            )),
            DataColumn(
                label: Expanded(
              child: Text("Autor"),
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
                  .map((Novost e) => DataRow(cells: [
                        DataCell(Text(e.sifra ?? "")),
                        DataCell(Text(e.naslov ?? "")),
                        DataCell(e.slikaNovost?.slika != null &&
                                e.slikaNovost?.slika != ""
                            ? Container(
                                width: 100,
                                height: 100,
                                child:
                                    ImageFromBase64String(e.slikaNovost!.slika),
                              )
                            : Container(
                                child: Image.asset(
                                "assets/images/noImage.jpg",
                                height: 250,
                                width: 100,
                              ))),
                        DataCell(Text(e.sadrzaj ?? "")),
                        DataCell(Container(
                            width: 130,
                            child: e.datumModificiranja == null
                                ? Text(formatDate(e.datumKreiranja!))
                                : Text(
                                    formatDate(e.datumModificiranja!),
                                    textAlign: TextAlign.center,
                                  ))),
                        DataCell(Container(
                          child:
                              Text("${e.korisnik?.ime} ${e.korisnik?.prezime}"),
                        )),
                        DataCell(
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.green,
                            ),
                            onPressed: () async {
                              print(
                                  "modifikuj ${e.naslov} novostId: ${e.novostId}");

                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => NovostiDetailsScreen(
                                        novost: e,
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
    print("delete novostId: ${e.novostId}, naslov: ${e.naslov}");
    var deleted = await _novostiProvider.delete(e.novostId!);
    print('deleted? ${deleted}');

    //treba da se osvjezi lista
    var data = await _novostiProvider.get(filter: {'FTS': _ftsController.text});

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
