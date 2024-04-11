import 'package:json_annotation/json_annotation.dart';
part 'hijri_date_api.g.dart';

@JsonSerializable()
class HijriDateApi {
  @JsonKey(name: 'event')
  final String? event;

  @JsonKey(name: 'event_color')
  final String? eventColor;

  @JsonKey(name: 'hijri_date')
  final String? hijriDate;

  HijriDateApi({
    required this.event,
    required this.eventColor,
    required this.hijriDate,
  });

  factory HijriDateApi.fromJson(Map<String, dynamic> json) =>
      _$HijriDateApiFromJson(json);

  Map<String, dynamic> toJson() => _$HijriDateApiToJson(this);
}