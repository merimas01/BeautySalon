import 'dart:ffi';
import 'package:json_annotation/json_annotation.dart';

import 'korisnik.dart';
import 'novost.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'novost_like_comment_insert_update.g.dart';

@JsonSerializable()
class NovostLikeCommentInsertUpdate {
  NovostLikeCommentInsertUpdate(
    this.korisnikId,
    this.novostId,
    this.isLike,
    this.komentar,
  );

  int? korisnikId;
  int? novostId;
  bool? isLike;
  String? komentar;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory NovostLikeCommentInsertUpdate.fromJson(Map<String, dynamic> json) =>
      _$NovostLikeCommentInsertUpdateFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$NovostLikeCommentInsertUpdateToJson(this);
}
