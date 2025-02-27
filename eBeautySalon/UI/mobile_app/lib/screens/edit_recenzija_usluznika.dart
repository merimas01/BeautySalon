import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:mobile_app/models/recenzija_usluznika.dart';
import 'package:mobile_app/models/recenzija_usluznika_insert_update.dart';
import 'package:mobile_app/providers/recenzije_usluznika_provider.dart';
import 'package:mobile_app/screens/sve_recenzije_usluznika.dart';
import 'package:mobile_app/widgets/master_screen.dart';
import 'package:provider/provider.dart';

import '../models/usluga.dart';
import '../models/zaposlenik.dart';
import '../providers/zaposlenici_provider.dart';
import '../utils/util.dart';
import 'moje_recenzije.dart';

class EditRecenzijaUsluznika extends StatefulWidget {
  RecenzijaUsluznika? recenzijaUsluznika;
  int? poslaniKorisnikId;
  String? prosjecnaOcjena;
  String? totalReviws;
  Usluga? usluga;
  EditRecenzijaUsluznika(
      {super.key,
      this.recenzijaUsluznika,
      this.poslaniKorisnikId,
      this.prosjecnaOcjena,
      this.totalReviws,
      this.usluga});

  @override
  State<EditRecenzijaUsluznika> createState() => _EditRecenzijaUsluznikaState();
}

class _EditRecenzijaUsluznikaState extends State<EditRecenzijaUsluznika> {
  Map<String, dynamic> _initialValue = {};
  late RecenzijaUsluznikaProvider _recenzijaUsluznikaProvider;
  late ZaposleniciProvider _zaposlenikProvider;
  TextEditingController _ocjenaController = TextEditingController();
  TextEditingController _commentController = TextEditingController();
  int _rating = 0;
  Zaposlenik? _usluznik;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialValue = {
      'ocjena': widget.recenzijaUsluznika?.ocjena.toString(),
      'komentar': widget.recenzijaUsluznika?.komentar,
    };

    _recenzijaUsluznikaProvider = context.read<RecenzijaUsluznikaProvider>();
    _zaposlenikProvider = context.read<ZaposleniciProvider>();

    setState(() {
      _ocjenaController.text =
          widget.recenzijaUsluznika?.ocjena?.toString() ?? "";
      _commentController.text = widget.recenzijaUsluznika?.komentar ?? "";
      _rating = double.parse(_initialValue['ocjena']).toInt();
    });

    getUsluznik();
  }

  getUsluznik() async {
    var usluznik = await _zaposlenikProvider
        .getById(widget.recenzijaUsluznika!.usluznikId!);
    setState(() {
      _usluznik = usluznik;
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
                  "${widget.recenzijaUsluznika?.usluznik?.korisnik?.ime ?? ""} ${widget.recenzijaUsluznika?.usluznik?.korisnik?.prezime ?? ""}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      //fontFamily: 'BeckyTahlia',
                      fontSize: 26,
                      color: Colors.pinkAccent),
                ),
                SizedBox(
                  height: 10,
                ),
                widget.recenzijaUsluznika?.usluznik?.korisnik?.slikaProfila !=
                            null &&
                        widget.recenzijaUsluznika?.usluznik?.korisnik
                                ?.slikaProfila?.slika !=
                            null &&
                        widget.recenzijaUsluznika?.usluznik?.korisnik
                                ?.slikaProfila?.slika !=
                            ""
                    ? imageContainer(
                        widget.recenzijaUsluznika!.usluznik!.korisnik!
                            .slikaProfila!.slika,
                        250,
                        300)
                    : noImageContainer(250, 300),
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
                SizedBox(
                  height: 8,
                ),
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
                        var request = RecenzijaUsluznikaInsertUpdate(
                            _rating,
                            _commentController.text == ""
                                ? null
                                : _commentController.text,
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
                      if (widget.poslaniKorisnikId != null) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => MojeRecenzije()));
                      } else {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SveRecenzijeUsluznika(
                                  zaposlenik: _usluznik,
                                  totalReviws: widget.totalReviws,
                                  prosjecnaOcjena: widget.prosjecnaOcjena,
                                  usluga: widget.usluga,
                                )));
                      }
                    },
                    child: Text("Ok"))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        selectedIndex: widget.poslaniKorisnikId != null ? 3 : 1,
        title: "Modifikacija recenzije usluznika",
        child: _showDetails());
  }

  dugmeNazad() {
    return Row(
      children: [
        TextButton(
            onPressed: () {
              if (widget.poslaniKorisnikId != null) {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => MojeRecenzije()));
              } else {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SveRecenzijeUsluznika(
                          zaposlenik: _usluznik,
                          totalReviws: widget.totalReviws,
                          prosjecnaOcjena: widget.prosjecnaOcjena,
                          usluga: widget.usluga,
                          fromEditRecenzija: true,
                        )));
              }
            },
            child: Icon(Icons.arrow_back)),
      ],
    );
  }
}
