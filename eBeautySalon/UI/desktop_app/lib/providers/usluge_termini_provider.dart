import '../models/usluga_termin.dart';
import 'base_provider.dart';

class UslugeTerminiProvider extends BaseProvider<UslugaTermin>{
  UslugeTerminiProvider() : super("UslugeTermini", "isUslugaIncluded=true&isTerminIncluded=true");

  @override
  UslugaTermin fromJson(data) {
    // TODO: implement fromJson
    return UslugaTermin.fromJson(data);
  }
}
