import '../models/korisnik_uloga.dart';
import 'base_provider.dart';

class KorisniciUlogeProvider extends BaseProvider<KorisnikUloga>{
  KorisniciUlogeProvider() : super("KorisniciUloge", "");

  @override
  KorisnikUloga fromJson(data) {
    // TODO: implement fromJson
    return KorisnikUloga.fromJson(data);
  }
}
