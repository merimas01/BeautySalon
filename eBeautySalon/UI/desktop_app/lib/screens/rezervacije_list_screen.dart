import 'package:desktop_app/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/rezervacija.dart';
import '../models/rezervacija_update.dart';
import '../models/search_result.dart';
import '../models/status.dart';
import '../providers/rezarvacije_provider.dart';
import '../providers/status_provider.dart';

class RezervacijeListScreen extends StatefulWidget {
  const RezervacijeListScreen({super.key});

  @override
  State<RezervacijeListScreen> createState() => _RezervacijeListScreenState();
}

class _RezervacijeListScreenState extends State<RezervacijeListScreen> {
  late RezervacijeProvider _rezervacijeProvider;
  late StatusiProvider _statusiProvider;
  SearchResult<Rezervacija>? result;
  SearchResult<Status>? _statusResult;
  SearchResult<Status>? _changeStatusiResult;
  TextEditingController _ftsController = new TextEditingController();
  bool isLoadingStatus = true;
  bool isLoadingData = true;
  bool isLoadingChangeStatusList = true;
  Status? selectedStatus;
  Status? selectedChangeStatus;
  String? search = "";

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _rezervacijeProvider = context.read<RezervacijeProvider>();
    _statusiProvider = context.read<StatusiProvider>();
    getData();
  }

  void getData() async {
    var data =
        await _rezervacijeProvider.get(filter: {'FTS': '', 'isArhiva': "ne"});
    var statusi = await _statusiProvider.get();
    var changeStatusi =
        await _statusiProvider.get(filter: {'promijeniStatus': true});

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
      _statusResult = statusi;
      isLoadingStatus = false;
      _changeStatusiResult = changeStatusi;
      isLoadingChangeStatusList = false;
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

  _showDialogSuccess() {
    showDialog(
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
  }

  _showDialogNotSelectedStatus() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text("Greška"),
              content: Text("Molimo Vas izaberite novi status."),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Shvatam"))
              ],
            ));
  }

  _showDialogServerError() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text("Greška"),
              content: Text("Greška u podacima."),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context), child: Text("Ok"))
              ],
            ));
  }

  Widget searchByStatus() {
    print("search by status");
    if (isLoadingStatus == false) {
      return Container(
        padding: EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey),
        ),
        child: Center(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Status>(
              hint: Text("Izaberi status"),
              value: selectedStatus,
              onChanged: (Status? newValue) {
                setState(() {
                  selectedStatus = newValue;
                });
              },
              items: _statusResult?.result
                  .map<DropdownMenuItem<Status>>((Status service) {
                return DropdownMenuItem<Status>(
                  value: service,
                  child: Text(service.opis!),
                );
              }).toList(),
            ),
          ),
        ),
      );
    }
    return Center(child: CircularProgressIndicator());
  }

  var dropdown_lista = [
    {'opis': 'da', 'vrijednost': true},
    {'opis': 'ne', 'vrijednost': false}
  ];

  String? selectedOpis = "ne";

  Widget _searchByIsArhiva() {
    return Container(
      width: 150,
      padding: EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      child: Center(
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedOpis,
            // isExpanded: true,
            hint: Text("Arhiva?"),
            items: dropdown_lista.map((item) {
              return DropdownMenuItem<String>(
                value: item['opis'] as String,
                child: Text(item['opis'] as String),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedOpis = value;
              });
              print(selectedOpis);
            },
          ),
        ),
      ),
    );
  }

  void _changeStatus(Rezervacija e) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text("Promijeni status rezervacije"),
              content: SingleChildScrollView(
                child: DropdownButtonHideUnderline(
                  child: DropdownButtonFormField<Status>(
                    hint: Text("Izaberi status"),
                    value: selectedChangeStatus,
                    onChanged: (Status? newValue) {
                      setState(() {
                        selectedChangeStatus = newValue;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(),
                    ),
                    items: _changeStatusiResult?.result
                        .map<DropdownMenuItem<Status>>((Status service) {
                      return DropdownMenuItem<Status>(
                        value: service,
                        child: Text(service.opis!),
                      );
                    }).toList(),
                  ),
                ),
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Odustani")),
                ElevatedButton(
                    onPressed: () async {
                      if (selectedChangeStatus != null) {
                        try {
                          var rezervacija_update = RezervacijaUpdate(
                              e.korisnikId,
                              e.uslugaId,
                              e.terminId,
                              e.datumRezervacije,
                              selectedChangeStatus?.statusId,
                              e.isArhiva);

                          var update_status = await _rezervacijeProvider.update(
                              e.rezervacijaId!, rezervacija_update);
                          Navigator.pop(context);
                          getData();
                          _showDialogSuccess();
                          selectedChangeStatus = null;
                        } catch (error) {
                          print(error.toString());
                          Navigator.pop(context);
                          _showDialogServerError();
                          selectedChangeStatus = null;
                        }
                      } else {
                        //Navigator.pop(context);
                        _showDialogNotSelectedStatus();
                        selectedChangeStatus = null;
                      }
                    },
                    child: Text("Spasi")),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: 'Rezervacije',
      child: Column(children: [
        _builSearch(),
        _showResultCount(),
        isLoadingData == false
            ? _buildDataListView()
            : Container(child: CircularProgressIndicator()),
      ]),
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
                labelText: "korisnik/usluga/termin",
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
          SizedBox(width: 8),
          _searchByIsArhiva(),
          SizedBox(width: 8),
          selectedOpis != null
              ? TextButton(
                  onPressed: () {
                    setState(() {
                      selectedOpis = null;
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
            width: 8,
          ),
          Expanded(
            child: searchByStatus(),
          ),
          SizedBox(width: 8),
          selectedStatus != null
              ? TextButton(
                  onPressed: () {
                    setState(() {
                      selectedStatus = null;
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
                print("pritisnuto dugme Traži");

                var data = await _rezervacijeProvider.get(filter: {
                  'FTS': _ftsController.text,
                  'statusId': selectedStatus?.statusId,
                  'isArhiva': selectedOpis
                });

                print(
                    "fts: ${_ftsController.text}, statusId: ${selectedStatus?.statusId}, isArhiva: ${selectedOpis}");

                setState(() {
                  result = data;
                });
              },
              child: Text("Traži")),
          SizedBox(
            width: 8,
          ),
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
              child: Text("Korisnik"),
            )),
            DataColumn(
                label: Expanded(
              child: Text("Datum rezervacije"),
            )),
            DataColumn(
                label: Expanded(
              child: Text("Termin"),
            )),
            DataColumn(
                label: Expanded(
              child: Text("Usluga"),
            )),
            DataColumn(
                label: Expanded(
              child: Text("Status"),
            )),
            DataColumn(
                label: Expanded(
              child: Text(""),
            )),
            DataColumn(
                label: Expanded(
              child: Text("Arhiva?"),
            )),
            DataColumn(
                label: Expanded(
              child: Text(""),
            ))
          ],
          rows: result?.result
                  .map((Rezervacija e) =>
                      DataRow(color: _obojiRedove(e), cells: [
                        DataCell(Container(
                            width: 100,
                            child: Text(
                                "${e.korisnik?.ime ?? ""} ${e.korisnik?.prezime ?? ""}"))),
                        DataCell(Container(
                            width: 130,
                            child: Text((e.datumRezervacije == null
                                ? "-"
                                : "${e.datumRezervacije?.day}.${e.datumRezervacije?.month}.${e.datumRezervacije?.year}")))),
                        DataCell(Text(e.termin?.opis ?? "")),
                        DataCell(Container(
                            width: 250, child: Text(e.usluga?.naziv ?? ""))),
                        DataCell(Text(e.status?.opis ?? "-")),
                        DataCell(TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.green,
                          ),
                          child: Text("Promijeni status"),
                          onPressed: () {
                            _changeStatus(e);
                          },
                        )),
                        DataCell(Container(
                          width: 50,
                          child: Text(e.isArhiva == false || e.isArhiva == null
                              ? "ne"
                              : "da"),
                        )),
                        DataCell(TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                          child: Text(
                              (e.isArhiva == false || e.isArhiva == null)
                                  ? "Arhiviraj"
                                  : "Dearhiviraj"),
                          onPressed: () {
                            _showDialogArhiviraj(e);
                          },
                        )),
                      ]))
                  .toList() ??
              []),
    ));
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
    else if (e.status?.opis == "Nova")
      return MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          return Colors.yellow[100];
        },
      );
  }

  void _showDialogArhiviraj(Rezervacija e) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: e.isArhiva == false || e.isArhiva == null
                  ? Text('Potvrda o arhiviranju rezervacije')
                  : Text('Potvrda o dearhiviranju rezervacije'),
              content: e.isArhiva == false || e.isArhiva == null
                  ? Text(
                      'Jeste li sigurni da želite arhivirati izabranu rezervaciju?')
                  : Text(
                      "Jeste li sigurni da želite dearhivirati izabranu rezervaciju?"),
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
                    _arhivirajDearhiviraj(e);
                  },
                ),
              ],
            ));
  }

  void _arhivirajDearhiviraj(e) async {
    var new_value_isArhiva = e.isArhiva == true ? false : true;
    var rezervacija_update = RezervacijaUpdate(e.korisnikId, e.uslugaId,
        e.terminId, e.datumRezervacije, e.statusId, new_value_isArhiva);
    var obj =
        await _rezervacijeProvider.update(e.rezervacijaId, rezervacija_update);
    print('status? ${obj.isArhiva}');

    selectedOpis = null;
    var data =
        await _rezervacijeProvider.get(filter: {'FTS': _ftsController.text});

    setState(() {
      result = data;
    });
  }
}
