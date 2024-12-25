// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usluga_termin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UslugaTermin _$UslugaTerminFromJson(Map<String, dynamic> json) => UslugaTermin(
      json['uslugaTerminId'] as int?,
      json['uslugaId'] as int?,
      json['terminId'] as int?,
      json['datumIzmjene'] == null
          ? null
          : DateTime.parse(json['datumIzmjene'] as String),
      json['isPrikazan'] as bool?,
      json['usluga'] == null
          ? null
          : Usluga.fromJson(json['usluga'] as Map<String, dynamic>),
      json['termin'] == null
          ? null
          : Termin.fromJson(json['termin'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UslugaTerminToJson(UslugaTermin instance) =>
    <String, dynamic>{
      'uslugaTerminId': instance.uslugaTerminId,
      'uslugaId': instance.uslugaId,
      'terminId': instance.terminId,
      'datumIzmjene': instance.datumIzmjene?.toIso8601String(),
      'isPrikazan': instance.isPrikazan,
      'usluga': instance.usluga,
      'termin': instance.termin,
    };
