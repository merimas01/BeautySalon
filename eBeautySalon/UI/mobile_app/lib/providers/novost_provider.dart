import 'dart:convert';

import '../models/novost.dart';
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
}