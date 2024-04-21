import 'dart:developer';

import 'package:dua/models/user/user_data.dart';
import 'package:dua/services/api_service.dart';
import 'package:dua/services/auth_service.dart';

// login
void login(Map<String, dynamic> credentials, {void Function(int userId)? onSuccess, void Function(String message)? onError}) async {
  final AuthService auth = AuthService(ApiService());

  try {
    final response = await auth.login(
        credentials['username'],
        credentials['password']
    );

    if (response.type != 'success') {
      onError?.call(response.message);
      return;
    }

    final currentUserId = int.parse(response.message['data']['ID']);

    onSuccess?.call(currentUserId);
  } catch (e) {
    onError?.call(e.toString());
  }
}

// signup
void signup(Map<String, dynamic> userDetails, {void Function(String message)? onSuccess, void Function(String message)? onError}) async {
  final AuthService auth = AuthService(ApiService());

  try {
    final response = await auth.signUp(
      userDetails['username'],
      userDetails['email'],
      userDetails['password'],
      userDetails['firstname'],
      userDetails['lastname']
    );

    if (response.type != 'success') {
      onError?.call(response.message);
      return;
    }

    onSuccess?.call(response.message);
  } catch (e) {
    onError?.call(e.toString());
  }
}

// forgot password
void forgotPassword(String email, {void Function(String message)? onSuccess, void Function(String message)? onError}) async {
  final AuthService auth = AuthService(ApiService());

  try {
    final response = await auth.forgotPassword(email);

    if (response.type != 'success') {
      onError?.call(response.message);
      return;
    }

    onSuccess?.call(response.message);
  } catch (e) {
    onError?.call(e.toString());
  }
}


// change password
void changePassword(Map<String, dynamic> passDetails, int userId, {void Function(String message)? onSuccess, void Function(String message)? onError}) async {
  final AuthService auth = AuthService(ApiService());

  log('Change Password: $passDetails');

  try {
    final response = await auth.changePassword(
        userId,
        passDetails['oldPassword'],
        passDetails['newPassword'],
        passDetails['confirmPassword']
    );

    if (response.type != 'success') {
      onError?.call(response.msg);
      return;
    }

    onSuccess?.call(response.msg);
  } catch (e) {
    onError?.call(e.toString());
  }
}

// update profile
void updateProfile(Map<String, dynamic> profileDetails, int userId, {void Function(String message)? onSuccess, void Function(String message)? onError}) async {
  final AuthService auth = AuthService(ApiService());

  try {
    final response = await auth.updateUserInfo(
        userId,
        profileDetails['firstname'],
        profileDetails['lastname'],
        profileDetails['gender'],
        profileDetails['countryCode'] + profileDetails['phone'],
    );

    onSuccess?.call(response.msg);
  } catch (e) {
    onError?.call(e.toString());
  }
}


// get profile
void getProfile(int userId, {void Function(UserData userData)? onSuccess, void Function(String message)? onError}) async {
  final AuthService auth = AuthService(ApiService());

  try {
    final response = await auth.getUserInfo(userId);

    onSuccess?.call(response);
  } catch (e) {
    onError?.call(e.toString());
  }
}

void getConfig({void Function(List<dynamic> variables)? onSuccess, void Function(String message)? onError}) async {
  final AuthService auth = AuthService(ApiService());

  try {
    final response = await auth.getConfigVariables();

    onSuccess?.call(response.variables);
  } catch (e) {
    onError?.call(e.toString());
  }
}