// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recenzija_usluznika_insert_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecenzijaUsluznikaInsertUpdate _$RecenzijaUsluznikaInsertUpdateFromJson(
        Map<String, dynamic> json) =>
    RecenzijaUsluznikaInsertUpdate(
      json['ocjena'] as int?,
      json['komentar'] as String?,
      json['korisnikId'] as int?,
      json['usluznikId'] as int?,
    );

Map<String, dynamic> _$RecenzijaUsluznikaInsertUpdateToJson(
        RecenzijaUsluznikaInsertUpdate instance) =>
    <String, dynamic>{
      'ocjena': instance.ocjena,
      'komentar': instance.komentar,
      'korisnikId': instance.korisnikId,
      'usluznikId': instance.usluznikId,
    };
