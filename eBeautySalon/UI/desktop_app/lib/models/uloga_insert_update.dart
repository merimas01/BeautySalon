/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
import 'package:json_annotation/json_annotation.dart';
part 'uloga_insert_update.g.dart';

@JsonSerializable()
class UlogaInsertUpdate{
  String? naziv;
  String? opis;

  UlogaInsertUpdate(this.naziv, this.opis);

  
  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory UlogaInsertUpdate.fromJson(Map<String, dynamic> json) => _$UlogaInsertUpdateFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$UlogaInsertUpdateToJson(this);
}