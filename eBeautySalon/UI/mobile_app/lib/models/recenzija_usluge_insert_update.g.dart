// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recenzija_usluge_insert_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecenzijaUslugeInsertUpdate _$RecenzijaUslugeInsertUpdateFromJson(
        Map<String, dynamic> json) =>
    RecenzijaUslugeInsertUpdate(
      json['ocjena'] as int?,
      json['komentar'] as String?,
      json['korisnikId'] as int?,
      json['uslugaId'] as int?,
    );

Map<String, dynamic> _$RecenzijaUslugeInsertUpdateToJson(
        RecenzijaUslugeInsertUpdate instance) =>
    <String, dynamic>{
      'ocjena': instance.ocjena,
      'komentar': instance.komentar,
      'korisnikId': instance.korisnikId,
      'uslugaId': instance.uslugaId,
    };
