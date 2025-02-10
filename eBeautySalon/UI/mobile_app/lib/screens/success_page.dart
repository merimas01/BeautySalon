import 'package:mobile_app/providers/rezervacije_provider.dart';
import 'package:mobile_app/screens/moje_rezervacije.dart';

import '../models/rezervacija.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/rezervacija_update.dart';
import '../utils/util.dart';

class SuccessPage extends StatefulWidget {
  final Rezervacija? lastRezervacija;

  SuccessPage({super.key, this.lastRezervacija});
  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  late RezervacijeProvider _rezervacijeProvider;
  late final Rezervacija? _lastRezervacija;

  @override
  void initState() {
    super.initState();
    _lastRezervacija = widget.lastRezervacija;

    _rezervacijeProvider = context.read<RezervacijeProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 100),
            SizedBox(height: 20),
            Text(
              "Uspjesno ste platili!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            _lastRezervacija != null
                ? ElevatedButton(
                    onPressed: () async {
                      //edit polje platio=true
                      var request = RezervacijaUpdate(
                          LoggedUser.id,
                          _lastRezervacija!.uslugaId,
                          _lastRezervacija!.terminId,
                          _lastRezervacija!.statusId,
                          _lastRezervacija!.isArhiva,
                          _lastRezervacija!.datumRezervacije,
                          _lastRezervacija!.isArhivaKorisnik,
                          false,
                          true);

                      try {
                        var update = await _rezervacijeProvider.update(
                            _lastRezervacija!.rezervacijaId!, request);
                      } catch (err) {
                        print(err.toString());
                      }

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => MojeRezervacije(),
                        ),
                      );
                    },
                    child: const Text("Pregled rezervacija"),
                  )
                : Text(""),
          ],
        ),
      ),
    );
  }
}
