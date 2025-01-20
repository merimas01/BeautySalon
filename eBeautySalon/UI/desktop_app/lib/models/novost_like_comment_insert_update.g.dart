// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'novost_like_comment_insert_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NovostLikeCommentInsertUpdate _$NovostLikeCommentInsertUpdateFromJson(
        Map<String, dynamic> json) =>
    NovostLikeCommentInsertUpdate(
      json['korisnikId'] as int?,
      json['novostId'] as int?,
      json['isLike'] as bool?,
      json['komentar'] as String?,
    );

Map<String, dynamic> _$NovostLikeCommentInsertUpdateToJson(
        NovostLikeCommentInsertUpdate instance) =>
    <String, dynamic>{
      'korisnikId': instance.korisnikId,
      'novostId': instance.novostId,
      'isLike': instance.isLike,
      'komentar': instance.komentar,
    };
