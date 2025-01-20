// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zaposlenik_insert_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ZaposlenikInsertUpdate _$ZaposlenikInsertUpdateFromJson(
        Map<String, dynamic> json) =>
    ZaposlenikInsertUpdate(
      json['datumRodjenja'] == null
          ? null
          : DateTime.parse(json['datumRodjenja'] as String),
      json['datumZaposlenja'] == null
          ? null
          : DateTime.parse(json['datumZaposlenja'] as String),
      json['korisnikId'] as int?,
      json['biografija'] as String?,
    );

Map<String, dynamic> _$ZaposlenikInsertUpdateToJson(
        ZaposlenikInsertUpdate instance) =>
    <String, dynamic>{
      'datumRodjenja': instance.datumRodjenja?.toIso8601String(),
      'datumZaposlenja': instance.datumZaposlenja?.toIso8601String(),
      'korisnikId': instance.korisnikId,
      'biografija': instance.biografija,
    };
