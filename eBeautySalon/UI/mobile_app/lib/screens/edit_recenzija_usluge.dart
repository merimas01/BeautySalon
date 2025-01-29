import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mobile_app/models/recenzija_usluge.dart';
import 'package:mobile_app/providers/recenzije_usluga_provider.dart';
import 'package:mobile_app/utils/util.dart';
import 'package:mobile_app/widgets/master_screen.dart';
import 'package:provider/provider.dart';

import '../models/recenzija_usluge_insert_update.dart';

class EditRecenzijaUsluge extends StatefulWidget {
  RecenzijaUsluge? recenzijaUsluge;
  EditRecenzijaUsluge({super.key, this.recenzijaUsluge});

  @override
  State<EditRecenzijaUsluge> createState() => _EditRecenzijaUslugeState();
}

class _EditRecenzijaUslugeState extends State<EditRecenzijaUsluge> {
  Map<String, dynamic> _initialValue = {};
  late RecenzijaUslugeProvider _recenzijaUslugeProvider;
  TextEditingController _ocjenaController = TextEditingController();
  TextEditingController _commentController = TextEditingController();
  int _rating = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialValue = {
      'ocjena': widget.recenzijaUsluge?.ocjena.toString(),
      'komentar': widget.recenzijaUsluge?.komentar,
    };

    _recenzijaUslugeProvider = context.read<RecenzijaUslugeProvider>();

    setState(() {
      _ocjenaController.text = widget.recenzijaUsluge?.ocjena?.toString() ?? "";
      _commentController.text = widget.recenzijaUsluge?.komentar ?? "";
      _rating = double.parse(_initialValue['ocjena']).toInt();
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
                Text(
                  "${widget.recenzijaUsluge?.usluga?.naziv ?? ""}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontFamily: 'BeckyTahlia',
                      fontSize: 26,
                      color: Colors.pinkAccent),
                ),
                SizedBox(
                  height: 10,
                ),
                widget.recenzijaUsluge?.usluga?.slikaUsluge != null &&
                        widget.recenzijaUsluge?.usluga?.slikaUsluge?.slika !=
                            null &&
                        widget.recenzijaUsluge?.usluga?.slikaUsluge?.slika != ""
                    ? Container(
                        height: 200,
                        width: 200,
                        child: ImageFromBase64String(
                            widget.recenzijaUsluge!.usluga!.slikaUsluge!.slika),
                      )
                    : Container(
                        child: Image.asset(
                          "assets/images/noImage.jpg",
                        ),
                        height: 200,
                        width: 200,
                      ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Kategorija:"),
                  initialValue:
                      "${widget.recenzijaUsluge?.usluga?.kategorija?.naziv}",
                  enabled: false,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Datum kreiranja:"),
                  initialValue:
                      "${formatDate(widget.recenzijaUsluge!.datumKreiranja!)}",
                  enabled: false,
                ),
                widget.recenzijaUsluge?.datumModificiranja != null
                    ? TextFormField(
                        decoration:
                            InputDecoration(labelText: "Datum modificiranja:"),
                        initialValue:
                            "${formatDate(widget.recenzijaUsluge!.datumModificiranja!)}",
                        enabled: false,
                      )
                    : Container(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _rating = index + 1; // Update rating on tap
                          print("rating: $_rating");
                        });
                      },
                      child: Icon(
                        Icons.star,
                        color: index < _rating ? Colors.amber : Colors.grey,
                        size: 40,
                      ),
                    );
                  }),
                ),
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
                        var request = RecenzijaUslugeInsertUpdate(
                            _rating,
                            _commentController.text,
                            LoggedUser.id,
                            widget.recenzijaUsluge?.uslugaId);
                        var obj = await _recenzijaUslugeProvider.update(
                            widget.recenzijaUsluge!.recenzijaUslugeId!,
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
                      Navigator.pop(context);
                    },
                    child: Text("Ok"))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(title: "Modifikacija recenzije usluge", child: _showDetails());
  }
}
