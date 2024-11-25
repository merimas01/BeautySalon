import 'dart:convert';

import 'package:desktop_app/models/rezervacija.dart';
import '../models/search_result.dart';
import 'base_provider.dart';
import 'package:http/http.dart' as http;

class RezervacijeProvider extends BaseProvider<Rezervacija> {
  RezervacijeProvider()
      : super("Rezervacije",
            "isKorisnikIncluded=true&isUslugaIncluded=true&isTerminIncluded=true&isStatusIncluded=true");

  @override
  Rezervacija fromJson(data) {
    // TODO: implement fromJson
    return Rezervacija.fromJson(data);
  }

  Future<SearchResult<Rezervacija>> GetRezervacijeByKorisnikId(
      korisnikId, filter) async {
    var url =
        "${BaseProvider.baseUrl}Rezervacije/rezervacije/$korisnikId?FTS=$filter";

    print("url: $url");

    var uri = Uri.parse(url);
    var headers = createHeaders();
    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      //return data;
      var result = SearchResult<Rezervacija>();
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
