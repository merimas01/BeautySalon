import 'dart:ffi';

import 'package:json_annotation/json_annotation.dart';
import 'package:mobile_app/models/slika_usluge.dart';

import 'favoriti_usluge.dart';
import 'kategorija.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'usluga.g.dart';

@JsonSerializable()
class Usluga {
  Usluga(
      this.uslugaId,
      this.naziv,
      this.opis,
      this.cijena,
      this.slikaUslugeId,
      this.kategorijaId,
      this.sifra,
      this.datumKreiranja,
      this.datumModifikovanja,
      this.slikaUsluge,
      this.kategorija,
      this.favoritiUsluges);

  int? uslugaId;
  String? naziv;
  String? opis;
  double? cijena;
  int? slikaUslugeId;
  int? kategorijaId;
  String? sifra;
  DateTime? datumKreiranja;
  DateTime? datumModifikovanja;
  SlikaUsluge? slikaUsluge;
  Kategorija? kategorija;
  List<FavoritiUsluge>? favoritiUsluges;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Usluga.fromJson(Map<String, dynamic> json) => _$UslugaFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$UslugaToJson(this);
}
