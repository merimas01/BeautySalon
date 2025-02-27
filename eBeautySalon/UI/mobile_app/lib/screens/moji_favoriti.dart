import 'package:flutter/material.dart';
import 'package:mobile_app/models/favoriti_usluge.dart';
import 'package:mobile_app/providers/usluge_provider.dart';
import 'package:mobile_app/screens/profil_page.dart';
import 'package:mobile_app/screens/usluga_details.dart';
import 'package:mobile_app/widgets/master_screen.dart';
import 'package:provider/provider.dart';

import '../models/favorit_dto.dart';
import '../models/search_result.dart';
import '../models/usluga.dart';
import '../providers/favoriti_usluge_provider.dart';
import '../utils/util.dart';

class MojiFavoriti extends StatefulWidget {
  const MojiFavoriti({super.key});

  @override
  State<MojiFavoriti> createState() => _MojiFavoritiState();
}

class _MojiFavoritiState extends State<MojiFavoriti> {
  late FavoritiUslugeProvider _favoritiUslugeProvider;
  late UslugeProvider _uslugeProvider;
  SearchResult<FavoritiUsluge>? _favoritiResult;
  List<FavoritDto> _favoritDtoResult = [];
  bool isLoadingData = true;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _favoritiUslugeProvider = context.read<FavoritiUslugeProvider>();
    _uslugeProvider = context.read<UslugeProvider>();
    getData();
  }

  void getData() async {
    var data = await _favoritiUslugeProvider.get(filter: {
      'korisnikId': LoggedUser.id,
    });

    setState(() {
      _favoritiResult = data;
    });

    List<Usluga> listaUsluga = [];
    if (_favoritiResult?.count != 0) {
      for (var obj in _favoritiResult!.result) {
        var usluga = await _uslugeProvider.getById(obj.uslugaId!);
        var favoritDto = FavoritDto(obj.favoritId, usluga);
        setState(() {
          _favoritDtoResult.add(favoritDto);
        });
      }
    } else {
      _favoritDtoResult = [];
    }

    setState(() {
      isLoadingData = false;
    });
  }

  Widget _buildListView() {
    return Container(
      width: 800,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 700,
            child: GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 4 / 3,
                  // crossAxisSpacing: 8,
                  mainAxisSpacing: 10),
              scrollDirection: Axis.vertical,
              children: _buildList(_favoritDtoResult),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildList(data) {
    if (data.length == 0) {
      return [noResultsWidget()];
    }

    List<Widget> list = data
        .map((x) => Container(
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => UslugaDetails(
                                usluga: x.usluga,
                                poslaniKorisnikId: LoggedUser.id,
                              )));
                    },
                    child: x.usluga?.slikaUsluge != null &&
                            x.usluga?.slikaUsluge?.slika != null &&
                            x.usluga?.slikaUsluge?.slika != ""
                        ? imageContainer( x.usluga!.slikaUsluge!.slika, 170, 200)
                        : noImageContainer(170, 200),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(x.usluga?.naziv ?? ""),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () async {
                          try {
                            var obj = await _favoritiUslugeProvider
                                .delete(x.favoritId);

                            var usluga = await _uslugeProvider
                                .getById(x.usluga!.uslugaId!);

                            var data =
                                await _favoritiUslugeProvider.get(filter: {
                              'korisnikId': LoggedUser.id,
                            });

                            setState(() {
                              _favoritiResult = data;
                              _favoritDtoResult.removeWhere((favorit) =>
                                  favorit.favoritId == x.favoritId);
                              isLoadingData = false;
                            });
                          } catch (err) {
                            print(err.toString());
                          }
                        },
                        child: Icon(
                          Icons.favorite,
                          color: Colors.pink,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ))
        .cast<Widget>()
        .toList();

    return list;
  }

  Widget noResultsWidget() {
    return Container(
      width: 300,
      height: 300,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          "Ups!",
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(
          height: 20,
        ),
        Text("Nije pronađen nijedan zapis. 😔", style: TextStyle(fontSize: 16))
      ]),
    );
  }

  dugmeNazad() {
    return Row(
      children: [
        TextButton(
            onPressed: () {
              {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ProfilPage()));
              }
            },
            child: Icon(Icons.arrow_back)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        selectedIndex: 3,
        title: "Moji favoriti",
        child: isLoadingData == false
            ? Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      dugmeNazad(),
                      _buildListView(),
                    ],
                  ),
                ),
              )
            : Container());
  }
}
