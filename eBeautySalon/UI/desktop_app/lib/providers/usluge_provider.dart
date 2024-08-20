import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../models/search_result.dart';
import '../models/usluga.dart';
import '../utils/util.dart';

class UslugeProvider with ChangeNotifier {
  static String? _baseUrl;
  String _endpoint = "Usluge"; //?isKategorijaIncluded=true&isSlikaIncluded=true

  UslugeProvider() {
    _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "http://localhost:5145/api/");
  }

  Future<SearchResult<Usluga>> get() async {
    var url = "$_baseUrl$_endpoint";

    var uri = Uri.parse(url);
    var headers = createHeaders();
    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      //return data;

      print("data provider: $data");
      var result = SearchResult<Usluga>();
      result.count = data['count'];

      for(var item in data['result']){
        print("item: $item");
        print("item uslugaid: ${item['uslugaId']}");
        
        result.result.add(Usluga.fromJson(item));
      }

       //print("result.result: ${result.result}");
       //print("result.result[0].naziv: ${result.result[1].naziv}");

      return result;
    } else {
      throw new Exception("Unknow error");
    }
  }

  bool isValidResponse(Response response) {
    if (response.statusCode <= 299) {
      return true;
    } else if (response.statusCode == 401) {
      throw new Exception("Unauthorized");
    } else {
      throw new Exception("Something bad happened. Please try again.");
    }
  }

  Map<String, String> createHeaders() {
    String username = Authorization.username ?? "";
    String password = Authorization.password ?? "";

    print("passed creds: $username $password");

    String basicAuth =
        "Basic ${base64Encode(utf8.encode('$username:$password'))}";

    var headers = {
      "ContentType":
          "application/json", //zelimo da nam server uvijek salje json
      "Authorization": basicAuth
    };

    return headers;
  }
}
