import 'package:flutter/material.dart';
import 'package:mobile_app/main.dart';
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
    var tmpData = await _novostiProvider.get();
    setState(() {
      data = tmpData;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        title: "Početna stranica",
        child: Container(
          // height: 800,
          width: 800,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                SizedBox(height: 10,),
                Container(
                  height: 30,
                  child: Text(
                    "Dobrodosli ${LoggedUser.ime}!",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontFamily: 'BeckyTahlia',
                        fontSize: 26,
                        color: Colors.pinkAccent),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  child: Text("Pogledajte novosti naseg salona."),
                ),
                SizedBox(
                  height: 30,
                ),
                isLoading == false
                    ? Container(
                        width: 800,
                        height: 600,
                        // child: Padding(
                        // padding: const EdgeInsets.all(8.0),
                        child: GridView(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
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
                        // ),
                      )
                    : Text("Ucitavanje...")
              ]),
            ),
          ),
        ));
  }

  _buildNovostList() {
    if (data?.result.length == 0) {
      return [Text("Ucitavanje...")];
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
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => NovostDetailsScreen(
                                      novost: x,
                                    )));
                          },
                          child: x.slikaNovost != null &&
                                  x.slikaNovost?.slika != null
                              ? Container(
                                  height: 150,
                                  width: 150,
                                  child: ImageFromBase64String(
                                      x.slikaNovost!.slika),
                                )
                              : Container(
                                  child: Image.asset(
                                    "assets/images/noImage.jpg",
                                    width: 150,
                                    height: 150,
                                  ),
                                  height: 150,
                                  width: 150,
                                ),
                        ),
                        Row(
                          children: [
                            Text(
                              "${(x.naslov ?? "").split(' ').take(3).join(' ')}...",
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.info,
                              color: Colors.blueGrey,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ))
        .cast<Widget>()
        .toList();

    return list;
  }
}
