
import 'package:json_annotation/json_annotation.dart';
import 'package:mobile_app/models/usluga.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'zaposlenik_usluga.g.dart';

@JsonSerializable()
class ZaposlenikUsluga {
  int? zaposlenikUslugaId;
  int? zaposlenikId;
  int? uslugaId;
  DateTime? datumKreiranja;
  DateTime? datumModificiranja;
  Usluga? usluga;

  ZaposlenikUsluga(
      this.zaposlenikUslugaId,
      this.zaposlenikId,
      this.uslugaId,
      this.datumKreiranja,
      this.datumModificiranja,
      this.usluga);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory ZaposlenikUsluga.fromJson(Map<String, dynamic> json) =>
      _$ZaposlenikUslugaFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$ZaposlenikUslugaToJson(this);
}
