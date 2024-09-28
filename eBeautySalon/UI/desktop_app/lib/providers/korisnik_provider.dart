import 'dart:convert';

import 'package:desktop_app/models/korisnik.dart';
import '../models/search_result.dart';
import 'base_provider.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class KorisnikProvider extends BaseProvider<Korisnik> {
  KorisnikProvider()
      : super("Korisnici",
            "isAdmin=false&isUlogeIncluded=true&isSlikaIncluded=true");

  @override
  Korisnik fromJson(data) {
    // TODO: implement fromJson
    return Korisnik.fromJson(data);
  }

  Future<SearchResult<Korisnik>> GetKorisnike({dynamic filter}) async {
   
    var url = "${BaseProvider.baseUrl}Korisnici/GetKorisnike";

    if (filter != null) {
      var queryString = getQueryString(filter);
      url = "$url?$queryString";
    }

    print("url: $url");

    var uri = Uri.parse(url);
    var headers = createHeaders();
    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      var result = SearchResult<Korisnik>();
      result.count = data['count'];

      for (var item in data['result']) {
        result.result.add(Korisnik.fromJson(item));
      }
      return result;
    } else {
      throw new Exception("Unknow error");
    }
  }
}
