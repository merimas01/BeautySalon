//kao moje recenzije, odmah lajk dislajk
//navigacija na novost_details
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:mobile_app/models/novost_like_comment.dart';
import 'package:mobile_app/models/search_result.dart';
import 'package:mobile_app/providers/novost_like_comment_provider.dart';
import 'package:mobile_app/screens/novost_details.dart';
import 'package:mobile_app/widgets/master_screen.dart';
import 'package:provider/provider.dart';

import '../models/novost_like_comment_insert_update.dart';
import '../utils/util.dart';

class MojiLajkoviNovosti extends StatefulWidget {
  const MojiLajkoviNovosti({super.key});

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
      return [Text("Ucitavanje...")];
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
                              )));
                    },
                    child: x.novost?.slikaNovost != null &&
                            x.novost?.slikaNovost?.slika != null &&
                            x.novost?.slikaNovost?.slika != ""
                        ? Container(
                            height: 170,
                            width: 170,
                            child: ImageFromBase64String(
                                x.novost?.slikaNovost!.slika),
                          )
                        : Container(
                            child: Image.asset(
                              "assets/images/noImage.jpg",
                            ),
                            height: 170,
                            width: 170,
                          ),
                  ),
                  SizedBox(
                    height: 10,
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

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        title: "Moji lajkovi novosti",
        child: isLoadingData == false ? _buildListView() : Container());
  }
}
