import '../models/favoriti_usluge.dart';
import 'base_provider.dart';

class FavoritiUslugeProvider extends BaseProvider<FavoritiUsluge> {
  FavoritiUslugeProvider()
      : super("FavoritiUsluge", "");

  @override
  FavoritiUsluge fromJson(data) {
    // TODO: implement fromJson
    return FavoritiUsluge.fromJson(data);
  }
}
