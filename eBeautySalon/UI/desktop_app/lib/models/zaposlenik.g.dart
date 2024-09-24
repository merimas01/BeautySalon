// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zaposlenik.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Zaposlenik _$ZaposlenikFromJson(Map<String, dynamic> json) => Zaposlenik(
      json['zaposlenikId'] as int?,
      json['datumRodjenja'] == null
          ? null
          : DateTime.parse(json['datumRodjenja'] as String),
      json['datumZaposlenja'] == null
          ? null
          : DateTime.parse(json['datumZaposlenja'] as String),
      json['korisnikId'] as int?,
      json['datumKreiranja'] == null
          ? null
          : DateTime.parse(json['datumKreiranja'] as String),
      json['datumModifikovanja'] == null
          ? null
          : DateTime.parse(json['datumModifikovanja'] as String),
      json['korisnik'] == null
          ? null
          : Korisnik.fromJson(json['korisnik'] as Map<String, dynamic>),
      (json['zaposlenikUslugas'] as List<dynamic>?)
          ?.map((e) => ZaposlenikUsluga.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ZaposlenikToJson(Zaposlenik instance) =>
    <String, dynamic>{
      'zaposlenikId': instance.zaposlenikId,
      'datumRodjenja': instance.datumRodjenja?.toIso8601String(),
      'datumZaposlenja': instance.datumZaposlenja?.toIso8601String(),
      'korisnikId': instance.korisnikId,
      'datumKreiranja': instance.datumKreiranja?.toIso8601String(),
      'datumModifikovanja': instance.datumModifikovanja?.toIso8601String(),
      'korisnik': instance.korisnik,
      'zaposlenikUslugas': instance.zaposlenikUslugas,
    };
