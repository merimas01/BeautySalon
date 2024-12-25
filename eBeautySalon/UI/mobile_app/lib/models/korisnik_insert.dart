import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'korisnik_insert.g.dart';

@JsonSerializable()
class KorisnikInsert {
  String? ime;
  String? prezime;
  String? email;
  String? telefon;
  String? korisnickoIme;
  String? password;
  String? passwordPotvrda;
  int? slikaProfilaId;

  KorisnikInsert(
      this.ime,
      this.prezime,
      this.email,
      this.telefon,
      this.korisnickoIme,
      this.password,
      this.passwordPotvrda,
      this.slikaProfilaId);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory KorisnikInsert.fromJson(Map<String, dynamic> json) =>
      _$KorisnikInsertFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$KorisnikInsertToJson(this);
}
