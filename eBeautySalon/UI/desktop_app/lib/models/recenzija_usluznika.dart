import 'package:desktop_app/models/zaposlenik.dart';

import 'korisnik.dart';

import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'recenzija_usluznika.g.dart';

@JsonSerializable()
class RecenzijaUsluznika {
  int? recenzijaUsluznikaId;
  double? ocjena;
  String? komentar;
  DateTime? datumKreiranja;
  DateTime? datumModificiranja;
  int? korisnikId;
  int? usluznikId;
  Korisnik? korisnik;
  Zaposlenik? usluznik;

  RecenzijaUsluznika(
      this.recenzijaUsluznikaId,
      this.ocjena,
      this.komentar,
      this.datumKreiranja,
      this.datumModificiranja,
      this.korisnikId,
      this.usluznikId,
      this.korisnik,
      this.usluznik);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory RecenzijaUsluznika.fromJson(Map<String, dynamic> json) =>
      _$RecenzijaUsluznikaFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$RecenzijaUsluznikaToJson(this);
}
