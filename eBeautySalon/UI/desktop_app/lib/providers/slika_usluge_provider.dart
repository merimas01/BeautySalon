import '../models/slika_usluge.dart';
import 'base_provider.dart';

class SlikaUslugeProvider extends BaseProvider<SlikaUsluge> {
  SlikaUslugeProvider()
      : super("SlikaUsluge", "");

  @override
  SlikaUsluge fromJson(data) {
    // TODO: implement fromJson
    return SlikaUsluge.fromJson(data);
  }

}
