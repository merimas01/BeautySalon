import 'package:desktop_app/models/usluga.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/search_result.dart';
import '../models/termin.dart';
import '../models/termin_update.dart';
import '../models/usluga_termin.dart';
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
  bool showMessage = false;
  bool switchPrikazan = true;
  String? selectedValue;
  bool? isLoading = true;

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
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          _builSearch(),
          SizedBox(
            height: 10,
          ),
          _buildDataListView(),
        ]),
      ),
      title: "Termini",
    );
  }

  getTermine() async {
    var data =
        await _uslugeTerminiProvider.get(filter: {'uslugaId': selectedValue});

    print("uslugaId: ${selectedValue}");

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
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedValue,
                hint: Text('Izaberite uslugu'),
                items: _uslugaResult?.result.map((Usluga item) {
                  return DropdownMenuItem<String>(
                    value: item.uslugaId.toString(),
                    child: Text(item.naziv ?? ""),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    showMessage = false;
                    selectedValue = newValue;
                    getTermine();
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
            width: 200,
            child: ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(color: Colors.pink)))),
              onPressed: () async {
                if (selectedValue == null) {
                  setState(() {
                    showMessage = true;
                  });
                }
              },
              child: Text("Dodaj novi termin",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          showMessage == true
              ? Text(
                  "Molimo vas odaberite uslugu.",
                  style: TextStyle(color: Colors.red),
                )
              : Container(),
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
              child: Text("Termin"),
            )),
            DataColumn(
                label: Expanded(
              child: Text("Prikaži termin?"),
            ))
          ],
          rows: _uslugaTerminResult?.result
                  .map((UslugaTermin e) => DataRow(cells: [
                        DataCell(Text(e.termin?.opis ?? "")),
                        DataCell(Container(
                          child: Switch(
                            value: e.isPrikazan == null ? true : e.isPrikazan!,
                            activeColor: Colors.green,
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
    ));
  }

  void _updateUslugaTermin(UslugaTermin e) async {
    print("id: ${e.uslugaTerminId}");
    var obj = await _uslugeTerminiProvider.update(e.uslugaTerminId!,
        UslugaTerminUpdate(e.uslugaId, e.terminId, switchPrikazan));
    print("obj: ${obj.isPrikazan}");
    //treba da se osvjezi lista
    var data =
        await _uslugeTerminiProvider.get(filter: {'uslugaId': selectedValue});
    setState(() {
      _uslugaTerminResult = data;
    });
  }
}
