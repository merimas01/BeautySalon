import 'package:desktop_app/models/novost.dart';
import 'base_provider.dart';

class NovostiProvider extends BaseProvider<Novost> {
  NovostiProvider()
      : super("Novosti", "");

  @override
  Novost fromJson(data) {
    // TODO: implement fromJson
    return Novost.fromJson(data);
  }
}
