// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'korisnik_insert.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KorisnikInsert _$KorisnikInsertFromJson(Map<String, dynamic> json) =>
    KorisnikInsert(
      json['ime'] as String?,
      json['prezime'] as String?,
      json['email'] as String?,
      json['telefon'] as String?,
      json['korisnickoIme'] as String?,
      json['password'] as String?,
      json['passwordPotvrda'] as String?,
      json['slikaProfilaId'] as int?,
    );

Map<String, dynamic> _$KorisnikInsertToJson(KorisnikInsert instance) =>
    <String, dynamic>{
      'ime': instance.ime,
      'prezime': instance.prezime,
      'email': instance.email,
      'telefon': instance.telefon,
      'korisnickoIme': instance.korisnickoIme,
      'password': instance.password,
      'passwordPotvrda': instance.passwordPotvrda,
      'slikaProfilaId': instance.slikaProfilaId,
    };
