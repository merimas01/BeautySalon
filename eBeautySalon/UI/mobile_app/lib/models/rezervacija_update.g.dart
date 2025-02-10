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
      json['statusId'] as int?,
      json['isArhiva'] as bool?,
      json['datumRezervacije'] == null
          ? null
          : DateTime.parse(json['datumRezervacije'] as String),
      json['isArhivaKorisnik'] as bool?,
      json['arhivaZaKorisnika'] as bool?,
      json['platio'] as bool?,
    );

Map<String, dynamic> _$RezervacijaUpdateToJson(RezervacijaUpdate instance) =>
    <String, dynamic>{
      'korisnikId': instance.korisnikId,
      'uslugaId': instance.uslugaId,
      'terminId': instance.terminId,
      'statusId': instance.statusId,
      'isArhiva': instance.isArhiva,
      'datumRezervacije': instance.datumRezervacije?.toIso8601String(),
      'isArhivaKorisnik': instance.isArhivaKorisnik,
      'arhivaZaKorisnika': instance.arhivaZaKorisnika,
      'platio': instance.platio,
    };
