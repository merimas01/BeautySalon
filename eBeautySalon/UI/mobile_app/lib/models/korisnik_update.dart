import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'korisnik_update.g.dart';

@JsonSerializable()
class KorisnikUpdate {
  String? ime;
  String? prezime;
  String? email;
  String? telefon;
  bool? status;
  int? slikaProfilaId;

  KorisnikUpdate(this.ime, this.prezime, this.email, this.telefon, this.status,
      this.slikaProfilaId);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory KorisnikUpdate.fromJson(Map<String, dynamic> json) =>
      _$KorisnikUpdateFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$KorisnikUpdateToJson(this);
}
