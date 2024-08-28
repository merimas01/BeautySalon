import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../models/search_result.dart';
import '../models/usluga.dart';
import '../utils/util.dart';
import 'base_provider.dart';

class UslugeProvider extends BaseProvider<Usluga>{
  UslugeProvider() : super("Usluge", "isKategorijaIncluded=true&isSlikaIncluded=true");

  @override
  Usluga fromJson(data) {
    // TODO: implement fromJson
    return Usluga.fromJson(data);
  }
}
