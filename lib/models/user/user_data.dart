import 'package:json_annotation/json_annotation.dart';
part 'user_data.g.dart';

@JsonSerializable()
class UserData {
  @JsonKey(name: 'email')
  final String email;

  @JsonKey(name: 'firstname')
  final String firstname;

  @JsonKey(name: 'lastname')
  final String lastname;

  @JsonKey(name: 'gender')
  final String gender;

  @JsonKey(name: 'phone')
  final String phone;

  UserData({
    required this.email,
    required this.firstname,
    required this.lastname,
    required this.gender,
    required this.phone,
  });

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}