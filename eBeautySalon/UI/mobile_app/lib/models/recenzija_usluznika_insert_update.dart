import 'package:mobile_app/models/zaposlenik.dart';

import 'korisnik.dart';

import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'recenzija_usluznika_insert_update.g.dart';

@JsonSerializable()
class RecenzijaUsluznikaInsertUpdate {
  double? ocjena;
  String? komentar;
  int? korisnikId;
  int? usluznikId;

  RecenzijaUsluznikaInsertUpdate(
      this.ocjena,
      this.komentar,
      this.korisnikId,
      this.usluznikId);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory RecenzijaUsluznikaInsertUpdate.fromJson(Map<String, dynamic> json) =>
      _$RecenzijaUsluznikaInsertUpdateFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$RecenzijaUsluznikaInsertUpdateToJson(this);
}
