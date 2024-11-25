import 'dart:convert';

import 'package:desktop_app/models/recenzija_usluznika.dart';
import '../models/search_result.dart';
import 'base_provider.dart';
import 'package:http/http.dart' as http;

class RecenzijaUsluznikaProvider extends BaseProvider<RecenzijaUsluznika> {
  RecenzijaUsluznikaProvider()
      : super("RecenzijaUsluznika",
            "isKorisnikIncluded=true&isZaposlenikIncluded=true");

  @override
  RecenzijaUsluznika fromJson(data) {
    // TODO: implement fromJson
    return RecenzijaUsluznika.fromJson(data);
  }

  Future<List<dynamic>> GetProsjecnaOcjena() async {
    var url = "${BaseProvider.baseUrl}RecenzijaUsluznika/prosjecnaOcjena";

    print("url: $url");

    var uri = Uri.parse(url);
    var headers = createHeaders();
    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      throw new Exception("Unknow error");
    }
  }

  Future<SearchResult<RecenzijaUsluznika>> GetRecenzijeUsluznikaByKorisnikId(
      korisnikId, filter) async {
    var url =
        "${BaseProvider.baseUrl}RecenzijaUsluznika/recenzijeUsluznika/$korisnikId?FTS=$filter";

    print("url: $url");

    var uri = Uri.parse(url);
    var headers = createHeaders();
    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      //return data;
      var result = SearchResult<RecenzijaUsluznika>();
      result.count = data['count'];

      for (var item in data['result']) {
        result.result.add(fromJson(item));
      }

      print("RESULT: ${result.result}");
      return result;
    } else {
      throw new Exception("Unknow error");
    }
  }
}
