// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'korisnik.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Korisnik _$KorisnikFromJson(Map<String, dynamic> json) => Korisnik(
      json['korisnikId'] as int?,
      json['ime'] as String?,
      json['prezime'] as String?,
      json['telefon'] as String?,
      json['email'] as String?,
      json['korisnickoIme'] as String?,
      json['status'] as bool?,
      json['slikaProfilaId'] as int?,
      json['isAdmin'] as bool?,
      json['datumKreiranja'] == null
          ? null
          : DateTime.parse(json['datumKreiranja'] as String),
      json['datumModifikovanja'] == null
          ? null
          : DateTime.parse(json['datumModifikovanja'] as String),
      (json['korisnikUlogas'] as List<dynamic>?)
          ?.map((e) => KorisnikUloga.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['slikaProfila'] == null
          ? null
          : SlikaProfila.fromJson(json['slikaProfila'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$KorisnikToJson(Korisnik instance) => <String, dynamic>{
      'korisnikId': instance.korisnikId,
      'ime': instance.ime,
      'prezime': instance.prezime,
      'telefon': instance.telefon,
      'email': instance.email,
      'korisnickoIme': instance.korisnickoIme,
      'status': instance.status,
      'slikaProfilaId': instance.slikaProfilaId,
      'isAdmin': instance.isAdmin,
      'datumKreiranja': instance.datumKreiranja?.toIso8601String(),
      'datumModifikovanja': instance.datumModifikovanja?.toIso8601String(),
      'korisnikUlogas': instance.korisnikUlogas,
      'slikaProfila': instance.slikaProfila,
    };
