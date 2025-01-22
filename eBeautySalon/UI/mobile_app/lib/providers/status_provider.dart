import '../models/status.dart';
import 'base_provider.dart';

class StatusiProvider extends BaseProvider<Status>{
  StatusiProvider() : super("Statusi", "");

  @override
  Status fromJson(data) {
    // TODO: implement fromJson
    return Status.fromJson(data);
  }
}
