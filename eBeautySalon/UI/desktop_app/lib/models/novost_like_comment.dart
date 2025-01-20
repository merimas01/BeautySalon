import 'dart:ffi';
import 'package:json_annotation/json_annotation.dart';

import 'korisnik.dart';
import 'novost.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'novost_like_comment.g.dart';

@JsonSerializable()
class NovostLikeComment {
  NovostLikeComment(
      this.novostLikeCommentId,
      this.korisnikId,
      this.novostId,
      this.isLike,
      this.komentar,
      this.datumKreiranja,
      this.datumModifikovanja,
      this.korisnik,
      this.novost);

  int? novostLikeCommentId;
  int? korisnikId;
  int? novostId;
  bool? isLike;
  String? komentar;
  DateTime? datumKreiranja;
  DateTime? datumModifikovanja;
  Korisnik? korisnik;
  Novost? novost;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory NovostLikeComment.fromJson(Map<String, dynamic> json) =>
      _$NovostLikeCommentFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$NovostLikeCommentToJson(this);
}
