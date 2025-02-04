import 'package:flutter/material.dart';
import 'package:mobile_app/models/novost_like_comment.dart';
import 'package:mobile_app/providers/novost_like_comment_provider.dart';
import 'package:mobile_app/screens/edit_komentar_novost.dart';
import 'package:mobile_app/utils/util.dart';
import 'package:mobile_app/widgets/master_screen.dart';
import 'package:provider/provider.dart';

import '../models/novost_like_comment_insert_update.dart';
import '../models/search_result.dart';

class MojiKomentariNovosti extends StatefulWidget {
  const MojiKomentariNovosti({super.key});

  @override
  State<MojiKomentariNovosti> createState() => _MojiKomentariNovostiState();
}

class _MojiKomentariNovostiState extends State<MojiKomentariNovosti> {
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
      'isComment': true
    });

    setState(() {
      _novostLikeCommentResult = data;
      isLoadingData = false;
    });
  }

  List<Widget> _buildList(data) {
    if (data.length == 0) {
      return [Text("Učitavanje...")];
    }

    List<Widget> list = data
        .map((x) => Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 2),
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => EditKomentarNovost(
                              novostLikeComment: x,
                              poslaniKorisnikId: LoggedUser.id,
                            )));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      x.novost?.slikaNovost != null &&
                              x.novost?.slikaNovost?.slika != null &&
                              x.novost?.slikaNovost?.slika != ""
                          ? Container(
                              height: 170,
                              width: 170,
                              child: ImageFromBase64String(
                                  x.novost!.slikaNovost!.slika),
                            )
                          : Container(
                              child: Image.asset(
                                "assets/images/noImage.jpg",
                              ),
                              height: 120,
                              width: 120,
                            ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${(x.novost?.naslov ?? "").split(' ').take(2).join(' ')}...",
                          ),
                          TextButton(
                            onPressed: () {
                              _deleteConfirmationDialog(x);
                            },
                            child: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ))
        .cast<Widget>()
        .toList();

    return list;
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
                  childAspectRatio: 3 / 1,
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

  void _deleteConfirmationDialog(e) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text('Potvrda o brisanju zapisa',
                  textAlign: TextAlign.center),
              content: Text('Jeste li sigurni da želite izbrisati ovaj zapis?',
                  textAlign: TextAlign.center),
              actions: <Widget>[
                ElevatedButton(
                  child: Text('Ne'),
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.grey),
                  onPressed: () {
                    Navigator.of(context).pop(); //zatvori dijalog
                  },
                ),
                ElevatedButton(
                  child: Text('Da'),
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red),
                  onPressed: () async {
                    Navigator.of(context).pop(); //zatvori dijalog
                    _obrisiZapis(e);
                  },
                ),
              ],
            ));
  }

  void _obrisiZapis(e) async {
    var deleted = await _novostLikeCommentProvider.update(
        e.novostLikeCommentId!,
        NovostLikeCommentInsertUpdate(
            LoggedUser.id, e.novostId, e.isLike, null));

    var data = await _novostLikeCommentProvider.get(filter: {
      'isNovostIncluded': true,
      'korisnikId': LoggedUser.id,
      'isComment': true
    });

    setState(() {
      _novostLikeCommentResult = data;
      isLoadingData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        title: "Moji komentari za novosti",
        child: isLoadingData == false ? _buildListView() : Container());
  }
}
