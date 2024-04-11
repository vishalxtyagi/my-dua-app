import 'package:json_annotation/json_annotation.dart';

part 'generic_audio_list.g.dart';

@JsonSerializable()
class GenericAudioList {
  @JsonKey(name: 'arabic_dua')
  final List<GenericAudioItem>? arabicDua;

  @JsonKey(name: 'english_dua')
  final List<GenericAudioItem>? englishDua;

  @JsonKey(name: 'gujrati_dua')
  final List<GenericAudioItem>? gujratiDua;

  @JsonKey(name: 'hindi_dua')
  final List<GenericAudioItem>? hindiDua;

  @JsonKey(name: 'arabic_ziyarat')
  final List<GenericAudioItem>? arabicZiyarat;

  @JsonKey(name: 'english_ziyarat')
  final List<GenericAudioItem>? englishZiyarat;

  @JsonKey(name: 'gujrati_ziyarat')
  final List<GenericAudioItem>? gujratiZiyarat;

  @JsonKey(name: 'hindi_ziyarat')
  final List<GenericAudioItem>? hindiZiyarat;

  @JsonKey(name: 'arabic_surah')
  final List<GenericAudioItem>? arabicSurah;

  GenericAudioList({
    required this.arabicDua,
    required this.englishDua,
    required this.gujratiDua,
    required this.hindiDua,
    required this.arabicZiyarat,
    required this.englishZiyarat,
    required this.gujratiZiyarat,
    required this.hindiZiyarat,
    required this.arabicSurah,
  });

  factory GenericAudioList.fromJson(Map<String, dynamic> json) =>
      _$GenericAudioListFromJson(json);

  Map<String, dynamic> toJson() => _$GenericAudioListToJson(this);
}

@JsonSerializable()
class GenericAudioItem {
  @JsonKey(name: 'caption')
  final String caption;

  @JsonKey(name: 'duration')
  final String duration;

  @JsonKey(name: 'file')
  final String file;

  @JsonKey(name: 'id')
  final dynamic id;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'track')
  final int track;

  @JsonKey(name: 'fav')
  String? fav;

  GenericAudioItem({
    required this.caption,
    required this.duration,
    required this.file,
    required this.id,
    required this.name,
    required this.track,
    required this.fav,
  });

  factory GenericAudioItem.fromJson(Map<String, dynamic> json) =>
      _$GenericAudioItemFromJson(json);

  Map<String, dynamic> toJson() => _$GenericAudioItemToJson(this);
}