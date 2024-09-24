// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rezervacija.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rezervacija _$RezervacijaFromJson(Map<String, dynamic> json) => Rezervacija(
      json['rezervacijaId'] as int?,
      json['korisnikId'] as int?,
      json['uslugaId'] as int?,
      json['terminId'] as int?,
      json['datumRezervacije'] == null
          ? null
          : DateTime.parse(json['datumRezervacije'] as String),
      json['korisnik'] == null
          ? null
          : Korisnik.fromJson(json['korisnik'] as Map<String, dynamic>),
      json['usluga'] == null
          ? null
          : Usluga.fromJson(json['usluga'] as Map<String, dynamic>),
      json['termin'] == null
          ? null
          : Termin.fromJson(json['termin'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RezervacijaToJson(Rezervacija instance) =>
    <String, dynamic>{
      'rezervacijaId': instance.rezervacijaId,
      'korisnikId': instance.korisnikId,
      'uslugaId': instance.uslugaId,
      'terminId': instance.terminId,
      'datumRezervacije': instance.datumRezervacije?.toIso8601String(),
      'korisnik': instance.korisnik,
      'usluga': instance.usluga,
      'termin': instance.termin,
    };
