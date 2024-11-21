import 'package:desktop_app/models/usluga.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/search_result.dart';
import '../models/termin.dart';
import '../models/termin_insert_update.dart';
import '../models/usluga_termin.dart';
import '../models/usluga_termin_insert.dart';
import '../models/usluga_termin_update.dart';
import '../providers/termini_provider.dart';
import '../providers/usluge_provider.dart';
import '../providers/usluge_termini_provider.dart';
import '../widgets/master_screen.dart';

class UslugeTerminiListScreen extends StatefulWidget {
  const UslugeTerminiListScreen({super.key});

  @override
  State<UslugeTerminiListScreen> createState() =>
      _UslugeTerminiListScreenState();
}

class _UslugeTerminiListScreenState extends State<UslugeTerminiListScreen> {
  late TerminProvider _terminiProvider;
  late UslugeTerminiProvider _uslugeTerminiProvider;
  late UslugeProvider _uslugeProvider;
  SearchResult<UslugaTermin>? _uslugaTerminResult;
  SearchResult<Usluga>? _uslugaResult;
  SearchResult<Termin>? _terminiResult;
  TextEditingController inputTerminController = TextEditingController();
  bool showErrorMessage = false;
  bool switchPrikazan = true;
  String? selectedUsluga;
  String? selectedTermin;
  String? selectedTerminOpis;
  bool? kliknuoDodajDrugiTermin = false;
  UslugaTermin? uslugaTermin;
  bool isLoadingUsluge = true;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    _terminiProvider = context.read<TerminProvider>();
    _uslugeTerminiProvider = context.read<UslugeTerminiProvider>();
    _uslugeProvider = context.read<UslugeProvider>();

    initForm();
  }

  initForm() async {
    _uslugaResult = await _uslugeProvider.get();
    _terminiResult = await _terminiProvider.get();

    setState(() {
      isLoadingUsluge = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          _builSearch(),
          _showResultCount(),
          SizedBox(
            height: 10,
          ),
          isLoadingUsluge == false
              ? _buildDataListView()
              : Center(child: CircularProgressIndicator()),
        ]),
      ),
      title: "Termini",
    );
  }

  getUslugaTermine() async {
    var data =
        await _uslugeTerminiProvider.get(filter: {'uslugaId': selectedUsluga});

    print("uslugaId: ${selectedUsluga}");

    setState(() {
      _uslugaTerminResult = data;
    });
  }

  Widget _builSearch() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
          SizedBox(
            width: 10,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedUsluga,
                hint: Text('Izaberite uslugu'),
                items: _uslugaResult?.result.map((Usluga item) {
                  return DropdownMenuItem<String>(
                    value: item.uslugaId.toString(),
                    child: Text(item.naziv ?? ""),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    showErrorMessage = false;
                    selectedUsluga = newValue;
                    getUslugaTermine();
                  });
                },
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          SizedBox(
            height: 40,
            width: 300,
            child: ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(color: Colors.pink)))),
              onPressed: () async {
                kliknuoDodajDrugiTermin = false;
                if (selectedUsluga == null) {
                  setState(() {
                    showErrorMessage = true;
                  });
                } else {
                  _showDialog(context);
                }
              },
              child: Text("Dodaj novi termin za izabranu uslugu",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          showErrorMessage == true
              ? Text(
                  "Molimo vas odaberite uslugu.",
                  style: TextStyle(color: Colors.red),
                )
              : Container(),
        ],
      ),
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
                'Broj rezultata: ${selectedUsluga == null || _uslugaTerminResult?.result == null ? 0 : _uslugaTerminResult?.count}',
            style: TextStyle(fontWeight: FontWeight.normal),
          )
        ]));
  }

  Widget _buildDataListView() {
    return selectedUsluga != null
        ? Expanded(
            child: SingleChildScrollView(
            child: DataTable(
                columns: [
                  DataColumn(
                      label: Expanded(
                    child: Text("Termin"),
                  )),
                  DataColumn(
                      label: Expanded(
                    child: Text("Prikaži termin korisniku?"),
                  ))
                ],
                rows: _uslugaTerminResult?.result
                        .map((UslugaTermin e) => DataRow(cells: [
                              DataCell(Text(e.termin?.opis ?? "")),
                              DataCell(Center(
                                child: Switch(
                                  value: e.isPrikazan == null
                                      ? true
                                      : e.isPrikazan!,
                                  activeColor: Color.fromARGB(255, 1, 2, 1),
                                  onChanged: (bool value) {
                                    setState(() {
                                      e.isPrikazan = value;
                                      switchPrikazan = value;
                                    });
                                    _updateUslugaTermin(e);
                                  },
                                ),
                              ))
                            ]))
                        .toList() ??
                    []),
          ))
        : Container();
  }

  void _updateUslugaTermin(UslugaTermin e) async {
    print("id: ${e.uslugaTerminId}");
    var obj = await _uslugeTerminiProvider.update(e.uslugaTerminId!,
        UslugaTerminUpdate(e.uslugaId, e.terminId, switchPrikazan));
    print("obj: ${obj.isPrikazan}");
    //treba da se osvjezi lista
    var data =
        await _uslugeTerminiProvider.get(filter: {'uslugaId': selectedUsluga});
    setState(() {
      _uslugaTerminResult = data;
    });
  }

  void _insertUslugaTermin() async {
    if (selectedUsluga != null && selectedTermin != null) {
      if (kliknuoDodajDrugiTermin == false) {
        try {
          var obj_uslugaTermin = UslugaTerminInsert(
              int.parse(selectedUsluga!), int.parse(selectedTermin!));
          var uslugaTerminInsert =
              await _uslugeTerminiProvider.insert(obj_uslugaTermin);
          print("${uslugaTerminInsert.termin?.opis}");

          await showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                    title: Text("Informacija o uspjehu"),
                    content: Text("Uspješno izvršena akcija!"),
                    actions: <Widget>[
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Ok"))
                    ],
                  ));
        } catch (e) {
          await showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                    title: Text("Greška"),
                    content: Text(
                        "Neispravni podaci. Molimo pokušajte ponovo. Svaki zapis treba imati unikatne vrijednosti (izabrani termin možda već postoji za datu uslugu)"),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("Ok"))
                    ],
                  ));
        }
      }
      //osvjezi listu
      var data = await _uslugeTerminiProvider
          .get(filter: {'uslugaId': selectedUsluga});
      setState(() {
        _uslugaTerminResult = data;
      });
    }
  }

  void _insertTermin() async {
    if (selectedUsluga != null) {
      if (kliknuoDodajDrugiTermin == true) {
        if (selectedTerminOpis != null) {
          try {
            var obj_termin = TerminInsertUpdate(selectedTerminOpis);
            var terminInsert = await _terminiProvider.insert(obj_termin);
            print("${terminInsert.opis}");

            //dodati uslugatermin objekat (terminid= obj_termin.id)
            if (terminInsert != null) {
              var termin = terminInsert.terminId;
              var obj_uslugaTermin =
                  UslugaTerminInsert(int.parse(selectedUsluga!), termin);
              var uslugaTerminInsert =
                  await _uslugeTerminiProvider.insert(obj_uslugaTermin);
              print("${uslugaTerminInsert.termin?.opis}");
            }

            await showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      title: Text("Informacija o uspjehu"),
                      content: Text("Uspješno izvršena akcija!"),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Ok"))
                      ],
                    ));
          } catch (e) {
            await showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      title: Text("Greška"),
                      content: Text(
                          "Neispravni podaci. Molimo pokušajte ponovo. Svaki zapis treba imati unikatne vrijednosti i termin treba biti u formatu ##:##"),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("Ok"))
                      ],
                    ));
          }
        }
      }
      //osvjezi listu
      var data = await _uslugeTerminiProvider
          .get(filter: {'uslugaId': selectedUsluga});
      var termini = await _terminiProvider.get();
      setState(() {
        _uslugaTerminResult = data;
        _terminiResult = termini;
      });
    }
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Izaberite novi termin za odabranu uslugu'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return DropdownButton<String>(
                hint: Text("Izaberite termin"),
                value: selectedTermin,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedTermin = newValue;
                  });
                },
                items: _terminiResult?.result.map((Termin item) {
                  return DropdownMenuItem<String>(
                    value: item.terminId.toString(),
                    child: Text(item.opis ?? ""),
                  );
                }).toList(),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                kliknuoDodajDrugiTermin = false;
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Otkaži'),
            ),
            TextButton(
              onPressed: () {
                // Handle selection
                kliknuoDodajDrugiTermin = true;
                Navigator.of(context).pop(); // Close the dialog
                _showInputTerminDialog(context);
              },
              child: Text('Dodaj drugi termin?'),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle selection
                kliknuoDodajDrugiTermin = false;
                print('Selected value: $selectedTermin');
                Navigator.of(context).pop(); // Close the dialog
                _insertUslugaTermin();
              },
              child: Text('Spasi'),
            ),
          ],
        );
      },
    );
  }

  void _showInputTerminDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Unesite novi termin'),
          content: TextField(
            controller: inputTerminController,
            decoration: InputDecoration(
              hintText: "primjer: 10:00",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                inputTerminController.text = "";
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Otkaži'),
            ),
            ElevatedButton(
              onPressed: () {
                // Retrieve the input text and handle it
                print('Input: ${inputTerminController.text}');
                setState(() {
                  selectedTerminOpis = inputTerminController.text;
                });
                Navigator.of(context).pop(); // Close the dialog
                _insertTermin();
                inputTerminController.text = "";
              },
              child: Text('Spasi novi termin'),
            ),
          ],
        );
      },
    );
  }
}
