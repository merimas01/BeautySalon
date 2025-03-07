import 'package:flutter/material.dart';
import 'package:mobile_app/models/novost_like_comment.dart';
import 'package:mobile_app/models/novost_like_comment_insert_update.dart';
import 'package:mobile_app/models/search_result.dart';
import 'package:mobile_app/screens/edit_komentar_novost.dart';
import 'package:mobile_app/screens/home_page.dart';
import 'package:mobile_app/screens/moji_lajkovi_novosti.dart';
import 'package:mobile_app/widgets/master_screen.dart';
import 'package:provider/provider.dart';

import '../models/novost.dart';
import '../providers/novost_like_comment_provider.dart';
import '../utils/util.dart';

class NovostDetailsScreen extends StatefulWidget {
  Novost? novost;
  int? poslaniKorisnikId;
  static const String routeName = "/novost_details";

  NovostDetailsScreen({super.key, this.novost, this.poslaniKorisnikId});

  @override
  State<NovostDetailsScreen> createState() => _NovostDetailsScreenState();
}

class _NovostDetailsScreenState extends State<NovostDetailsScreen> {
  bool showComments = false;
  bool isLoadingLikesComments = true;
  bool createComment = false;
  bool liked = false; //vec lajkano
  bool commented = false; //vec komentarisano
  int likesCount = 0;
  int commentsCount = 0;
  int? novostLikeCommentId;
  String? currentComment;
  String? textCommentController = "";
  late NovostLikeCommentProvider _novostLikeCommentProvider;
  SearchResult<NovostLikeComment>? _novostLikeCommentResult;
  TextEditingController _commentController = TextEditingController();
  bool postojiLike = false;
  bool postojiKomentar = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _novostLikeCommentProvider = context.read<NovostLikeCommentProvider>();

    loadData();
  }

  loadData() async {
    //ukupni lajkovi
    var hasLikes = await _novostLikeCommentProvider
        .get(filter: {'novostId': widget.novost?.novostId, 'isLike': true});
    //ukupni komentari
    var hasComments = await _novostLikeCommentProvider.get(filter: {
      'novostId': widget.novost?.novostId,
      'isKorisnikIncluded': true,
      'isNovostIncluded': true,
      'isComment': true
    });

    //da li postoji novostLikeCommentId
    var novostlikecomment = await _novostLikeCommentProvider.get(filter: {
      'novostId': widget.novost?.novostId,
      'korisnikId': LoggedUser.id,
    });

    //da li je korisnik lajkao
    var isLiked = await _novostLikeCommentProvider.get(filter: {
      'novostId': widget.novost?.novostId,
      'korisnikId': LoggedUser.id,
      'isLike': true
    });
    //da li je korisnik komentarisao
    var isComment = await _novostLikeCommentProvider.get(filter: {
      'novostId': widget.novost?.novostId,
      'korisnikId': LoggedUser.id,
      'isComment': true
    });

    // Add a listener to get the value whenever the text changes
    _commentController.addListener(() {
      String currentText = _commentController.text; // Access the current text
      setState(() {
        textCommentController = currentText;
      });
      print('Current Text: $currentText');
    });

    setState(() {
      isLoadingLikesComments = false;
      _novostLikeCommentResult = hasComments;
      likesCount = hasLikes.count;
      commentsCount = hasComments.count;
      liked = isLiked.count != 0 ? true : false;
      commented = isComment.count != 0 ? true : false;
      novostLikeCommentId = novostlikecomment.count != 0
          ? novostlikecomment.result[0].novostLikeCommentId
          : 0;
      currentComment =
          isComment.count != 0 ? isComment.result[0].komentar : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        selectedIndex: widget.poslaniKorisnikId != null ? 3 : 0,
        title: "Detalji novosti",
        child: isLoadingLikesComments == false
            ? Container(
                width: 800,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SingleChildScrollView(
                    child: Column(children: [
                      dugmeNazad(),
                      Text(
                        "${widget.novost?.naslov ?? ""}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            //fontFamily: 'BeckyTahlia',
                            //fontStyle: FontStyle.italic,
                            fontSize: 26,
                            color: Colors.pinkAccent),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      widget.novost?.slikaNovost != null &&
                              widget.novost?.slikaNovost!.slika != ""
                          ? imageContainer(
                              widget.novost!.slikaNovost!.slika, 300, 500)
                          : noImageContainer(300, 500),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Datum objavljivanja: ${formatDate(widget.novost!.datumKreiranja!)}",
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "${widget.novost?.sadrzaj}",
                        textAlign: TextAlign.justify,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text("${likesCount}"),
                              TextButton(
                                  onPressed: () async {
                                    try {
                                      if (liked == false) {
                                        if (novostLikeCommentId != 0) {
                                          //edit
                                          var obj =
                                              await _novostLikeCommentProvider
                                                  .update(novostLikeCommentId!,
                                                      LikeNovostRequest());
                                        } else {
                                          //insert
                                          var obj =
                                              await _novostLikeCommentProvider
                                                  .insert(LikeNovostRequest());

                                          setState(() {
                                            novostLikeCommentId =
                                                obj.novostLikeCommentId;
                                          });
                                        }
                                      } else if (liked == true &&
                                          commented == false) {
                                        var del =
                                            await _novostLikeCommentProvider
                                                .delete(novostLikeCommentId!);
                                        setState(() {
                                          novostLikeCommentId = 0;
                                        });
                                      } else if (liked == true &&
                                          commented == true) {
                                        //edit
                                        var obj =
                                            await _novostLikeCommentProvider
                                                .update(novostLikeCommentId!,
                                                    LikeNovostRequest());
                                      }

                                      var hasLikes =
                                          await _novostLikeCommentProvider.get(
                                              filter: {
                                            'novostId': widget.novost?.novostId,
                                            'isLike': true
                                          });

                                      setState(() {
                                        liked = !liked;
                                        likesCount = hasLikes.count;
                                      });
                                    } catch (err) {
                                      print(err.toString());
                                      _showValidationError();
                                    }
                                  },
                                  child: liked == true
                                      ? Icon(Icons.thumb_up)
                                      : Icon(Icons.thumb_up_alt_outlined)),
                            ],
                          ),
                          Row(
                            children: [
                              TextButton(
                                  onPressed: () {
                                    if (commentsCount != 0) {
                                      setState(() {
                                        showComments = !showComments;
                                      });
                                    }
                                  },
                                  child: commented == true
                                      ? Icon(Icons.comment)
                                      : Icon(Icons.comment_outlined)),
                              Text("${commentsCount}"),
                            ],
                          ),
                        ],
                      ),
                      showComments == true
                          ? Container(
                              height: 270,
                              width: 800,
                              child: Card(
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: _showComments(),
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      commented == false
                          ? _createComment()
                          : Container() //samo jednom moze komentarisati
                    ]),
                  ),
                ))
            : Container());
  }

  Widget _createComment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Napišite komentar:",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.0),
        TextField(
          controller: _commentController,
          maxLines: 5, // Allows multi-line input
          decoration: InputDecoration(
            hintText: "Napišite komentar ovdje... (maksimalno 15 riječi.)",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        SizedBox(height: 12.0),
        _commentController.text != ""
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      print("komentar: ${_commentController.text.trim()}");
                      _commentController.text.trim() != ""
                          ? _saveComment()
                          : _showValidationError();
                    },
                    child: Text("Spasi komentar"),
                  ),
                ],
              )
            : Container(),
      ],
    );
  }

  void _saveComment() async {
    try {
      var request = NovostLikeCommentInsertUpdate(
        LoggedUser.id,
        widget.novost?.novostId,
        liked,
        _commentController.text,
      );

      if (novostLikeCommentId == 0) {
        try {
          var obj = await _novostLikeCommentProvider.insert(request);
          setState(() {
            novostLikeCommentId = obj.novostLikeCommentId;
            commented = true;
          });
          showSuccessMessage();
        } catch (err) {
          _showValidationError();
          print(err.toString());
        }
      } else {
        try {
          await _novostLikeCommentProvider.update(
              novostLikeCommentId!, request);
          setState(() {
            commented = true;
          });
          showSuccessMessage();
        } catch (err) {
          _showValidationError();
          print(err.toString());
        }
      }
      var data = await _novostLikeCommentProvider.get(filter: {
        'novostId': widget.novost?.novostId,
        'isKorisnikIncluded': true,
        'isNovostIncluded': true,
        'isComment': true
      });
      setState(() {
        commentsCount = data.count;
        _novostLikeCommentResult = data;
        currentComment = _commentController.text;
      });
    } catch (err) {
      _showValidationError();
    }
  }

  Widget _showComments() {
    return Container(
      width: 800,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 230,
            child: GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1, // Number of items in a row (1 in this case)
                childAspectRatio:
                    2 / 1, // Adjust the width-to-height ratio here
                mainAxisSpacing: 8, // Spacing between items vertically
              ),
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
      return [Text("Nema nijedan komentar za ovu novost.")];
    }

    List<Widget> list = data
        .map((x) => Container(
              decoration: BoxDecoration(
                  //color: Colors.amber,
                  border: Border.all(width: 2),
                  borderRadius: BorderRadius.circular(20)),
              child: InkWell(
                onTap: () {
                  if (x.korisnikId == LoggedUser.id) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => EditKomentarNovost(
                              novostLikeComment: x,
                              novost: widget.novost,
                              poslaniKorisnikId: null,
                            )));
                  }
                },
                child: Stack(children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 15.0, right: 60.0, bottom: 15.0, left: 15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.person),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "${x.korisnik?.ime} ${x.korisnik?.prezime}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.comment),
                            SizedBox(width: 5),
                            Expanded(
                              // Ensures it takes the available space
                              child: SingleChildScrollView(
                                scrollDirection:
                                    Axis.horizontal, // Scrolls horizontally
                                child: Text("${splitText(x.komentar, 5)}"),
                              ),
                            ),
                          ],
                        ),
                        x.datumModifikovanja == null
                            ? Row(
                                children: [
                                  Icon(Icons.date_range),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text("${formatDate(x.datumKreiranja)}"),
                                ],
                              )
                            : Row(
                                children: [
                                  Icon(Icons.date_range),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text("${formatDate(x.datumModifikovanja)}"),
                                ],
                              )
                      ],
                    ),
                  ),
                  Positioned(
                    top: 60,
                    right: 20,
                    child: x.korisnikId == LoggedUser.id
                        ? IconButton(
                            onPressed: () {
                              _deleteConfirmationDialog(x);
                            },
                            icon: Icon(Icons.delete),
                            color: Colors.red,
                          )
                        : Container(),
                  )
                ]),
              ),
            ))
        .cast<Widget>()
        .toList();

    return list;
  }

  void _showValidationError() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text("Greška"),
              content: Text(
                  "Nije zadovoljena validacija. Komentar treba sačinjavati riječi a ne prazna mjesta i ne smije biti duži od 15 riječi. \nMolimo pokušajte ponovo."),
              actions: <Widget>[
                TextButton(
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.pink),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Shvatam"))
              ],
            ));
  }

  void showSuccessMessage() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text("Informacija o uspjehu"),
              content: Text("Uspješno izvršena akcija!"),
              actions: <Widget>[
                TextButton(
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.pink),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Ok"))
              ],
            ));
  }

  LikeNovostRequest() {
    if (liked == true && commented == true) {
      var request = NovostLikeCommentInsertUpdate(
          LoggedUser.id, widget.novost?.novostId, false, currentComment);
      return request;
    } else if (liked == true && commented == false) {
      var request = NovostLikeCommentInsertUpdate(
          LoggedUser.id, widget.novost?.novostId, false, null);
      return request;
    } else if (liked == false && commented == true) {
      var request = NovostLikeCommentInsertUpdate(
          LoggedUser.id, widget.novost?.novostId, true, currentComment);
      return request;
    } else if (liked == false && commented == false) {
      var request = NovostLikeCommentInsertUpdate(
          LoggedUser.id, widget.novost?.novostId, true, null);
      return request;
    }
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
    if (liked == true) {
      var deleted = await _novostLikeCommentProvider.update(
          e.novostLikeCommentId!,
          NovostLikeCommentInsertUpdate(
              LoggedUser.id, widget.novost?.novostId, liked, null));
    } else {
      var deleted =
          await _novostLikeCommentProvider.delete(novostLikeCommentId!);
      setState(() {
        novostLikeCommentId = 0;
      });
    }

    //ukupni komentari
    var hasComments = await _novostLikeCommentProvider.get(filter: {
      'novostId': widget.novost?.novostId,
      'isKorisnikIncluded': true,
      'isNovostIncluded': true,
      'isComment': true
    });

    setState(() {
      _commentController.text = "";
      isLoadingLikesComments = false;
      _novostLikeCommentResult = hasComments;
      commentsCount = hasComments.count;
      commented = false;
      currentComment = null;
      showComments = false;
    });
  }

  // split text every 5 words
  String splitText(String text, int wordsPerLine) {
    List<String> words = text.split(' '); // Split by space
    List<String> lines = [];

    for (int i = 0; i < words.length; i += wordsPerLine) {
      lines.add(words
          .sublist(i, (i + wordsPerLine).clamp(0, words.length))
          .join(' '));
    }

    return lines.join('\n'); // Join with new lines
  }

  dugmeNazad() {
    return Row(
      children: [
        TextButton(
            onPressed: () {
              if (widget.poslaniKorisnikId != null) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MojiLajkoviNovosti()));
              } else {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => HomePage()));
              }
            },
            child: Icon(Icons.arrow_back)),
      ],
    );
  }
}
