// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favourite_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavouriteApi _$FavouriteApiFromJson(Map<String, dynamic> json) => FavouriteApi(
      type: json['type'] as String,
      fav: json['fav'] as String?,
      icon: json['icon'] as String?,
    );

Map<String, dynamic> _$FavouriteApiToJson(FavouriteApi instance) =>
    <String, dynamic>{
      'fav': instance.fav,
      'icon': instance.icon,
      'type': instance.type,
    };
