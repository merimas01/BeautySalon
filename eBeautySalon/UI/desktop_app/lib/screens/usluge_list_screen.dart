import 'package:desktop_app/providers/usluge_provider.dart';
import 'package:desktop_app/screens/kategorije_list_screen.dart';
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
  SearchResult<Usluga>? result;  //dynamic? result;
  dynamic rezultat;

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
          Text("test"),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () async {
                print("pritisnuto dugme Dugme");
                //Navigator.of(context).pop();

                //  Navigator.of(context).push(MaterialPageRoute(
                //  builder: (context) => const KategorijeListScreen()));

                var data = await _uslugeProvider.get();

                setState(() {
                  result=data;
                 // rezultat=data;
                });
             
                //print("data: $data");
                print("result: ${result?.result[1].naziv}");
         
              },
              child: Text("Dugme")),
              SingleChildScrollView(scrollDirection: Axis.horizontal,),
              DataTable(columns: [
                DataColumn(label: Expanded(child: Text("ID"),)),
                DataColumn(label: Expanded(child: Text("Naziv"),)),
                DataColumn(label: Expanded(child: Text("Opis"),)),
                DataColumn(label: Expanded(child: Text("Cijena"),)),
                DataColumn(label: Expanded(child: Text("Datum kreiranja"),)),
                DataColumn(label: SizedBox(width:100, child: Text("Datum modifikovanja"),)),
              ], 
              rows:  
              result?.result.map((Usluga e) => 
                   DataRow(cells: 
                   [  
                    DataCell(Text(e.uslugaId?.toString() ?? "")),
                    DataCell(Text(e.naziv ?? "")),
                    DataCell(Text(e.opis?? "")),
                    DataCell(Text(e.cijena?.toString() ?? "")),
                    DataCell(Text((e.datumKreiranja==null? "-": "${e.datumKreiranja?.day}.${e.datumKreiranja?.month}.${e.datumKreiranja?.year}"))),     
                    DataCell(Text((e.datumModifikovanja==null? "-": "${e.datumModifikovanja?.day}.${e.datumModifikovanja?.month}.${e.datumModifikovanja?.year}"))),            
                  ])).toList() ?? 
                  []  
                  )
             
        ]),
      
      ),
      title_widget: Text("Usluge"),
      //title: "Usluge",
    );
  }
}
