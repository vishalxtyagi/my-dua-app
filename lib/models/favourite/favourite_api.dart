import 'package:json_annotation/json_annotation.dart';
part 'favourite_api.g.dart';

@JsonSerializable()
class FavouriteApi {
  @JsonKey(name: 'fav')
  final String fav;

  @JsonKey(name: 'icon')
  final String icon;

  @JsonKey(name: 'type')
  final String type;


  FavouriteApi({
    required this.type,
    String? fav,
    String? icon,
  })  : fav = fav ?? icon ?? '',
        icon = icon ?? '';

  factory FavouriteApi.fromJson(Map<String, dynamic> json) =>
      _$FavouriteApiFromJson(json);

  Map<String, dynamic> toJson() => _$FavouriteApiToJson(this);
}