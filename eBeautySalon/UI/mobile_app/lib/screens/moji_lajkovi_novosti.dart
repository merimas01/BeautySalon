import 'package:flutter/material.dart';
import 'package:mobile_app/models/novost_like_comment.dart';
import 'package:mobile_app/models/search_result.dart';
import 'package:mobile_app/providers/novost_like_comment_provider.dart';
import 'package:mobile_app/screens/novost_details.dart';
import 'package:mobile_app/screens/profil_page.dart';
import 'package:mobile_app/widgets/master_screen.dart';
import 'package:provider/provider.dart';

import '../models/novost_like_comment_insert_update.dart';
import '../utils/util.dart';

class MojiLajkoviNovosti extends StatefulWidget {
  int? poslaniKorisnikId;
  MojiLajkoviNovosti({super.key, this.poslaniKorisnikId});

  @override
  State<MojiLajkoviNovosti> createState() => _MojiLajkoviNovostiState();
}

class _MojiLajkoviNovostiState extends State<MojiLajkoviNovosti> {
  late NovostLikeCommentProvider _novostLikeCommentProvider;
  SearchResult<NovostLikeComment>? _novostLikeCommentResult;
  bool isLoadingData = true;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _novostLikeCommentProvider = context.read<NovostLikeCommentProvider>();
    getData();
  }

  void getData() async {
    var data = await _novostLikeCommentProvider.get(filter: {
      'isNovostIncluded': true,
      'korisnikId': LoggedUser.id,
      'isLike': true
    });

    setState(() {
      _novostLikeCommentResult = data;
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
              children: _buildList(_novostLikeCommentResult!.result),
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
                          builder: (context) => NovostDetailsScreen(
                              novost: x.novost,
                              poslaniKorisnikId: LoggedUser.id)));
                    },
                    child: x.novost?.slikaNovost != null &&
                            x.novost?.slikaNovost?.slika != null &&
                            x.novost?.slikaNovost?.slika != ""
                        ? imageContainer(x.novost?.slikaNovost!.slika, 170, 200)
                        : noImageContainer(170, 200),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(x.novost?.naslov ?? ""),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () async {
                          try {
                            var obj = await _novostLikeCommentProvider.update(
                                x.novostLikeCommentId!,
                                NovostLikeCommentInsertUpdate(LoggedUser.id,
                                    x.novostId, false, x.komentar));

                            var data = await _novostLikeCommentProvider.get(
                                filter: {
                                  'isNovostIncluded': true,
                                  'korisnikId': LoggedUser.id,
                                  'isLike': true
                                });

                            setState(() {
                              _novostLikeCommentResult = data;
                              isLoadingData = false;
                            });
                          } catch (err) {
                            print(err.toString());
                          }
                        },
                        child: Icon(
                          Icons.thumb_down,
                          color: Colors.red,
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
        title: "Moji lajkovi novosti",
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
