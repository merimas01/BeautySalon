import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:mobile_app/models/novost_like_comment.dart';
import 'package:mobile_app/models/novost_like_comment_insert_update.dart';
import 'package:mobile_app/providers/novost_like_comment_provider.dart';
import 'package:mobile_app/screens/moji_komentari_novosti.dart';
import 'package:provider/provider.dart';

import '../utils/util.dart';
import '../widgets/master_screen.dart';

class EditKomentarNovost extends StatefulWidget {
  NovostLikeComment? novostLikeComment;
  EditKomentarNovost({super.key, this.novostLikeComment});

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
                      color: Colors.pinkAccent,),
                ),
                SizedBox(
                  height: 10,
                ),
                widget.novostLikeComment?.novost?.slikaNovost != null &&
                        widget.novostLikeComment?.novost?.slikaNovost?.slika !=
                            null &&
                        widget.novostLikeComment?.novost?.slikaNovost?.slika !=
                            ""
                    ? Container(
                        height: 200,
                        width: 200,
                        child: ImageFromBase64String(widget
                            .novostLikeComment!.novost!.slikaNovost!.slika),
                      )
                    : Container(
                        child: Image.asset(
                          "assets/images/noImage.jpg",
                        ),
                        height: 200,
                        width: 200,
                      ),
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
                  decoration: InputDecoration(labelText: "Komentar:"),
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
                          _commentController.text,
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
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MojiKomentariNovosti()));
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
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MojiKomentariNovosti()));
            },
            child: Icon(Icons.arrow_back)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        title: "Modifikacija komentara novosti", child: _showDetails());
  }
}
