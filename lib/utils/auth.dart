import 'dart:developer';

import 'package:dua/providers/auth_provider.dart';
import 'package:dua/services/api_service.dart';
import 'package:dua/services/auth_service.dart';

// login
void login(String username, String password, {void Function(int userId)? onSuccess, void Function(String message)? onError}) async {
  final AuthService auth = AuthService(ApiService());

  try {
    final response = await auth.login(username, password);

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