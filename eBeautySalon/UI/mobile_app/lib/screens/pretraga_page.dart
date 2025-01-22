import 'package:flutter/material.dart';
import 'package:mobile_app/models/kategorija.dart';
import 'package:mobile_app/providers/kategorije_provider.dart';
import 'package:mobile_app/screens/usluga_details.dart';
import 'package:mobile_app/widgets/master_screen.dart';
import 'package:provider/provider.dart';

import '../models/search_result.dart';
import '../models/usluga.dart';
import '../providers/usluge_provider.dart';
import '../utils/util.dart';

class PretragaPage extends StatefulWidget {
  static const String routeName = "/search";
  const PretragaPage({super.key});

  @override
  State<PretragaPage> createState() => _PretragaPageState();
}

class _PretragaPageState extends State<PretragaPage> {
  late KategorijeProvider _kategorijeProvider;
  late UslugeProvider _uslugeProvider;
  SearchResult<Usluga>? _uslugeResult;
  List<SearchResult<Usluga>>? sveUsluge = [];
  SearchResult<Kategorija>? _kategorijeResult;
  TextEditingController _searchController = TextEditingController();
  String? search="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _kategorijeProvider = context.read<KategorijeProvider>();
    _uslugeProvider = context.read<UslugeProvider>();
    loadData();
  }

  loadData() async {
    var kategorije = await _kategorijeProvider.get();
    setState(() {
      _kategorijeResult = kategorije;
    });
    for (var kat in kategorije.result) {
      var uslugeZaKategoriju =
          await _uslugeProvider.get(filter: {'kategorijaId': kat.kategorijaId});
      setState(() {
        sveUsluge!.add(uslugeZaKategoriju);
      });
    }

    // Add a listener to get the value whenever the text changes
    _searchController.addListener(() {
      String currentText = _searchController.text; // Access the current text
      setState(() {
        search = currentText;
      });
      print('Current Text: $currentText');
    });
  }

  _createGrid(data) {
    return data.length != 0
        ? Container(
            height: 250,
            child: GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8),
              scrollDirection: Axis.horizontal,
              children: _buildUslugaList(data),
            ),
          )
        : Container(
            child: Text("Nema rezultata za trazenu uslugu."),
          );
  }

  List<Widget> _buildUslugaList(data) {
    if (data.length == 0) {
      return [Text("Ucitavanje...")];
    }

    List<Widget> list = data
        .map((x) => Container(
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => UslugaDetails(
                                usluga: x,
                              )));
                    },
                    child: x.slikaUsluge != null &&
                            x.slikaUsluge?.slika != null &&
                            x.slikaUsluge?.slika != ""
                        ? Container(
                            height: 150,
                            width: 150,
                            child: ImageFromBase64String(x.slikaUsluge!.slika),
                          )
                        : Container(
                            child: Image.asset(
                              "assets/images/noImage.jpg",
                            ),
                            height: 150,
                            width: 150,
                          ),
                  ),
                  Text(x?.naziv ?? ""),
                  Text("${formatNumber(x?.cijena)}KM"),
                ],
              ),
            ))
        .cast<Widget>()
        .toList();

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        title: "Pretraži usluge",
        child: Container(
            height: 800,
            width: 800,
            child: SingleChildScrollView(
                child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 50,
                    child: Text(
                      "Pogledajte nase usluge!",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontFamily: 'BeckyTahlia',
                          fontSize: 26,
                          color: Colors.pinkAccent),
                    ),
                  ),
                ),
                _searchUsluge(),
                _showUsluge(),
              ],
            ))));
  }

  _showUsluge() {
    return _kategorijeResult?.result.length != 0
        ? Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: sveUsluge!.map((podusluge) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    podusluge.result.length != 0
                        ? Container(
                            child: Text(
                              "${podusluge.result[0].kategorija?.naziv ?? ""}",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.pink,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        : Container(),
                    podusluge.result.length != 0
                        ? SizedBox(
                            height: 20,
                          )
                        : Container(),
                    podusluge.result.length != 0
                        ?
                        //  Row(
                        //     children: podusluge.result.map((usluga) {
                        //       return Container(
                        //         margin: EdgeInsets.all(4.0),
                        //         padding: EdgeInsets.all(8.0),
                        //         color: Colors.blueAccent,
                        //         child: Text(
                        //           usluga.naziv ?? "",
                        //           style: TextStyle(color: Colors.white),
                        //         ),
                        //       );
                        //     }).toList(),
                        //   )
                        _createGrid(podusluge.result)
                        : Container()
                  ],
                );
              }).toList(),
            ),
          )
        : Container(
            child: Text("Nema rezultata za trazenu uslugu."),
          );
  }

  _searchUsluge() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                  hintText: "Trazi uslugu...",
                  //prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey))),
            ),
          ),
        ),
        search != ""
            ? TextButton(
                onPressed: () {
                  setState(() {
                    _searchController.text = '';
                    search = _searchController.text;
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
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: IconButton(
            icon: Icon(Icons.search_sharp),
            onPressed: () async {
              List<SearchResult<Usluga>> filteredList = [];

              for (var kat in _kategorijeResult!.result) {
                var uslugeZaKategoriju = await _uslugeProvider.get(filter: {
                  'FTS': _searchController.text,
                  'kategorijaId': kat.kategorijaId
                });
                filteredList.add(uslugeZaKategoriju);
                setState(() {
                  sveUsluge = filteredList;
                });
              }
            },
          ),
        )
      ],
    );
  }
}
