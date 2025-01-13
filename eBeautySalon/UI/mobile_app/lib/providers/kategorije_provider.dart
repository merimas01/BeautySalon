import '../models/kategorija.dart';
import 'base_provider.dart';

class KategorijeProvider extends BaseProvider<Kategorija> {
  KategorijeProvider()
      : super("Kategorije", "");

  @override
  Kategorija fromJson(data) {
    // TODO: implement fromJson
    return Kategorija.fromJson(data);
  }
}
