// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rezervacija_insert.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RezervacijaInsert _$RezervacijaInsertFromJson(Map<String, dynamic> json) =>
    RezervacijaInsert(
      json['korisnikId'] as int?,
      json['uslugaId'] as int?,
      json['terminId'] as int?,
      json['datumRezervacije'] == null
          ? null
          : DateTime.parse(json['datumRezervacije'] as String),
    );

Map<String, dynamic> _$RezervacijaInsertToJson(RezervacijaInsert instance) =>
    <String, dynamic>{
      'korisnikId': instance.korisnikId,
      'uslugaId': instance.uslugaId,
      'terminId': instance.terminId,
      'datumRezervacije': instance.datumRezervacije?.toIso8601String(),
    };
