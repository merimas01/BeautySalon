import 'dart:convert';

import 'package:desktop_app/models/recenzija_usluge.dart';
import '../models/search_result.dart';
import 'base_provider.dart';
import 'package:http/http.dart' as http;

class RecenzijaUslugeProvider extends BaseProvider<RecenzijaUsluge> {
  RecenzijaUslugeProvider()
      : super(
            "RecenzijaUsluge", "isUslugeIncluded=true&isKorisnikIncluded=true");

  @override
  RecenzijaUsluge fromJson(data) {
    // TODO: implement fromJson
    return RecenzijaUsluge.fromJson(data);
  }

  Future<List<dynamic>> GetProsjecnaOcjena() async {
    var url = "${BaseProvider.baseUrl}RecenzijaUsluge/prosjecnaOcjena";

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
}
