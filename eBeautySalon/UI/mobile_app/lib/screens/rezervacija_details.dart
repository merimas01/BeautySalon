import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:mobile_app/models/rezervacija.dart';
import 'package:mobile_app/models/rezervacija_update.dart';
import 'package:mobile_app/providers/rezervacije_provider.dart';
import 'package:mobile_app/utils/constants.dart';
import 'package:mobile_app/utils/util.dart';
import 'package:mobile_app/widgets/master_screen.dart';
import 'package:provider/provider.dart';

class RezervacijaDetails extends StatefulWidget {
  Rezervacija? rezervacija;
  RezervacijaDetails({super.key, this.rezervacija});

  @override
  State<RezervacijaDetails> createState() => _RezervacijaDetailsState();
}

class _RezervacijaDetailsState extends State<RezervacijaDetails> {
  late RezervacijeProvider _rezervacijeProvider;
  TextEditingController _statusController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _rezervacijeProvider = context.read<RezervacijeProvider>();

    setState(() {
      _statusController.text = widget.rezervacija?.status?.opis ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "",
      child: _buildDetails(),
    );
  }

  Widget _naslov() {
    return Text(
      "Detalji rezervacije",
      textAlign: TextAlign.center,
      style: const TextStyle(
          fontFamily: 'BeckyTahlia', fontSize: 26, color: Colors.pinkAccent),
    );
  }

  _buildDetails() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          _naslov(),
          TextFormField(
            decoration: InputDecoration(labelText: "Sifra:"),
            initialValue: widget.rezervacija?.sifra,
            enabled: false,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: "Status:"),
            controller: _statusController,
            enabled: false,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: "Ime:"),
            initialValue: widget.rezervacija?.korisnik?.ime,
            enabled: false,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: "Prezime:"),
            initialValue: widget.rezervacija?.korisnik?.prezime,
            enabled: false,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: "Usluga:"),
            initialValue: widget.rezervacija?.usluga?.naziv,
            enabled: false,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: "Kategorija usluge:"),
            initialValue: widget.rezervacija?.usluga?.kategorija?.naziv,
            enabled: false,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: "Termin:"),
            initialValue: widget.rezervacija?.termin?.opis,
            enabled: false,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: "Datum:"),
            initialValue: formatDate(widget.rezervacija!.datumRezervacije!),
            enabled: false,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: "Podaci o placanju:"),
            initialValue: "",
            enabled: false,
          ),
          SizedBox(
            height: 10,
          ),
          widget.rezervacija?.status?.opis == "Nova"
              ? ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Background color
                    foregroundColor: Colors.white, // Text color
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12), // Optional: Adjust padding
                  ),
                  onPressed: () {
                    _showDialogOtkaziRezervaciju(widget.rezervacija!);
                  },
                  child: Text(
                    "Otkaži narudžbu",
                  ))
              : Container(),
        ],
      ),
    );
  }

  void _showDialogOtkaziRezervaciju(Rezervacija e) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text(
                'Potvrda o otkazivanju rezervacije',
                textAlign: TextAlign.center,
              ),
              content: Text(
                'Jeste li sigurni da želite otkazati izabranu rezervaciju? (Ova akcija se ne moze povratiti.)',
                textAlign: TextAlign.center,
              ),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.grey),
                  child: Text('Ne'),
                  onPressed: () {
                    Navigator.of(context).pop(); //zatvori dijalog
                  },
                ),
                TextButton(
                  child: Text('Da'),
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red),
                  onPressed: () async {
                    Navigator.of(context).pop(); //zatvori dijalog
                    _otkaziRezervaciju(e);
                  },
                ),
              ],
            ));
  }

  void _otkaziRezervaciju(e) async {
    try {
      var obj = await _rezervacijeProvider.OtkaziRezervaciju(e.rezervacijaId);
      var rezervacija = await _rezervacijeProvider.getById(e.rezervacijaId);
      setState(() {
        widget.rezervacija = rezervacija;
        _statusController.text = "Otkazana";
      });
      showSuccessMessage();
    } catch (err) {
      print(err.toString());
      showError();
    }
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

  void showError() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text("Greška"),
              content: Text("Desilo se nešto loše. Molimo pokušajte ponovo."),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Shvatam"))
              ],
            ));
  }
}
