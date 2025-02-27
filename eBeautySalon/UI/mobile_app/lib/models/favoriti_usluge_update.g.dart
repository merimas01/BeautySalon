// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favoriti_usluge_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavoritiUslugeUpdate _$FavoritiUslugeUpdateFromJson(
        Map<String, dynamic> json) =>
    FavoritiUslugeUpdate(
      json['korisnikId'] as int?,
      json['uslugaId'] as int?,
      json['isFavorit'] as bool?,
    );

Map<String, dynamic> _$FavoritiUslugeUpdateToJson(
        FavoritiUslugeUpdate instance) =>
    <String, dynamic>{
      'korisnikId': instance.korisnikId,
      'uslugaId': instance.uslugaId,
      'isFavorit': instance.isFavorit,
    };
