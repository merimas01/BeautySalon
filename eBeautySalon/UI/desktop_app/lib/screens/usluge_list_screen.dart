import 'package:desktop_app/providers/usluge_provider.dart';
import 'package:desktop_app/screens/kategorije_list_screen.dart';
import 'package:desktop_app/screens/usluge_details_screen.dart';
import 'package:desktop_app/utils/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/search_result.dart';
import '../models/usluga.dart';
import '../widgets/master_screen.dart';


class UslugeListScreen extends StatefulWidget {
  const UslugeListScreen({super.key});

  @override
  State<UslugeListScreen> createState() => _UslugeListScreenState();
}

class _UslugeListScreenState extends State<UslugeListScreen> {
  late UslugeProvider _uslugeProvider;
  SearchResult<Usluga>? result;
  TextEditingController _ftsController = new TextEditingController();

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _uslugeProvider = context.read<UslugeProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: Container(
        child: Column(children: [
          _builSearch(),
          _buildDataListView(),
        ]),
      ),
      title_widget: Text("Usluge"),
      //title: "Usluge",
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

                var data = await _uslugeProvider
                    .get(filter: {'FTS': _ftsController.text});

                print("fts: ${_ftsController.text}");

                setState(() {
                  result = data;
                });

                print("result: ${result?.result[1].naziv}");
              },
              child: Text("Traži")),
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
              child: Text("ID"),
            )),
            DataColumn(
                label: Expanded(
              child: Text("Naziv"),
            )),
            DataColumn(
                label: Expanded(
              child: Text("Opis"),
            )),
            DataColumn(
                label: Expanded(
              child: Text("Cijena"),
            )),
            // DataColumn(
            //     label: Expanded(
            //   child: Text("Datum kreiranja"),
            // )),
            // DataColumn(
            //     label: SizedBox(
            //   width: 100,
            //   child: Text("Datum modifikovanja"),
            // )),
            DataColumn(
                label: SizedBox(
              width: 100,
              child: Text("Slika"),
            )),
          ],
          rows: result?.result
                  .map((Usluga e) => DataRow( onSelectChanged: (selected)=>{
                    if(selected==true){
                     // print("selected: ${e.uslugaId}")
                      Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    UslugeDetaljiScreen(usluga: e,)))
                    }
                  },
                    cells: [
                        DataCell(Text(e.uslugaId?.toString() ?? "")),
                        DataCell(Text(e.naziv ?? "")),
                        DataCell(Text(e.opis ?? "")),
                        DataCell(Text(formatNumber(e.cijena))),
                        // DataCell(Text((e.datumKreiranja == null
                        //     ? "-"
                        //     : "${e.datumKreiranja?.day}.${e.datumKreiranja?.month}.${e.datumKreiranja?.year}"))),
                        // DataCell(Text((e.datumModifikovanja == null
                        //     ? "-"
                        //     : "${e.datumModifikovanja?.day}.${e.datumModifikovanja?.month}.${e.datumModifikovanja?.year}"))),
                        DataCell(e.slikaUsluge!=null ? Container(
                          width: 100,
                          height: 100,
                          child:
                              ImageFromBase64String(e.slikaUsluge.slika),
                        ) : Text("")) ,
                      ]))
                  .toList() ??
              []),
    ));
  }
}
