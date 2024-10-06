import '../models/zaposlenik.dart';
import 'base_provider.dart';

class ZaposleniciProvider extends BaseProvider<Zaposlenik>{
  ZaposleniciProvider() : super("Zaposlenici", "isUslugeIncluded=true&isKorisnikIncluded=true");

  @override
  Zaposlenik fromJson(data) {
    // TODO: implement fromJson
    return Zaposlenik.fromJson(data);
  }
}
