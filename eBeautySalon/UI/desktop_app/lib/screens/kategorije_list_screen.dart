import 'package:flutter/cupertino.dart';

import '../widgets/master_screen.dart';

class KategorijeListScreen extends StatefulWidget {
  const KategorijeListScreen({super.key});

  @override
  State<KategorijeListScreen> createState() => _KategorijeListScreenState();
}

class _KategorijeListScreenState extends State<KategorijeListScreen> {
  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: Text("kategorije"),
      title: "Kategorije",
    );
  }
}
