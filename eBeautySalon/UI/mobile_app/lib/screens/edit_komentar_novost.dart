import 'package:flutter/material.dart';
import 'package:mobile_app/models/novost_like_comment.dart';
import 'package:mobile_app/models/novost_like_comment_insert_update.dart';
import 'package:mobile_app/providers/novost_like_comment_provider.dart';
import 'package:mobile_app/screens/moji_komentari_novosti.dart';
import 'package:mobile_app/screens/novost_details.dart';
import 'package:provider/provider.dart';

import '../models/novost.dart';
import '../utils/util.dart';
import '../widgets/master_screen.dart';

class EditKomentarNovost extends StatefulWidget {
  NovostLikeComment? novostLikeComment;
  Novost? novost;
  int? poslaniKorisnikId;
  EditKomentarNovost(
      {super.key, this.novostLikeComment, this.novost, this.poslaniKorisnikId});

  @override
  State<EditKomentarNovost> createState() => _EditKomentarNovostState();
}

class _EditKomentarNovostState extends State<EditKomentarNovost> {
  Map<String, dynamic> _initialValue = {};
  late NovostLikeCommentProvider _novostLikeCommentProvider;
  TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialValue = {
      'komentar': widget.novostLikeComment?.komentar,
    };

    _novostLikeCommentProvider = context.read<NovostLikeCommentProvider>();

    setState(() {
      _commentController.text = widget.novostLikeComment?.komentar ?? "";
    });
  }

  _showDetails() {
    return Container(
        width: 800,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                dugmeNazad(),
                Text(
                  "${widget.novostLikeComment?.novost?.naslov ?? ""}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    //fontFamily: 'BeckyTahlia',
                    fontSize: 26,
                    color: Colors.pinkAccent,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                widget.novostLikeComment?.novost?.slikaNovost != null &&
                        widget.novostLikeComment?.novost?.slikaNovost?.slika !=
                            null &&
                        widget.novostLikeComment?.novost?.slikaNovost?.slika !=
                            ""
                    ? imageContainer(
                        widget.novostLikeComment!.novost!.slikaNovost!.slika,
                        300,
                        500)
                    : noImageContainer(300, 500),
                TextFormField(
                  decoration: InputDecoration(labelText: "Datum kreiranja:"),
                  initialValue:
                      "${formatDate(widget.novostLikeComment!.datumKreiranja!)}",
                  enabled: false,
                ),
                widget.novostLikeComment?.datumModifikovanja != null
                    ? TextFormField(
                        decoration:
                            InputDecoration(labelText: "Datum modificiranja:"),
                        initialValue:
                            "${formatDate(widget.novostLikeComment!.datumModifikovanja!)}",
                        enabled: false,
                      )
                    : Container(),
                TextFormField(
                  decoration: InputDecoration(labelText: "Komentar:", hintText: "Ovdje napišite komentar..."),
                  enabled: true,
                  maxLines: null,
                  controller: _commentController,
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () async {
                      try {
                        var request = NovostLikeCommentInsertUpdate(
                          LoggedUser.id,
                          widget.novostLikeComment?.novostId,
                          widget.novostLikeComment?.isLike,
                          _commentController.text == ""
                              ? null
                              : _commentController.text,
                        );
                        var obj = await _novostLikeCommentProvider.update(
                            widget.novostLikeComment!.novostLikeCommentId!,
                            request);
                        if (obj != null) {
                          showSuccessMessage();
                        }
                      } catch (err) {
                        print(err.toString());
                        _showValidationError();
                      }
                    },
                    child: Text("Spasi promjene"))
              ],
            ),
          ),
        ));
  }

  void _showValidationError() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text("Greška"),
              content:
                  Text("Nije zadovoljena validacija. Molimo pokušajte ponovo."),
              actions: <Widget>[
                TextButton(
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
                    onPressed: () {
                      if (widget.poslaniKorisnikId != null) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => MojiKomentariNovosti()));
                      } else {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => NovostDetailsScreen(
                                  novost: widget.novost,
                                )));
                      }
                    },
                    child: Text("Ok"))
              ],
            ));
  }

  dugmeNazad() {
    return Row(
      children: [
        TextButton(
            onPressed: () {
              if (widget.poslaniKorisnikId != null) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MojiKomentariNovosti()));
              } else {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NovostDetailsScreen(
                          novost: widget.novost,
                        )));
              }
            },
            child: Icon(Icons.arrow_back)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        selectedIndex: widget.poslaniKorisnikId != null ? 3 : 0,
        title: "Modifikacija komentara novosti",
        child: _showDetails());
  }
}
