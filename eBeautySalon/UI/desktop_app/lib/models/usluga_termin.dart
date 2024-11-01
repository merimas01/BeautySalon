import 'package:desktop_app/models/termin.dart';
import 'package:desktop_app/models/usluga.dart';
import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'usluga_termin.g.dart';

@JsonSerializable()
class UslugaTermin {
  UslugaTermin(this.uslugaTerminId, this.uslugaId, this.terminId,
      this.datumIzmjene, this.isPrikazan, this.usluga, this.termin);

  int? uslugaTerminId;
  int? uslugaId;
  int? terminId;
  DateTime? datumIzmjene;
  bool? isPrikazan;
  Usluga? usluga;
  Termin? termin;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory UslugaTermin.fromJson(Map<String, dynamic> json) =>
      _$UslugaTerminFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$UslugaTerminToJson(this);
}
