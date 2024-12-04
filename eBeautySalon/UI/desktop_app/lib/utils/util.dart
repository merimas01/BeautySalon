import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class Authorization {
  static String? username;
  static String? password;
}

Image ImageFromBase64String(String base64Image) {
  return Image.memory(base64Decode(base64Image));
}

class LoggedUser {
  static int? id;
  static String? korisnickoIme;
  static String? ime;
  static String? prezime;
  static String? slika;
  static String? uloga;

  static void clearData() {
    id = 0;
    korisnickoIme:
    "";
    ime:
    "";
    prezime:
    "";
    slika:
    "";
    uloga:
    "";
  }
}

String formatNumber(dynamic) {
  var f = NumberFormat('###.##');
  if (dynamic == null) {
    return "";
  }
  return f.format(dynamic);
}

String formatDate(DateTime _selectedDate) {
  return DateFormat('dd.MM.yyyy').format(_selectedDate);
}
