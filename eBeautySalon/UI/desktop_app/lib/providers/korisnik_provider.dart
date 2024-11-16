import 'package:desktop_app/models/korisnik.dart';
import 'base_provider.dart';

class KorisnikProvider extends BaseProvider<Korisnik> {
  KorisnikProvider()
      : super("Korisnici",
            "isAdmin=false&isZaposlenik=false"); 

  @override
  Korisnik fromJson(data) {
    // TODO: implement fromJson
    return Korisnik.fromJson(data);
  }

}
