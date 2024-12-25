// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recenzija_usluge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecenzijaUsluge _$RecenzijaUslugeFromJson(Map<String, dynamic> json) =>
    RecenzijaUsluge(
      json['recenzijaUslugeId'] as int?,
      (json['ocjena'] as num?)?.toDouble(),
      json['komentar'] as String?,
      json['datumKreiranja'] == null
          ? null
          : DateTime.parse(json['datumKreiranja'] as String),
      json['datumModificiranja'] == null
          ? null
          : DateTime.parse(json['datumModificiranja'] as String),
      json['korisnikId'] as int?,
      json['uslugaId'] as int?,
      json['korisnik'] == null
          ? null
          : Korisnik.fromJson(json['korisnik'] as Map<String, dynamic>),
      json['usluga'] == null
          ? null
          : Usluga.fromJson(json['usluga'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RecenzijaUslugeToJson(RecenzijaUsluge instance) =>
    <String, dynamic>{
      'recenzijaUslugeId': instance.recenzijaUslugeId,
      'ocjena': instance.ocjena,
      'komentar': instance.komentar,
      'datumKreiranja': instance.datumKreiranja?.toIso8601String(),
      'datumModificiranja': instance.datumModificiranja?.toIso8601String(),
      'korisnikId': instance.korisnikId,
      'uslugaId': instance.uslugaId,
      'korisnik': instance.korisnik,
      'usluga': instance.usluga,
    };
