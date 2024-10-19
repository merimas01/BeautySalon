import 'dart:convert';
import '../models/search_result.dart';
import '../models/status.dart';
import 'base_provider.dart';
import 'package:http/http.dart' as http;


class StatusiProvider extends BaseProvider<Status>{
  StatusiProvider() : super("Statusi", "");

  @override
  Status fromJson(data) {
    // TODO: implement fromJson
    return Status.fromJson(data);
  }

  Future<SearchResult<Status>> GetStatuse({dynamic filter}) async {
   
    var url = "${BaseProvider.baseUrl}Statusi/GetStatuse";

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

      var result = SearchResult<Status>();
      result.count = data['count'];

      for (var item in data['result']) {
        result.result.add(Status.fromJson(item));
      }
      return result;
    } else {
      throw new Exception("Unknow error");
    }
  }
}
