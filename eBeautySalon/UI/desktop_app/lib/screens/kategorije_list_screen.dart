import 'package:desktop_app/screens/kategorije_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/kategorija.dart';
import '../models/search_result.dart';
import '../providers/kategorije_provider.dart';
import '../utils/util.dart';
import '../widgets/master_screen.dart';

class KategorijeListScreen extends StatefulWidget {
  const KategorijeListScreen({super.key});

  @override
  State<KategorijeListScreen> createState() => _KategorijeListScreenState();
}

class _KategorijeListScreenState extends State<KategorijeListScreen> {
  late KategorijeProvider _kategorijeProvider;
  SearchResult<Kategorija>? result;
  TextEditingController _ftsController = new TextEditingController();
  bool isLoadingData = true;
  String? search = "";
  bool authorised = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _kategorijeProvider = context.read<KategorijeProvider>();
    getData();
  }

  void getData() async {
    var data = await _kategorijeProvider.get();

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
      if (LoggedUser.uloga == "Administrator" ||
          LoggedUser.uloga == "Uslužnik") {
        authorised = true;
      } else {
        authorised = false;
      }

      print("authorised: $authorised");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: isLoadingData == false
          ? authorised == true
              ? Column(children: [
                  _builSearch(),
                  Text("Za pretragu zapisa pritisnite dugme Traži", style: TextStyle(color: Colors.red),),
                  SizedBox(height: 3,),
                  _showResultCount(),
                  _buildDataListView()
                ])
              : buildAuthorisation()
          : Center(child: CircularProgressIndicator()),
      title: "Kategorije",
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

  Widget _builSearch() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                labelText: "šifra/naziv/opis",
                 prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  hoverColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey)
                  )
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
                print("pritisnuto dugme Dugme");

                var data = await _kategorijeProvider
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
                    builder: (context) => KategorijeDetailsScreen(
                          kategorija: null,
                        )));
              },
              child: Text("Dodaj kategoriju")),
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
              child: Text("Kategorija"),
            )),
            DataColumn(
                label: Expanded(
              child: Text("Opis"),
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
              child: Text(""),
            )),
            DataColumn(
                label: Expanded(
              child: Text(""),
            ))
          ],
          rows: result?.result
                  .map((Kategorija e) => DataRow(cells: [
                        DataCell(Text(e.sifra ?? "")),
                        DataCell(Text(e.naziv ?? "")),
                        DataCell(Text(e.opis ?? "")),
                        DataCell(Container(
                            width: 130,
                            child: Text(
                              (e.datumKreiranja == null
                                  ? "-"
                                  : formatDate(e.datumKreiranja!)),
                              textAlign: TextAlign.center,
                            ))),
                        DataCell(Container(
                            width: 130,
                            child: Text(
                                (e.datumModifikovanja == null
                                    ? "-"
                                    : formatDate(e.datumModifikovanja!)),
                                textAlign: TextAlign.center))),
                        DataCell(TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.green,
                          ),
                          child: Text("Modifikuj"),
                          onPressed: () {
                            print(
                                "modifikacija: ${e.naziv}, id: ${e.kategorijaId}");
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => KategorijeDetailsScreen(
                                      kategorija: e,
                                    )));
                          },
                        )),
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
    print("delete kategorijaId: ${e.kategorijaId}, naziv: ${e.naziv}");
    var deleted = await _kategorijeProvider.delete(e.kategorijaId);
    print('deleted? ${deleted}');

    //treba da se osvjezi lista
    var data =
        await _kategorijeProvider.get(filter: {'FTS': _ftsController.text});

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
