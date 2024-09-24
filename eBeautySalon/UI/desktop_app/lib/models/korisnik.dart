import '../models/slika_profila.dart';
import 'korisnik_uloga.dart';

import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'korisnik.g.dart';

@JsonSerializable()
class Korisnik {
  int? korisnikId;
  String? ime;
  String? prezime;
  String? telefon;
  String? email;
  String? korisnickoIme;
  bool? status;
  int? slikaProfilaId;
  bool? isAdmin;
  DateTime? datumKreiranja;
  DateTime? datumModifikovanja;
  List<KorisnikUloga>? korisnikUlogas;
  SlikaProfila? slikaProfila;

  Korisnik(
      this.korisnikId,
      this.ime,
      this.prezime,
      this.telefon,
      this.email,
      this.korisnickoIme,
      this.status,
      this.slikaProfilaId,
      this.isAdmin,
      this.datumKreiranja,
      this.datumModifikovanja,
      this.korisnikUlogas,
      this.slikaProfila);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Korisnik.fromJson(Map<String, dynamic> json) =>
      _$KorisnikFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$KorisnikToJson(this);
}
