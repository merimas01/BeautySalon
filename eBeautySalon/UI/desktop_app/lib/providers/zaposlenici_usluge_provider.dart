import 'package:desktop_app/models/zaposlenik_usluga.dart';

import '../models/zaposlenik.dart';
import 'base_provider.dart';

class ZaposleniciUslugeProvider extends BaseProvider<ZaposlenikUsluga>{
  ZaposleniciUslugeProvider() : super("ZaposleniciUsluge", "");

  @override
  ZaposlenikUsluga fromJson(data) {
    // TODO: implement fromJson
    return ZaposlenikUsluga.fromJson(data);
  }
}
