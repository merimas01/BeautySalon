import 'package:desktop_app/models/termin.dart';
import 'package:desktop_app/models/usluga.dart';

import 'korisnik.dart';

import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'rezervacija_update.g.dart';

@JsonSerializable()
class RezervacijaUpdate {
  int? korisnikId;
  int? uslugaId;
  int? terminId;
  DateTime? datumRezervacije;
  int? statusId;
  bool? isArhiva;
  bool? platio;

  RezervacijaUpdate(this.korisnikId, this.uslugaId, this.terminId,
      this.datumRezervacije, this.statusId, this.isArhiva, this.platio);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory RezervacijaUpdate.fromJson(Map<String, dynamic> json) =>
      _$RezervacijaUpdateFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$RezervacijaUpdateToJson(this);
}
