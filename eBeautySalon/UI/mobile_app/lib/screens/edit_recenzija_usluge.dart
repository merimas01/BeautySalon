import 'package:flutter/material.dart';
import 'package:mobile_app/models/recenzija_usluge.dart';
import 'package:mobile_app/providers/recenzije_usluga_provider.dart';
import 'package:mobile_app/providers/usluge_provider.dart';
import 'package:mobile_app/screens/moje_recenzije.dart';
import 'package:mobile_app/screens/sve_recenzije_usluge.dart';
import 'package:mobile_app/utils/util.dart';
import 'package:mobile_app/widgets/master_screen.dart';
import 'package:provider/provider.dart';
import '../models/recenzija_usluge_insert_update.dart';
import '../models/usluga.dart';

class EditRecenzijaUsluge extends StatefulWidget {
  RecenzijaUsluge? recenzijaUsluge;
  int? poslaniKorisnikId;
  EditRecenzijaUsluge(
      {super.key, this.recenzijaUsluge, this.poslaniKorisnikId});

  @override
  State<EditRecenzijaUsluge> createState() => _EditRecenzijaUslugeState();
}

class _EditRecenzijaUslugeState extends State<EditRecenzijaUsluge> {
  Map<String, dynamic> _initialValue = {};
  late RecenzijaUslugeProvider _recenzijaUslugeProvider;
  late UslugeProvider _uslugeProvider;
  TextEditingController _ocjenaController = TextEditingController();
  TextEditingController _commentController = TextEditingController();
  int _rating = 0;
  Usluga? _usluga;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialValue = {
      'ocjena': widget.recenzijaUsluge?.ocjena.toString(),
      'komentar': widget.recenzijaUsluge?.komentar,
    };

    _recenzijaUslugeProvider = context.read<RecenzijaUslugeProvider>();
    _uslugeProvider = context.read<UslugeProvider>();

    setState(() {
      _ocjenaController.text = widget.recenzijaUsluge?.ocjena?.toString() ?? "";
      _commentController.text = widget.recenzijaUsluge?.komentar ?? "";
      _rating = double.parse(_initialValue['ocjena']).toInt();
    });

    getUsluga();
  }

  getUsluga() async {
    var usluga =
        await _uslugeProvider.getById(widget.recenzijaUsluge!.uslugaId!);
    setState(() {
      _usluga = usluga;
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
                  "${widget.recenzijaUsluge?.usluga?.naziv ?? ""}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      //fontFamily: 'BeckyTahlia',
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
                    ? imageContainer(
                        widget.recenzijaUsluge!.usluga!.slikaUsluge!.slika,
                        300,
                        500)
                    : noImageContainer(300, 500),
                SizedBox(
                  height: 10,
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
                  decoration: InputDecoration(
                      labelText: "Komentar:",
                      hintText: "Ovdje napišite komentar..."),
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
                            _commentController.text == ""
                                ? null
                                : _commentController.text,
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
                      if (widget.poslaniKorisnikId != null) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => MojeRecenzije()));
                      } else {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SveRecenzijeUsluge(
                                  usluga: _usluga,
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
        title: "Modifikacija recenzije usluge",
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
                    builder: (context) => SveRecenzijeUsluge(
                          usluga: _usluga,
                        )));
              }
            },
            child: Icon(Icons.arrow_back)),
      ],
    );
  }
}
