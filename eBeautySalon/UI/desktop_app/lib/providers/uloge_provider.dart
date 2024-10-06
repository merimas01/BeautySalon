import '../models/uloga.dart';
import 'base_provider.dart';

class UlogeProvider extends BaseProvider<Uloga>{
  UlogeProvider() : super("Uloge", "");

  @override
  Uloga fromJson(data) {
    // TODO: implement fromJson
    return Uloga.fromJson(data);
  }
}
