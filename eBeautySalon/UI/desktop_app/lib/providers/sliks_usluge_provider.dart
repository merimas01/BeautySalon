import 'dart:convert';
import 'package:desktop_app/models/kategorija.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../models/slika_usluge.dart';
import '../utils/util.dart';
import 'base_provider.dart';

class SlikaUslugeProvider extends BaseProvider<SlikaUsluge> {
  SlikaUslugeProvider()
      : super("SlikaUsluge", "");

  @override
  SlikaUsluge fromJson(data) {
    // TODO: implement fromJson
    return SlikaUsluge.fromJson(data);
  }
}
