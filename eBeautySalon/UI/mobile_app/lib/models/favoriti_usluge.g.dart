// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favoriti_usluge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavoritiUsluge _$FavoritiUslugeFromJson(Map<String, dynamic> json) =>
    FavoritiUsluge(
      json['favoritId'] as int?,
      json['korisnikId'] as int?,
      json['uslugaId'] as int?,
      json['isFavorit'] as bool?,
    );

Map<String, dynamic> _$FavoritiUslugeToJson(FavoritiUsluge instance) =>
    <String, dynamic>{
      'favoritId': instance.favoritId,
      'korisnikId': instance.korisnikId,
      'uslugaId': instance.uslugaId,
      'isFavorit': instance.isFavorit,
    };
