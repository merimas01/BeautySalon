import 'package:desktop_app/models/rezervacija.dart';
import 'base_provider.dart';

class RezervacijeProvider extends BaseProvider<Rezervacija> {
  RezervacijeProvider()
      : super("Rezervacije", "isKorisnikIncluded=true&isUslugaIncluded=true&isTerminIncluded=true&isStatusIncluded=true");

  @override
  Rezervacija fromJson(data) {
    // TODO: implement fromJson
    return Rezervacija.fromJson(data);
  }
}
