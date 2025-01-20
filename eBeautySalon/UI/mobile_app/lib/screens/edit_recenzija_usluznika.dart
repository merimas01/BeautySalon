import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:mobile_app/models/recenzija_usluznika.dart';
import 'package:mobile_app/models/recenzija_usluznika_insert_update.dart';
import 'package:mobile_app/providers/recenzije_usluznika_provider.dart';
import 'package:mobile_app/widgets/master_screen.dart';
import 'package:provider/provider.dart';

import '../providers/recenzije_usluga_provider.dart';
import '../utils/util.dart';

class EditRecenzijaUsluznika extends StatefulWidget {
  RecenzijaUsluznika? recenzijaUsluznika;
  EditRecenzijaUsluznika({super.key, this.recenzijaUsluznika});

  @override
  State<EditRecenzijaUsluznika> createState() => _EditRecenzijaUsluznikaState();
}

class _EditRecenzijaUsluznikaState extends State<EditRecenzijaUsluznika> {
  Map<String, dynamic> _initialValue = {};
  late RecenzijaUsluznikaProvider _recenzijaUsluznikaProvider;
  TextEditingController _ocjenaController = TextEditingController();
  TextEditingController _commentController = TextEditingController();
  int _rating = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialValue = {
      'ocjena': widget.recenzijaUsluznika?.ocjena.toString(),
      'komentar': widget.recenzijaUsluznika?.komentar,
    };

    _recenzijaUsluznikaProvider = context.read<RecenzijaUsluznikaProvider>();

    setState(() {
      _ocjenaController.text =
          widget.recenzijaUsluznika?.ocjena?.toString() ?? "";
      _commentController.text = widget.recenzijaUsluznika?.komentar ?? "";
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
                  "${widget.recenzijaUsluznika?.usluznik?.korisnik?.ime ?? ""} ${widget.recenzijaUsluznika?.usluznik?.korisnik?.prezime ?? ""}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontFamily: 'BeckyTahlia',
                      fontSize: 26,
                      color: Colors.pinkAccent),
                ),
                SizedBox(
                  height: 10,
                ),
                widget.recenzijaUsluznika?.usluznik?.korisnik?.slikaProfila != null &&
                        widget.recenzijaUsluznika?.usluznik?.korisnik?.slikaProfila
                                ?.slika !=
                            null &&
                        widget.recenzijaUsluznika?.usluznik?.korisnik?.slikaProfila
                                ?.slika !=
                            ""
                    ? Container(
                        height: 200,
                        width: 200,
                        child: ImageFromBase64String(widget
                            .recenzijaUsluznika!.usluznik!.korisnik!.slikaProfila!.slika),
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
                      "${formatDate(widget.recenzijaUsluznika!.datumKreiranja!)}",
                  enabled: false,
                ),
                widget.recenzijaUsluznika?.datumModificiranja != null
                    ? TextFormField(
                        decoration:
                            InputDecoration(labelText: "Datum modificiranja:"),
                        initialValue:
                            "${formatDate(widget.recenzijaUsluznika!.datumModificiranja!)}",
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
                  controller: _commentController,
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () async {
                      try {
                        var request = RecenzijaUsluznikaInsertUpdate(
                            _rating,
                            _commentController.text,
                            LoggedUser.id,
                            widget.recenzijaUsluznika?.usluznikId);
                        var obj = await _recenzijaUsluznikaProvider.update(
                            widget.recenzijaUsluznika!.recenzijaUsluznikaId!,
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
    return MasterScreenWidget(title: "Modifikacija recenzije usluznika", child: _showDetails());
  }
}
