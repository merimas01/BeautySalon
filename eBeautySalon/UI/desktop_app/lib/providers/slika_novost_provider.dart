import '../models/slika_novost.dart';
import 'base_provider.dart';

class SlikaNovostProvider extends BaseProvider<SlikaNovost> {
  SlikaNovostProvider()
      : super("SlikaNovosti", "");

  @override
  SlikaNovost fromJson(data) {
    // TODO: implement fromJson
    return SlikaNovost.fromJson(data);
  }
}
