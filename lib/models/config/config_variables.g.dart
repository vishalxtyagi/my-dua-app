// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_variables.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfigVariables _$ConfigVariablesFromJson(Map<String, dynamic> json) =>
    ConfigVariables(
      variables: (json['variables'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      totalCount: json['total_count'] as int,
    );

Map<String, dynamic> _$ConfigVariablesToJson(ConfigVariables instance) =>
    <String, dynamic>{
      'variables': instance.variables,
      'total_count': instance.totalCount,
    };
