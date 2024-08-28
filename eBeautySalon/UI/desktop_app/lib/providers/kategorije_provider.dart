import 'dart:convert';
import 'package:desktop_app/models/kategorija.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../utils/util.dart';
import 'base_provider.dart';

class KategorijeProvider extends BaseProvider<Kategorija> {
  KategorijeProvider()
      : super("Kategorije", "");

  @override
  Kategorija fromJson(data) {
    // TODO: implement fromJson
    return Kategorija.fromJson(data);
  }
}
