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

  Future<SearchResult<Usluga>> get({dynamic filter}) async {
    var url = "$_baseUrl$_endpoint";

    if (filter != null) {
      var queryString = getQueryString(filter);
      url = "$url?$queryString&isKategorijaIncluded=true&isSlikaIncluded=true";
    }
    else{
      url = "$url?&isKategorijaIncluded=true&isSlikaIncluded=true";
    }

    print("url: $url");

    var uri = Uri.parse(url);

    var headers = createHeaders();
    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      //return data;

      print("data provider: $data");
      var result = SearchResult<Usluga>();
      result.count = data['count'];

      for (var item in data['result']) {
        //print("item: $item");
        //print("item uslugaid: ${item['uslugaId']}");
        //print("item slikaUsluge: ${item['slikaUsluge']['slika']}");

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
      print(response.body);
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

  String getQueryString(Map params,
      {String prefix: '&', bool inRecursion: false}) {
    String query = '';
    params.forEach((key, value) {
      if (inRecursion) {
        if (key is int) {
          key = '[$key]';
        } else if (value is List || value is Map) {
          key = '.$key';
        } else {
          key = '.$key';
        }
      }
      if (value is String || value is int || value is double || value is bool) {
        var encoded = value;
        if (value is String) {
          encoded = Uri.encodeComponent(value);
        }
        query += '$prefix$key=$encoded';
      } else if (value is DateTime) {
        query += '$prefix$key=${(value as DateTime).toIso8601String()}';
      } else if (value is List || value is Map) {
        if (value is List) value = value.asMap();
        value.forEach((k, v) {
          query +=
              getQueryString({k: v}, prefix: '$prefix$key', inRecursion: true);
        });
      }
    });
    return query;
  }
}
