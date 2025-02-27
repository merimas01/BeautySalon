import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Authorization {
  static String? username;
  static String? password;
}

Image ImageFromBase64String(String base64Image) {
  return Image.memory(
    base64Decode(base64Image),
    fit: BoxFit.cover,
  );
}

Widget imageContainer(x, double height, double width) {
  return Container(
    height: height,
    width: width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15), // Rounded corners
      border: Border.all(color: Colors.grey.shade300, width: 2), // Light border
    ),
    clipBehavior: Clip.antiAlias, // Ensures image follows rounded corners
    child: ImageFromBase64String(x),
  );
}

Widget noImageContainer(double height, double width) {
  return Container(
    height: height,
    width: width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15), // Rounded corners
    ),
    clipBehavior: Clip.antiAlias, // Ensures image follows rounded corners
    child: Image.asset(
      "assets/images/noImage.jpg",
      fit: BoxFit.cover, // Ensures the image fills the container
    ),
  );
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
