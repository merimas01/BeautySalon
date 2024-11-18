import 'package:desktop_app/screens/rezervacije_update_status.dart';
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
  TextEditingController _ftsController = new TextEditingController();
  bool isLoadingStatus = true;
  bool isLoadingData = true;
  Status? selectedStatus;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _rezervacijeProvider = context.read<RezervacijeProvider>();
    _statusiProvider = context.read<StatusiProvider>();
    getData();
  }

  void getData() async {
    var data = await _rezervacijeProvider.get(filter: {'FTS': ''});
    var statusi = await _statusiProvider.get();

    setState(() {
      result = data;
      isLoadingData = false;
      _statusResult = statusi;
      isLoadingStatus = false;
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

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: 'Rezervacije',
      child: Column(children: [
        _builSearch(),
        _showResultCount(),
        isLoadingData == false ? _buildDataListView() : Container(child: CircularProgressIndicator()),
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
                    child: Text(
                      "X",
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
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
                  'statusId': selectedStatus?.statusId
                });

                print(
                    "fts: ${_ftsController.text}, statusId: ${selectedStatus?.statusId}");

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
            ))
          ],
          rows: result?.result
                  .map((Rezervacija e) => DataRow(cells: [
                        DataCell(Container(
                            width: 200,
                            child: Text(
                                "${e.korisnik?.ime ?? ""} ${e.korisnik?.prezime ?? ""}"))),
                        DataCell(Container(
                            width: 100,
                            child: Text((e.datumRezervacije == null
                                ? "-"
                                : "${e.datumRezervacije?.day}.${e.datumRezervacije?.month}.${e.datumRezervacije?.year}")))),
                        DataCell(Text(e.termin?.opis ?? "")),
                        DataCell(Container(
                            width: 380, child: Text(e.usluga?.naziv ?? ""))),
                        DataCell(Text(e.status?.opis ?? "-")),
                        DataCell(TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.green,
                          ),
                          child: Text("Promijeni status"),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => RezervacijeUpdateStatus(
                                      rezervacija: e,
                                    )));
                          },
                        )),
                      ]))
                  .toList() ??
              []),
    ));
  }
}
