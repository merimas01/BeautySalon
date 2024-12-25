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
      child: isLoading == false
          ? Container(
              width: 800,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SingleChildScrollView(
                      child: Column(
                    children: [
                      Image.asset(
                        "assets/images/slika4.png",
                        height: 170,
                        width: 170,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Dobrodošli ${LoggedUser.ime}!",
                        style: const TextStyle(
                            fontFamily: 'BeckyTahlia',
                            fontSize: 26,
                            color: Colors.pinkAccent),
                      ),
                      Expanded(
                        child: GridView(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1, // Number of columns
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                          ),
                          scrollDirection: Axis.vertical,
                          children: data?.result.length != 0
                              ? data!.result
                                  .map((novost) => _buildNovostWidget(novost))
                                  .toList()
                              : [],
                        ),
                      ),
                    ],
                  )),
                ),
              ),
            )
          : Text("nema podataka"),
    );
  }

  Widget _buildNovostWidget(Novost novost) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NovostDetailsScreen(
                        novost: novost,
                      )));
            },
          ),
          Row(
            children: [
              novost.slikaNovost != null && novost.slikaNovost!.slika != ""
                  ? Container(
                      height: 100,
                      width: 100,
                      child: ImageFromBase64String(novost.slikaNovost!.slika),
                    )
                  : Container(
                      child: Image.asset(
                        "assets/images/noImage.jpg",
                        height: 180,
                        width: null,
                        fit: BoxFit.cover,
                      ),
                    ),
              Text(novost.naslov ?? "")
            ],
          ),
          SizedBox(
            child: Container(color: Colors.black),
            height: 1,
          )
        ],
      ),
    );
  }
}
