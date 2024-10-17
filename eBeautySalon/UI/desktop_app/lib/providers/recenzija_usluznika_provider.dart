import 'package:desktop_app/models/recenzija_usluznika.dart';
import 'base_provider.dart';

class RecenzijaUsluznikaProvider extends BaseProvider<RecenzijaUsluznika> {
  RecenzijaUsluznikaProvider()
      : super("RecenzijaUsluznika", "");

  @override
  RecenzijaUsluznika fromJson(data) {
    // TODO: implement fromJson
    return RecenzijaUsluznika.fromJson(data);
  }
}
