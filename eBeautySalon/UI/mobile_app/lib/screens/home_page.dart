import 'package:flutter/material.dart';
import 'package:mobile_app/screens/novost_details.dart';
import 'package:mobile_app/utils/util.dart';
import 'package:mobile_app/widgets/master_screen.dart';
import 'package:provider/provider.dart';

import '../models/novost.dart';
import '../models/search_result.dart';
import '../providers/novost_provider.dart';

class HomePage extends StatefulWidget {
  static const String routeName = "/home";

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late NovostiProvider _novostiProvider;
  SearchResult<Novost>? data;
  bool isLoading = true;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _novostiProvider = context.read<NovostiProvider>();
    print("called initState");
    loadData();
  }

  Future loadData() async {
    var tmpData = await _novostiProvider.get(filter: {'isSlikaIncluded': true});
    setState(() {
      data = tmpData;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        selectedIndex: 0,
        title: "Početna stranica",
        child: Container(
          width: 800,
          child: SingleChildScrollView(
            child: Column(children: [
              SizedBox(
                height: 20,
              ),
              Container(
                height: 30,
                child: Text(
                  "Dobrodošli ${LoggedUser.ime}!",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      // fontFamily: 'BeckyTahlia',
                      fontSize: 26,
                      color: Colors.pinkAccent),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                child: Text("Pogledajte novosti našeg salona."),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _sortByDatumKreiranja(),
                  selectedSort != null
                      ? TextButton(
                          onPressed: () async {
                            setState(() {
                              selectedSort = null;
                            });
                            var tmpData = await _novostiProvider.get(filter: {
                              'isSlikaIncluded': true,
                              'DatumOpadajuciSort': selectedSort == "da"
                                  ? true
                                  : selectedSort == "ne"
                                      ? false
                                      : null
                            });
                            setState(() {
                              data = tmpData;
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
                height: 30,
              ),
              isLoading == false
                  ? Container(
                      width: 800,
                      height: 530,
                      child: GridView(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              1, // Number of items in a row (1 in this case)
                          childAspectRatio:
                              3 / 1, // Adjust the width-to-height ratio here
                          mainAxisSpacing:
                              8, // Spacing between items vertically
                        ),
                        scrollDirection: Axis.vertical,
                        children: _buildNovostList(),
                      ),
                    )
                  : Text("Učitavanje...")
            ]),
          ),
        ));
  }

  _buildNovostList() {
    if (data?.result.length == 0) {
      return [Text("Učitavanje...")];
    }
    List<Widget> list = data!.result
        .map((x) => Container(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: 10.0, top: 5.0, bottom: 5.0, left: 10.0),
                  child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => NovostDetailsScreen(
                                  novost: x,
                                )));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          x.slikaNovost != null &&
                                  x.slikaNovost?.slika != null &&
                                  x.slikaNovost?.slika != ""
                              ? imageContainer(x.slikaNovost!.slika, 300, 150)
                              : noImageContainer(300, 150),
                          Row(
                            children: [
                              Text(
                                "${(x.naslov ?? "").split(' ').take(3).join(' ')}...",
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.info_rounded,
                                color: Colors.grey[500],
                              )
                            ],
                          )
                        ],
                      )),
                ),
              ),
            ))
        .cast<Widget>()
        .toList();

    return list;
  }

  var dropdown_lista_sort = [
    {'opis': 'Po najnovijim novostima', 'vrijednost': 'da'},
    {'opis': 'Po najstarijim novostima', 'vrijednost': 'ne'}
  ];

  String? selectedSort;

  Widget _sortByDatumKreiranja() {
    return Container(
      width: 300,
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
            onChanged: (value) async {
              setState(() {
                selectedSort = value;
              });
              print(selectedSort);
              var tmpData = await _novostiProvider.get(filter: {
                'isSlikaIncluded': true,
                'DatumOpadajuciSort': selectedSort == "da"
                    ? true
                    : selectedSort == "ne"
                        ? false
                        : null
              });
              setState(() {
                data = tmpData;
              });
            },
          ),
        ),
      ),
    );
  }
}
