// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorit_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavoritDto _$FavoritDtoFromJson(Map<String, dynamic> json) => FavoritDto(
      json['favoritId'] as int?,
      json['usluga'] == null
          ? null
          : Usluga.fromJson(json['usluga'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FavoritDtoToJson(FavoritDto instance) =>
    <String, dynamic>{
      'favoritId': instance.favoritId,
      'usluga': instance.usluga,
    };
