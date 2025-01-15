import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:mobile_app/models/rezervacija.dart';
import 'package:mobile_app/utils/util.dart';
import 'package:mobile_app/widgets/master_screen.dart';

class RezervacijaDetails extends StatefulWidget {
  Rezervacija? rezervacija;
  RezervacijaDetails({super.key, this.rezervacija});

  @override
  State<RezervacijaDetails> createState() => _RezervacijaDetailsState();
}

class _RezervacijaDetailsState extends State<RezervacijaDetails> {
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
            initialValue: widget.rezervacija?.status?.opis,
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
          SizedBox(height: 10,),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Background color
                foregroundColor: Colors.white, // Text color
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 12), // Optional: Adjust padding
              ),
              onPressed: () {
                //Kad se klikne na ovaj x, setuje se status na otkazana.
                //Ovo dugme se pojavljuje samo ako je narudzba Nova.
                //otvara se dijalog prozor - da li zelite da otkazete narudzbu
              },
              child: Text(
                "Otkazi narudzbu",
              //  style: TextStyle(color: Colors.red),
              )),
        ],
      ),
    );
  }
}
