// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recenzija_usluznika.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecenzijaUsluznika _$RecenzijaUsluznikaFromJson(Map<String, dynamic> json) =>
    RecenzijaUsluznika(
      json['recenzijaUsluznikaId'] as int?,
      (json['ocjena'] as num?)?.toDouble(),
      json['komentar'] as String?,
      json['datumKreiranja'] == null
          ? null
          : DateTime.parse(json['datumKreiranja'] as String),
      json['datumModificiranja'] == null
          ? null
          : DateTime.parse(json['datumModificiranja'] as String),
      json['korisnikId'] as int?,
      json['usluznikId'] as int?,
      json['korisnik'] == null
          ? null
          : Korisnik.fromJson(json['korisnik'] as Map<String, dynamic>),
      json['usluznik'] == null
          ? null
          : Zaposlenik.fromJson(json['usluznik'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RecenzijaUsluznikaToJson(RecenzijaUsluznika instance) =>
    <String, dynamic>{
      'recenzijaUsluznikaId': instance.recenzijaUsluznikaId,
      'ocjena': instance.ocjena,
      'komentar': instance.komentar,
      'datumKreiranja': instance.datumKreiranja?.toIso8601String(),
      'datumModificiranja': instance.datumModificiranja?.toIso8601String(),
      'korisnikId': instance.korisnikId,
      'usluznikId': instance.usluznikId,
      'korisnik': instance.korisnik,
      'usluznik': instance.usluznik,
    };
