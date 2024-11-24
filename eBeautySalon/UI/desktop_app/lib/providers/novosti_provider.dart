import 'dart:convert';

import 'package:desktop_app/models/novost.dart';
import '../models/search_result.dart';
import 'base_provider.dart';
import 'package:http/http.dart' as http;

class NovostiProvider extends BaseProvider<Novost> {
  NovostiProvider() : super("Novosti", "isSlikaIncluded=true");

  @override
  Novost fromJson(data) {
    // TODO: implement fromJson
    return Novost.fromJson(data);
  }

  Future<SearchResult<Novost>> GetLastThreeNovosti() async {
    var url = "${BaseProvider.baseUrl}Novosti/lastNews";

    print("url: $url");

    var uri = Uri.parse(url);
    var headers = createHeaders();
    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      //return data;
      var result = SearchResult<Novost>();
      result.count = data['count'];

      for (var item in data['result']) {
        result.result.add(fromJson(item));
      }

      return result;
    } else {
      throw new Exception("Unknow error");
    }
  }
}
