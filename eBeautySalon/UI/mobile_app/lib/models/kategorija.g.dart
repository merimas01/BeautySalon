// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kategorija.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Kategorija _$KategorijaFromJson(Map<String, dynamic> json) => Kategorija(
      json['kategorijaId'] as int?,
      json['naziv'] as String?,
      json['opis'] as String?,
      json['datumKreiranja'] == null
          ? null
          : DateTime.parse(json['datumKreiranja'] as String),
      json['datumModifikovanja'] == null
          ? null
          : DateTime.parse(json['datumModifikovanja'] as String),
      json['sifra'] as String?,
    );

Map<String, dynamic> _$KategorijaToJson(Kategorija instance) =>
    <String, dynamic>{
      'kategorijaId': instance.kategorijaId,
      'naziv': instance.naziv,
      'opis': instance.opis,
      'datumKreiranja': instance.datumKreiranja?.toIso8601String(),
      'datumModifikovanja': instance.datumModifikovanja?.toIso8601String(),
      'sifra': instance.sifra,
    };
