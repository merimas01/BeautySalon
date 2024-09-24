import 'package:desktop_app/models/usluga.dart';

import 'korisnik.dart';

import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'recenzija_usluge.g.dart';

@JsonSerializable()
class RecenzijaUsluge {
  int? ocjenaId;
  double? ocjena;
  String? komentar;
  DateTime? datumKreiranja;
  DateTime? datumModificiranja;
  int? korisnikId;
  int? uslugaId;
  Korisnik? korisnik;
  Usluga? usluga;

  RecenzijaUsluge(
      this.ocjenaId,
      this.ocjena,
      this.komentar,
      this.datumKreiranja,
      this.datumModificiranja,
      this.korisnikId,
      this.uslugaId,
      this.korisnik,
      this.usluga);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory RecenzijaUsluge.fromJson(Map<String, dynamic> json) => _$RecenzijaUslugeFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$RecenzijaUslugeToJson(this);
}
