import 'package:mobile_app/models/slika_novost.dart';
import 'korisnik.dart';

import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'novost.g.dart';

@JsonSerializable()
class Novost {
  int? novostId;
  String? naslov;
  String? sadrzaj;
  String? sifra;
  DateTime? datumKreiranja;
  DateTime? datumModificiranja;
  int? korisnikId;
  int? slikaNovostId;
  Korisnik? korisnik;
  SlikaNovost? slikaNovost;

  Novost(
      this.novostId,
      this.naslov,
      this.sadrzaj,
      this.sifra,
      this.datumKreiranja,
      this.datumModificiranja,
      this.korisnikId,
      this.slikaNovostId,
      this.korisnik,
      this.slikaNovost);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Novost.fromJson(Map<String, dynamic> json) => _$NovostFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$NovostToJson(this);
}
