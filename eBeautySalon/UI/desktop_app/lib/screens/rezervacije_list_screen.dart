import 'package:desktop_app/utils/constants.dart';
import 'package:desktop_app/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/rezervacija.dart';
import '../models/rezervacija_update.dart';
import '../models/search_result.dart';
import '../models/status.dart';
import '../providers/rezarvacije_provider.dart';
import '../providers/status_provider.dart';
import '../utils/util.dart';

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
  bool authorised = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _rezervacijeProvider = context.read<RezervacijeProvider>();
    _statusiProvider = context.read<StatusiProvider>();
    getData();
  }

  void getData() async {
    var del = await _rezervacijeProvider.DeleteUnpaidReservactions();
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

    setState(() {
      if (LoggedUser.uloga == "Administrator" ||
          LoggedUser.uloga == "Rezervacioner") {
        authorised = true;
      } else {
        authorised = false;
      }

      print("authorised: $authorised");
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
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.pink),
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
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.pink),
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
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.pink),
                    onPressed: () => Navigator.pop(context),
                    child: Text("Ok"))
              ],
            ));
  }

  Widget searchByStatus() {
    print("search by status");
    if (isLoadingStatus == false) {
      return Container(
        width: 300,
        height: 55,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey),
        ),
        child: Center(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Status>(
              hint: Text("Pretraži po statusu"),
              value: selectedStatus,
              isExpanded: true,
              onChanged: (Status? newValue) {
                setState(() {
                  selectedStatus = newValue;
                });
              },
              items: _statusResult?.result
                  .map<DropdownMenuItem<Status>>((Status service) {
                return DropdownMenuItem<Status>(
                  value: service,
                  child: Text(
                    service.opis!,
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

  var dropdown_lista = [
    {'vrijednost': 'da', 'opis': 'jest arhiva'},
    {'vrijednost': 'ne', 'opis': 'nije arhiva'}
  ];

  String? selectedOpis = "ne";

  Widget _searchByIsArhiva() {
    return Container(
      width: 150,
      height: 55,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
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
                value: item['vrijednost'] as String,
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
              title: Text("Promijeni status rezervacije: ${e.sifra}"),
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
                ElevatedButton(
                  child: Text('Odustani'),
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.grey),
                  onPressed: () {
                    selectedChangeStatus = null;
                    Navigator.of(context).pop(); //zatvori dijalog
                  },
                ),
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
                              e.isArhiva,
                              e.platio);

                          var update_status = await _rezervacijeProvider.update(
                              e.rezervacijaId!, rezervacija_update);
                          Navigator.pop(context);
                          var data = await _rezervacijeProvider.get(
                              filter: {'FTS': '', 'isArhiva': selectedOpis});
                          setState(() {
                            result = data;
                            selectedChangeStatus = null;
                          });
                          _showDialogSuccess();
                        } catch (error) {
                          print(error.toString());
                          Navigator.pop(context);
                          _showDialogServerError();
                          selectedChangeStatus = null;
                        }
                      } else {
                        _showDialogNotSelectedStatus();
                        selectedChangeStatus = null;
                      }
                    },
                    child: Text("Spasi")),
              ],
            ));
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
        title: 'Rezervacije',
        child: isLoadingData == false
            ? authorised == true
                ? Column(children: [
                    _builSearch(),
                    _showResultCount(),
                    _buildDataListView()
                  ])
                : buildAuthorisation()
            : Center(
                child: CircularProgressIndicator(),
              ));
  }

  Widget _builSearch() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                  labelText: "šifra/korisnik/usluga/termin",
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
          searchByStatus(),
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

          // ElevatedButton(
          //   style: TextButton.styleFrom(
          //       foregroundColor: Colors.pink, backgroundColor: Colors.white),
          //   onPressed: () => _selectDate(context),
          //   child: Text(_selectedDate == null
          //       ? 'Izaberi datum'
          //       : formatDate(_selectedDate!)),
          // ),
          // SizedBox(
          //   width: 8,
          // ),
          // _selectedDate != null
          //     ? TextButton(
          //         onPressed: () {
          //           setState(() {
          //             _selectedDate = null;
          //           });
          //         },
          //         child: Tooltip(
          //           child: Icon(
          //             Icons.close,
          //             color: Colors.red,
          //           ),
          //           message: "Poništi datum",
          //         ),
          //       )
          //     : Container(),
          // SizedBox(width: 10),
          ElevatedButton(
              onPressed: () async {
                print("pritisnuto dugme Traži");

                var data = await _rezervacijeProvider.get(filter: {
                  'FTS': _ftsController.text,
                  'statusId': selectedStatus?.statusId,
                  'isArhiva': selectedOpis
                });

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
              child: Text("Šifra"),
            )),
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
                        DataCell(Text(e.sifra ?? "")),
                        DataCell(Text(
                            "${e.korisnik?.ime ?? ""} ${e.korisnik?.prezime ?? ""}")),
                        DataCell(Container(
                            width: 130,
                            child: Text((e.datumRezervacije == null
                                ? "-"
                                : formatDate(e.datumRezervacije!))))),
                        DataCell(Text(e.termin?.opis ?? "")),
                        DataCell(Text(e.usluga?.naziv ?? "")),
                        DataCell(Text(e.status?.opis ?? "-")),
                        DataCell(e.status?.opis == "Nova"
                            ? TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.green,
                                ),
                                child: Text("Promijeni status"),
                                onPressed: () {
                                  _changeStatus(e);
                                },
                              )
                            : e.status?.opis == "Prihvaćena"
                                ? TextButton(
                                    style: TextButton.styleFrom(
                                      foregroundColor:
                                          Color.fromARGB(255, 162, 12, 62),
                                    ),
                                    child: Text("Završi narudžbu"),
                                    onPressed: () {
                                      _showDialogEndReservation(e);
                                    },
                                  )
                                : Container()),
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
    if (e.status?.opis == "Prihvaćena")
      return MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          return Colors.green[100];
        },
      );
    else if (e.status?.opis == "Odbijena")
      return MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        return Colors.red[100];
      });
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

  void _showDialogArhiviraj(Rezervacija e) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: e.isArhiva == false || e.isArhiva == null
                  ? Text(
                      'Potvrda o arhiviranju rezervacije: ${e.sifra}',
                      textAlign: TextAlign.center,
                    )
                  : Text(
                      'Potvrda o dearhiviranju rezervacije: ${e.sifra}',
                      textAlign: TextAlign.center,
                    ),
              content: e.isArhiva == false || e.isArhiva == null
                  ? Text(
                      'Jeste li sigurni da želite arhivirati izabranu rezervaciju?',
                      textAlign: TextAlign.center,
                    )
                  : Text(
                      "Jeste li sigurni da želite dearhivirati izabranu rezervaciju?",
                      textAlign: TextAlign.center,
                    ),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.grey),
                  child: Text('Ne'),
                  onPressed: () {
                    Navigator.of(context).pop(); //zatvori dijalog
                  },
                ),
                TextButton(
                  child: Text('Da'),
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red),
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
    var rezervacija_update = RezervacijaUpdate(
        e.korisnikId,
        e.uslugaId,
        e.terminId,
        e.datumRezervacije,
        e.statusId,
        new_value_isArhiva,
        e.platio);
    try {
      var obj = await _rezervacijeProvider.update(
          e.rezervacijaId, rezervacija_update);
      print('arhiva? ${obj.isArhiva}');
    } catch (err) {
      print(err.toString());
    }

    var data = await _rezervacijeProvider
        .get(filter: {'FTS': _ftsController.text, 'isArhiva': selectedOpis});

    setState(() {
      result = data;
    });
  }

  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000), // Minimum selectable date
      lastDate: DateTime(2100), // Maximum selectable date
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _showDialogEndReservation(Rezervacija e) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text(
                'Potvrda o završavanju rezervacije: ${e.sifra}',
                textAlign: TextAlign.center,
              ),
              content: Text(
                "Jeste li sigurni da želite završiti izabranu rezervaciju?",
                textAlign: TextAlign.center,
              ),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.grey),
                  child: Text('Ne'),
                  onPressed: () {
                    Navigator.of(context).pop(); //zatvori dijalog
                  },
                ),
                TextButton(
                  child: Text('Da'),
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red),
                  onPressed: () async {
                    Navigator.of(context).pop(); //zatvori dijalog
                    _EndReservation(e);
                  },
                ),
              ],
            ));
  }

  void _EndReservation(Rezervacija e) async {
    try {
      var rezervacija_update = RezervacijaUpdate(
          e.korisnikId,
          e.uslugaId,
          e.terminId,
          e.datumRezervacije,
          DEFAULT_Zavrsena_Statusid,
          e.isArhiva,
          e.platio);

      var update_status = await _rezervacijeProvider.update(
          e.rezervacijaId!, rezervacija_update);
      print(selectedOpis);
      var data = await _rezervacijeProvider
          .get(filter: {'FTS': '', 'isArhiva': selectedOpis});
      setState(() {
        result = data;
      });
      _showDialogSuccess();
    } catch (error) {
      print(error.toString());
      _showDialogServerError();
    }
  }
}
