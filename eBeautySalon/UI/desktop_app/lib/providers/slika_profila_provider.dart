import '../models/slika_profila.dart';
import 'base_provider.dart';

class SlikaProfilaProvider extends BaseProvider<SlikaProfila> {
  SlikaProfilaProvider()
      : super("SlikaProfila", "");

  @override
  SlikaProfila fromJson(data) {
    // TODO: implement fromJson
    return SlikaProfila.fromJson(data);
  }

}
