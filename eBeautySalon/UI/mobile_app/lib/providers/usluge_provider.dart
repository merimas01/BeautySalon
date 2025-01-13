import '../models/usluga.dart';
import 'base_provider.dart';

class UslugeProvider extends BaseProvider<Usluga>{
  UslugeProvider() : super("Usluge", "isKategorijaIncluded=true&isSlikaIncluded=true");

  @override
  Usluga fromJson(data) {
    // TODO: implement fromJson
    return Usluga.fromJson(data);
  }
}
