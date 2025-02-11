import '../models/usluga.dart';
import 'base_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class UslugeProvider extends BaseProvider<Usluga> {
  UslugeProvider()
      : super("Usluge", "isKategorijaIncluded=true&isSlikaIncluded=true");

  @override
  Usluga fromJson(data) {
    // TODO: implement fromJson
    return Usluga.fromJson(data);
  }

  Future<List<Usluga>> Recommend(uslugaId) async {
    var url = "${BaseProvider.baseUrl}Usluge/recommend/$uslugaId";

    print("url: $url");

    var uri = Uri.parse(url);
    var headers = createHeaders();
    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      List<Usluga> result = [];

      for (var item in data) {
        result.add(fromJson(item));
      }
      return result;
    } else {
      throw new Exception("Unknow error");
    }
  }
}
