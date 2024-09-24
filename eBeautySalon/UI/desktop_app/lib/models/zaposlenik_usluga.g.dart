// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zaposlenik_usluga.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ZaposlenikUsluga _$ZaposlenikUslugaFromJson(Map<String, dynamic> json) =>
    ZaposlenikUsluga(
      json['zaposlenikId'] as int?,
      json['uslugaId'] as int?,
      json['datumKreiranja'] == null
          ? null
          : DateTime.parse(json['datumKreiranja'] as String),
      json['datumModificiranja'] == null
          ? null
          : DateTime.parse(json['datumModificiranja'] as String),
    );

Map<String, dynamic> _$ZaposlenikUslugaToJson(ZaposlenikUsluga instance) =>
    <String, dynamic>{
      'zaposlenikId': instance.zaposlenikId,
      'uslugaId': instance.uslugaId,
      'datumKreiranja': instance.datumKreiranja?.toIso8601String(),
      'datumModificiranja': instance.datumModificiranja?.toIso8601String(),
    };
