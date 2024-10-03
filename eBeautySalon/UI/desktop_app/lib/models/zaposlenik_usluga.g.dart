// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zaposlenik_usluga.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ZaposlenikUsluga _$ZaposlenikUslugaFromJson(Map<String, dynamic> json) =>
    ZaposlenikUsluga(
      json['zaposlenikUslugaId'] as int?,
      json['zaposlenikId'] as int?,
      json['uslugaId'] as int?,
      json['datumKreiranja'] == null
          ? null
          : DateTime.parse(json['datumKreiranja'] as String),
      json['datumModificiranja'] == null
          ? null
          : DateTime.parse(json['datumModificiranja'] as String),
      json['usluga'] == null
          ? null
          : Usluga.fromJson(json['usluga'] as Map<String, dynamic>),
      json['zaposlenik'] == null
          ? null
          : Zaposlenik.fromJson(json['zaposlenik'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ZaposlenikUslugaToJson(ZaposlenikUsluga instance) =>
    <String, dynamic>{
      'zaposlenikUslugaId': instance.zaposlenikUslugaId,
      'zaposlenikId': instance.zaposlenikId,
      'uslugaId': instance.uslugaId,
      'datumKreiranja': instance.datumKreiranja?.toIso8601String(),
      'datumModificiranja': instance.datumModificiranja?.toIso8601String(),
      'usluga': instance.usluga,
      'zaposlenik': instance.zaposlenik,
    };
