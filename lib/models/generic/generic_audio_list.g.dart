// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generic_audio_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenericAudioList _$GenericAudioListFromJson(Map<String, dynamic> json) =>
    GenericAudioList(
      arabicDua: (json['arabic_dua'] as List<dynamic>?)
          ?.map((e) => GenericAudioItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      englishDua: (json['english_dua'] as List<dynamic>?)
          ?.map((e) => GenericAudioItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      gujratiDua: (json['gujrati_dua'] as List<dynamic>?)
          ?.map((e) => GenericAudioItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      hindiDua: (json['hindi_dua'] as List<dynamic>?)
          ?.map((e) => GenericAudioItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      arabicZiyarat: (json['arabic_ziyarat'] as List<dynamic>?)
          ?.map((e) => GenericAudioItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      englishZiyarat: (json['english_ziyarat'] as List<dynamic>?)
          ?.map((e) => GenericAudioItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      gujratiZiyarat: (json['gujrati_ziyarat'] as List<dynamic>?)
          ?.map((e) => GenericAudioItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      hindiZiyarat: (json['hindi_ziyarat'] as List<dynamic>?)
          ?.map((e) => GenericAudioItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      arabicSurah: (json['arabic_surah'] as List<dynamic>?)
          ?.map((e) => GenericAudioItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GenericAudioListToJson(GenericAudioList instance) =>
    <String, dynamic>{
      'arabic_dua': instance.arabicDua,
      'english_dua': instance.englishDua,
      'gujrati_dua': instance.gujratiDua,
      'hindi_dua': instance.hindiDua,
      'arabic_ziyarat': instance.arabicZiyarat,
      'english_ziyarat': instance.englishZiyarat,
      'gujrati_ziyarat': instance.gujratiZiyarat,
      'hindi_ziyarat': instance.hindiZiyarat,
      'arabic_surah': instance.arabicSurah,
    };

GenericAudioItem _$GenericAudioItemFromJson(Map<String, dynamic> json) =>
    GenericAudioItem(
      caption: json['caption'] as String,
      duration: json['duration'] as String,
      file: json['file'] as String,
      id: json['id'],
      name: json['name'] as String,
      track: json['track'] as int,
      fav: json['fav'] as String?,
    );

Map<String, dynamic> _$GenericAudioItemToJson(GenericAudioItem instance) =>
    <String, dynamic>{
      'caption': instance.caption,
      'duration': instance.duration,
      'file': instance.file,
      'id': instance.id,
      'name': instance.name,
      'track': instance.track,
      'fav': instance.fav,
    };
