// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThemeOptions _$ThemeOptionsFromJson(Map<String, dynamic> json) => ThemeOptions(
      message: SliderMessage.fromJson(json['message'] as Map<String, dynamic>),
      type: json['type'] as String,
    );

Map<String, dynamic> _$ThemeOptionsToJson(ThemeOptions instance) =>
    <String, dynamic>{
      'message': instance.message,
      'type': instance.type,
    };

SliderMessage _$SliderMessageFromJson(Map<String, dynamic> json) =>
    SliderMessage(
      animatedText: (json['animatedtext'] as List<dynamic>?)
          ?.map((e) => SliderAnimatedText.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SliderMessageToJson(SliderMessage instance) =>
    <String, dynamic>{
      'animatedtext': instance.animatedText,
    };

SliderAnimatedText _$SliderAnimatedTextFromJson(Map<String, dynamic> json) =>
    SliderAnimatedText(
      heading: json['heading'] as String,
    );

Map<String, dynamic> _$SliderAnimatedTextToJson(SliderAnimatedText instance) =>
    <String, dynamic>{
      'heading': instance.heading,
    };
