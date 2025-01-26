import '../models/termin.dart';
import 'base_provider.dart';

class TerminProvider extends BaseProvider<Termin>{
  TerminProvider() : super("Termini", "");

  @override
  Termin fromJson(data) {
    // TODO: implement fromJson
    return Termin.fromJson(data);
  }
}
