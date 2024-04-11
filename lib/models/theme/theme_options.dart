import 'package:json_annotation/json_annotation.dart';
part 'theme_options.g.dart';

@JsonSerializable()
class ThemeOptions {

  @JsonKey(name: 'message')
  final SliderMessage message;

  @JsonKey(name: 'type')
  final String type;

  ThemeOptions({
    required this.message,
    required this.type,
  });

  factory ThemeOptions.fromJson(Map<String, dynamic> json) => _$ThemeOptionsFromJson(json);
  Map<String, dynamic> toJson() => _$ThemeOptionsToJson(this);
}

@JsonSerializable()
class SliderMessage {
  @JsonKey(name: 'animatedtext')
  final List<SliderAnimatedText>? animatedText;

  SliderMessage({required this.animatedText});

  factory SliderMessage.fromJson(Map<String, dynamic> json) => _$SliderMessageFromJson(json);
  Map<String, dynamic> toJson() => _$SliderMessageToJson(this);
}

@JsonSerializable()
class SliderAnimatedText {
  final String heading;

  SliderAnimatedText({required this.heading});

  factory SliderAnimatedText.fromJson(Map<String, dynamic> json) => _$SliderAnimatedTextFromJson(json);
  Map<String, dynamic> toJson() => _$SliderAnimatedTextToJson(this);
}
