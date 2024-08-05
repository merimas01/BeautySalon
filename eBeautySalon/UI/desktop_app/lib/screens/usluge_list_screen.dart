import 'package:desktop_app/providers/usluge_provider.dart';
import 'package:desktop_app/screens/kategorije_list_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/master_screen.dart';

class UslugeListScreen extends StatefulWidget {
  const UslugeListScreen({super.key});

  @override
  State<UslugeListScreen> createState() => _UslugeListScreenState();
}

class _UslugeListScreenState extends State<UslugeListScreen> {
  late UslugeProvider _uslugeProvider;

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
                print("pritisnuto dugme");
                //Navigator.of(context).pop();

                //  Navigator.of(context).push(MaterialPageRoute(
                //  builder: (context) => const KategorijeListScreen()));

                var data = await _uslugeProvider.get();

                print(data);
                print(data['result']);
              },
              child: Text("Dugme"))
        ]),
      ),
      title_widget: Text("Usluge"),
      //title: "Usluge",
    );
  }
}
