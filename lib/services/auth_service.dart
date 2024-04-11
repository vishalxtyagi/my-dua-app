import 'package:dua/models/auth/auth_response.dart';
import 'package:dua/services/api_service.dart';

class AuthService {
  final ApiService apiService;

  AuthService(this.apiService);

  Future<AuthResponse> signUp(String username, String email, String password, String firstName, String lastName) async {
    final response = await apiService.fetchData<AuthResponse>(
        endpoint: '/register',
        method: 'POST',
        query: {
          'username': username,
          'email': email,
          'password': password,
          'firstname': firstName,
          'lastname': lastName
        },
        fromJson: (json) => AuthResponse.fromJson(json)
    );
    return response;
  }

  Future<AuthResponse> login(String username, String password) async {
    final response = await apiService.fetchData<AuthResponse>(
        endpoint: '/login',
        method: 'POST',
        query: {
          'username': username,
          'password': password
        },
        fromJson: (json) => AuthResponse.fromJson(json)
    );
    return response;
  }

  Future<AuthResponse> forgotPassword(String email) async {
    final response = await apiService.fetchData<AuthResponse>(
        endpoint: '/forget_password',
        method: 'POST',
        query: {
          'email': email
        },
        fromJson: (json) => AuthResponse.fromJson(json)
    );
    return response;
  }

  Future<AuthResponse> changePassword(int userId, String oldPassword, String newPassword, String confirmNewPassword) async {
    final response = await apiService.fetchData<AuthResponse>(
        endpoint: '/changepassword',
        method: 'POST',
        query: {
          'userid': userId.toString()
        },
        data: {
          'oldpassword': oldPassword,
          'newpassword': newPassword,
          'cnewpassword': confirmNewPassword
        },
        fromJson: (json) => AuthResponse.fromJson(json)
    );
    return response;
  }
}