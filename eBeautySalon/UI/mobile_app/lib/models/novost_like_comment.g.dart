// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'novost_like_comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NovostLikeComment _$NovostLikeCommentFromJson(Map<String, dynamic> json) =>
    NovostLikeComment(
      json['novostLikeCommentId'] as int?,
      json['korisnikId'] as int?,
      json['novostId'] as int?,
      json['isLike'] as bool?,
      json['komentar'] as String?,
      json['datumKreiranja'] == null
          ? null
          : DateTime.parse(json['datumKreiranja'] as String),
      json['datumModifikovanja'] == null
          ? null
          : DateTime.parse(json['datumModifikovanja'] as String),
      json['korisnik'] == null
          ? null
          : Korisnik.fromJson(json['korisnik'] as Map<String, dynamic>),
      json['novost'] == null
          ? null
          : Novost.fromJson(json['novost'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NovostLikeCommentToJson(NovostLikeComment instance) =>
    <String, dynamic>{
      'novostLikeCommentId': instance.novostLikeCommentId,
      'korisnikId': instance.korisnikId,
      'novostId': instance.novostId,
      'isLike': instance.isLike,
      'komentar': instance.komentar,
      'datumKreiranja': instance.datumKreiranja?.toIso8601String(),
      'datumModifikovanja': instance.datumModifikovanja?.toIso8601String(),
      'korisnik': instance.korisnik,
      'novost': instance.novost,
    };
