import 'package:desktop_app/models/recenzija_usluge.dart';
import 'base_provider.dart';

class RecenzijaUslugeProvider extends BaseProvider<RecenzijaUsluge> {
  RecenzijaUslugeProvider()
      : super("RecenzijaUsluge", "");

  @override
  RecenzijaUsluge fromJson(data) {
    // TODO: implement fromJson
    return RecenzijaUsluge.fromJson(data);
  }
}
