import 'package:mobile_app/models/zaposlenik_usluga.dart';

import 'korisnik.dart';

import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'zaposlenik.g.dart';

@JsonSerializable()
class Zaposlenik {
  int? zaposlenikId;
  DateTime? datumRodjenja;
  DateTime? datumZaposlenja;
  int? korisnikId;
  DateTime? datumKreiranja;
  DateTime? datumModifikovanja;
  Korisnik? korisnik;
  List<ZaposlenikUsluga>? zaposlenikUslugas;

  Zaposlenik(
      this.zaposlenikId,
      this.datumRodjenja,
      this.datumZaposlenja,
      this.korisnikId,
      this.datumKreiranja,
      this.datumModifikovanja,
      this.korisnik,
      this.zaposlenikUslugas);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Zaposlenik.fromJson(Map<String, dynamic> json) =>
      _$ZaposlenikFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$ZaposlenikToJson(this);
}
