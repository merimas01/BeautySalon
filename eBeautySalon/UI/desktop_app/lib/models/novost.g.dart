// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'novost.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Novost _$NovostFromJson(Map<String, dynamic> json) => Novost(
      json['novostId'] as int?,
      json['naslov'] as String?,
      json['sadrzaj'] as String?,
      json['datumKreiranja'] == null
          ? null
          : DateTime.parse(json['datumKreiranja'] as String),
      json['datumModificiranja'] == null
          ? null
          : DateTime.parse(json['datumModificiranja'] as String),
      json['korisnikId'] as int?,
      json['slikaNovostId'] as int?,
      json['korisnik'] == null
          ? null
          : Korisnik.fromJson(json['korisnik'] as Map<String, dynamic>),
      json['slikaNovost'] == null
          ? null
          : SlikaNovost.fromJson(json['slikaNovost'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NovostToJson(Novost instance) => <String, dynamic>{
      'novostId': instance.novostId,
      'naslov': instance.naslov,
      'sadrzaj': instance.sadrzaj,
      'datumKreiranja': instance.datumKreiranja?.toIso8601String(),
      'datumModificiranja': instance.datumModificiranja?.toIso8601String(),
      'korisnikId': instance.korisnikId,
      'slikaNovostId': instance.slikaNovostId,
      'korisnik': instance.korisnik,
      'slikaNovost': instance.slikaNovost,
    };
