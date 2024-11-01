// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usluga_termin_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UslugaTerminUpdate _$UslugaTerminUpdateFromJson(Map<String, dynamic> json) =>
    UslugaTerminUpdate(
      json['uslugaId'] as int?,
      json['terminId'] as int?,
      json['isPrikazan'] as bool?,
    );

Map<String, dynamic> _$UslugaTerminUpdateToJson(UslugaTerminUpdate instance) =>
    <String, dynamic>{
      'uslugaId': instance.uslugaId,
      'terminId': instance.terminId,
      'isPrikazan': instance.isPrikazan,
    };
