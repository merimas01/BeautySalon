// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rezervacija_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RezervacijaUpdate _$RezervacijaUpdateFromJson(Map<String, dynamic> json) =>
    RezervacijaUpdate(
      json['korisnikId'] as int?,
      json['uslugaId'] as int?,
      json['terminId'] as int?,
      json['datumRezervacije'] == null
          ? null
          : DateTime.parse(json['datumRezervacije'] as String),
      json['statusId'] as int?,
      json['isArhiva'] as bool?,
      json['platio'] as bool?,
    );

Map<String, dynamic> _$RezervacijaUpdateToJson(RezervacijaUpdate instance) =>
    <String, dynamic>{
      'korisnikId': instance.korisnikId,
      'uslugaId': instance.uslugaId,
      'terminId': instance.terminId,
      'datumRezervacije': instance.datumRezervacije?.toIso8601String(),
      'statusId': instance.statusId,
      'isArhiva': instance.isArhiva,
      'platio': instance.platio,
    };
