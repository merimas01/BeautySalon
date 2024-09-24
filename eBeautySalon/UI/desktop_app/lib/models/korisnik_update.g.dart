// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'korisnik_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KorisnikUpdate _$KorisnikUpdateFromJson(Map<String, dynamic> json) =>
    KorisnikUpdate(
      json['ime'] as String?,
      json['prezime'] as String?,
      json['email'] as String?,
      json['telefon'] as String?,
      json['status'] as bool?,
      json['slikaProfilaId'] as int?,
    );

Map<String, dynamic> _$KorisnikUpdateToJson(KorisnikUpdate instance) =>
    <String, dynamic>{
      'ime': instance.ime,
      'prezime': instance.prezime,
      'email': instance.email,
      'telefon': instance.telefon,
      'status': instance.status,
      'slikaProfilaId': instance.slikaProfilaId,
    };
