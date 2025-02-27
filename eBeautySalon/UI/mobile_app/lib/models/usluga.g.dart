// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usluga.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Usluga _$UslugaFromJson(Map<String, dynamic> json) => Usluga(
      json['uslugaId'] as int?,
      json['naziv'] as String?,
      json['opis'] as String?,
      (json['cijena'] as num?)?.toDouble(),
      json['slikaUslugeId'] as int?,
      json['kategorijaId'] as int?,
      json['sifra'] as String?,
      json['datumKreiranja'] == null
          ? null
          : DateTime.parse(json['datumKreiranja'] as String),
      json['datumModifikovanja'] == null
          ? null
          : DateTime.parse(json['datumModifikovanja'] as String),
      json['slikaUsluge'] == null
          ? null
          : SlikaUsluge.fromJson(json['slikaUsluge'] as Map<String, dynamic>),
      json['kategorija'] == null
          ? null
          : Kategorija.fromJson(json['kategorija'] as Map<String, dynamic>),
      (json['favoritiUsluges'] as List<dynamic>?)
          ?.map((e) => FavoritiUsluge.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UslugaToJson(Usluga instance) => <String, dynamic>{
      'uslugaId': instance.uslugaId,
      'naziv': instance.naziv,
      'opis': instance.opis,
      'cijena': instance.cijena,
      'slikaUslugeId': instance.slikaUslugeId,
      'kategorijaId': instance.kategorijaId,
      'sifra': instance.sifra,
      'datumKreiranja': instance.datumKreiranja?.toIso8601String(),
      'datumModifikovanja': instance.datumModifikovanja?.toIso8601String(),
      'slikaUsluge': instance.slikaUsluge,
      'kategorija': instance.kategorija,
      'favoritiUsluges': instance.favoritiUsluges,
    };
