import 'package:json_annotation/json_annotation.dart';
part 'config_variables.g.dart';

@JsonSerializable()
class ConfigVariables {
  @JsonKey(name: 'variables')
  final List<Map<String, dynamic>> variables;

  @JsonKey(name: 'total_count')
  final int totalCount;

  ConfigVariables({
    required this.variables,
    required this.totalCount
  });

  factory ConfigVariables.fromJson(Map<String, dynamic> json) =>
      _$ConfigVariablesFromJson(json);

  Map<String, dynamic> toJson() => _$ConfigVariablesToJson(this);
}