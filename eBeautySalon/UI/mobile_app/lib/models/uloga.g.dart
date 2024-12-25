// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uloga.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Uloga _$UlogaFromJson(Map<String, dynamic> json) => Uloga(
      json['ulogaId'] as int?,
      json['naziv'] as String?,
      json['opis'] as String?,
      json['sifra'] as String?,
    );

Map<String, dynamic> _$UlogaToJson(Uloga instance) => <String, dynamic>{
      'ulogaId': instance.ulogaId,
      'naziv': instance.naziv,
      'opis': instance.opis,
      'sifra': instance.sifra,
    };
