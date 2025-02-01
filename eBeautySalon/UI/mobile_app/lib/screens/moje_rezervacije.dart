import 'package:flutter/material.dart';
import 'package:mobile_app/models/rezervacija_update.dart';
import 'package:mobile_app/providers/status_provider.dart';
import 'package:mobile_app/screens/rezervacija_details.dart';
import 'package:mobile_app/widgets/master_screen.dart';
import 'package:provider/provider.dart';

import '../models/rezervacija.dart';
import '../models/search_result.dart';
import '../models/status.dart';
import '../providers/rezervacije_provider.dart';
import '../utils/util.dart';

class MojeRezervacije extends StatefulWidget {
  MojeRezervacije({super.key});

  @override
  State<MojeRezervacije> createState() => _MojeRezervacijeState();
}

class _MojeRezervacijeState extends State<MojeRezervacije> {
  late RezervacijeProvider _rezervacijeProvider;
  late StatusiProvider _statusiProvider;
  SearchResult<Rezervacija>? _rezervacijeResult;
  bool isLoadingData = true;
  SearchResult<Status>? _statusResult;
  Status? selectedStatus;
  bool filterData = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _rezervacijeProvider = context.read<RezervacijeProvider>();
    _statusiProvider = context.read<StatusiProvider>();
    getData();
  }

  void getData() async {
    var rezervacije = await _rezervacijeProvider
        .get(filter: {'FTS': "", 'korisnikId': LoggedUser.id});
    var statusi = await _statusiProvider.get();
    setState(() {
      _rezervacijeResult = rezervacije;
      _statusResult = statusi;
      isLoadingData = false;
    });
  }

  var dropdown_lista = [
    {'opis': 'da', 'vrijednost': true},
    {'opis': 'ne', 'vrijednost': false}
  ];

  String? selectedOpis = null;

  Widget _searchByIsArhiva() {
    return Container(
      width: 250,
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
            isExpanded: true,
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

  Widget searchByStatus() {
    if (isLoadingData == false) {
      return Container(
        width: 250,
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

  var dropdown_lista_sort = [
    {'opis': 'Po najnovijie kreiranim rezervacijama', 'vrijednost': 'da'},
    {'opis': 'Po najstarijie kreiranim rezervacijama', 'vrijednost': 'ne'}
  ];

  String? selectedSort;

  Widget _sortByDatumKreiranja() {
    return Container(
      width: 250,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      child: Center(
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedSort,
            isExpanded: true,
            hint: Text("Sortiraj po"),
            items: dropdown_lista_sort.map((item) {
              return DropdownMenuItem<String>(
                value: item['vrijednost'] as String,
                child: Text(item['opis'] as String),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedSort = value;
              });
              print(selectedSort);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 280,
        decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: Colors.pink,
            ),
            borderRadius: BorderRadius.circular(20)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Text(
                  "Filtriraj rezervacije",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _sortByDatumKreiranja(),
                    SizedBox(
                      width: 8,
                    ),
                    selectedSort != null
                        ? TextButton(
                            onPressed: () {
                              setState(() {
                                selectedSort = null;
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
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                ElevatedButton(
                    onPressed: () async {
                      print("pritisnuto dugme Traži");

                      var data = await _rezervacijeProvider.get(filter: {
                        'statusId': selectedStatus?.statusId,
                        'isArhivaKorisnik': selectedOpis,
                        'DatumOpadajuciSort': selectedSort == "da"
                            ? true
                            : selectedSort == "ne"
                                ? false
                                : null
                      });

                      setState(() {
                        _rezervacijeResult = data;
                      });
                    },
                    child: Text("Traži")),
                SizedBox(
                  width: 8,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildRezervacijeListView() {
    return Container(
      width: 800,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 670,
            child: GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1, // Number of items in a row (1 in this case)
                childAspectRatio:
                    3 / 1, // Adjust the width-to-height ratio here
                mainAxisSpacing: 8, // Spacing between items vertically
              ),
              scrollDirection: Axis.vertical,
              children: _buildRezervacijeList(_rezervacijeResult!.result),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildRezervacijeList(data) {
    if (data.length == 0) {
      return [Text("Ucitavanje...")];
    }

    List<Widget> list = data
        .map((x) => Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 2),
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => RezervacijaDetails(
                              rezervacija: x,
                            )));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${x.sifra ?? ""}"),
                          Text("${x.usluga?.naziv ?? ""}"),
                          Text("${formatDate(x.datumRezervacije)}"),
                          Text("${x.termin?.opis ?? ""}h"),
                          Text(
                            "${x.status?.opis ?? ""}",
                            style: TextStyle(color: _colorReservationStatus(x)),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          x.isArhivaKorisnik == false ||
                                  x.isArhivaKorisnik == null
                              ? TextButton(
                                  onPressed: () async {
                                    //Kad se klikne na ovo dugme,
                                    //arhivira se rezervacija (isArhivaKorisnik)
                                    var request = RezervacijaUpdate(
                                        LoggedUser.id,
                                        x.uslugaId,
                                        x.terminId,
                                        x.statusId,
                                        x.isArhiva,
                                        x.datumRezervacije,
                                        true,
                                        true);
                                    try {
                                      var obj = await _rezervacijeProvider
                                          .update(x.rezervacijaId, request);

                                      var data = await _rezervacijeProvider
                                          .get(filter: {
                                        'statusId': selectedStatus?.statusId,
                                        'korisnikId': LoggedUser.id,
                                        'isArhivaKorisnik': selectedOpis,
                                        'DatumOpadajuciSort':
                                            selectedSort == "da"
                                                ? true
                                                : selectedSort == "ne"
                                                    ? false
                                                    : null
                                      });

                                      setState(() {
                                        _rezervacijeResult = data;
                                      });
                                      showSuccessMessage();
                                    } catch (err) {
                                      print(err.toString());
                                      showError();
                                    }
                                  },
                                  child: Icon(
                                    Icons.archive_outlined,
                                    color: Colors.green,
                                  ))
                              : TextButton(
                                  onPressed: () async {
                                    var request = RezervacijaUpdate(
                                        LoggedUser.id,
                                        x.uslugaId,
                                        x.terminId,
                                        x.statusId,
                                        x.isArhiva,
                                        x.datumRezervacije,
                                        false,
                                        true);
                                    try {
                                      var obj = await _rezervacijeProvider
                                          .update(x.rezervacijaId, request);

                                      var data = await _rezervacijeProvider
                                          .get(filter: {
                                        'statusId': selectedStatus?.statusId,
                                        'korisnikId': LoggedUser.id,
                                        'isArhivaKorisnik': selectedOpis,
                                        'DatumOpadajuciSort':
                                            selectedSort == "da"
                                                ? true
                                                : selectedSort == "ne"
                                                    ? false
                                                    : null
                                      });

                                      setState(() {
                                        _rezervacijeResult = data;
                                      });
                                      showSuccessMessage();
                                    } catch (err) {
                                      print(err.toString());
                                      showError();
                                    }
                                  },
                                  child: Icon(
                                    Icons.unarchive_outlined,
                                    color: Colors.red,
                                  )),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ))
        .cast<Widget>()
        .toList();

    return list;
  }

  _colorReservationStatus(Rezervacija e) {
    if (e.status?.opis == "Prihvaćena")
      return Colors.green[500];
    else if (e.status?.opis == "Odbijena")
      return Colors.red[500];
    else if (e.status?.opis == "Otkazana")
      return Colors.grey;
    else if (e.status?.opis == "Nova") return Colors.amber;
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        title: "Moje rezervacije",
        child: isLoadingData == false
            ? Container(
                width: 800,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      filterData == false
                          ? IconButton(
                              icon: Icon(Icons.arrow_downward),
                              onPressed: () {
                                setState(() {
                                  filterData = !filterData;
                                });
                              },
                            )
                          : Container(),
                      filterData == true ? _buildSearch() : Container(),
                      filterData == true
                          ? IconButton(
                              icon: Icon(Icons.arrow_upward),
                              onPressed: () {
                                setState(() {
                                  filterData = !filterData;
                                });
                              },
                            )
                          : Container(),
                      _buildRezervacijeListView()
                    ],
                  ),
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }

  void showSuccessMessage() {
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

  void showError() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text("Greška"),
              content: Text("Desilo se nešto loše. Molimo pokušajte ponovo."),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Shvatam"))
              ],
            ));
  }
}
