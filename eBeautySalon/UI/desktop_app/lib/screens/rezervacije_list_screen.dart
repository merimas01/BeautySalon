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

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _rezervacijeProvider = context.read<RezervacijeProvider>();
    _statusiProvider = context.read<StatusiProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: 'Rezervacije',
      child: Column(children: [
        _builSearch(),
        _buildDataListView(),
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
                labelText: "Bilo šta",
              ),
              controller: _ftsController,
            ),
          ),
          SizedBox(
            width: 8,
          ),
          ElevatedButton(
              onPressed: () async {
                print("pritisnuto dugme Dugme");

                var data = await _rezervacijeProvider
                    .get(filter: {'FTS': _ftsController.text});

                var statusi = await _statusiProvider.get();

                print("fts: ${_ftsController.text}");

                setState(() {
                  result = data;
                  _statusResult = statusi;
                });
                print("${_statusResult?.result[0].opis}");
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
