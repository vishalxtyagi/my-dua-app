import 'package:dua/models/auth/auth_response.dart';
import 'package:dua/models/auth/profile_response.dart';
import 'package:dua/models/config/config_variables.dart';
import 'package:dua/models/user/user_data.dart';
import 'package:dua/services/api_service.dart';
import 'package:dua/utils/strings.dart';

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

  Future<ProfileResponse> changePassword(int userId, String oldPassword, String newPassword, String confirmNewPassword) async {
    final response = await apiService.fetchData<ProfileResponse>(
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
        fromJson: (json) => ProfileResponse.fromJson(json)
    );
    return response;
  }

  Future<UserData> getUserInfo(int userId) async {
    final response = await apiService.fetchData<UserData>(
        endpoint: '/userinfo',
        method: 'POST',
        query: {
          'userid': userId.toString()
        },
        fromJson: (json) => UserData.fromJson(json)
    );
    return response;
  }

  Future<ProfileResponse> updateUserInfo(int userId, String firstname, String lastname, String gender, String phone) async {
    final response = await apiService.fetchData<ProfileResponse>(
        endpoint: '/updateuserinfo',
        method: 'POST',
        query: {
          'userid': userId.toString()
        },
        data: {
          'firstname': firstname,
          'lastname': lastname,
          'gender': gender,
          'phone': phone
        },
        fromJson: (json) => ProfileResponse.fromJson(json)
    );
    return response;
  }

  Future<ConfigVariables> getConfigVariables() async {
    final response = await apiService.fetchData<ConfigVariables>(
        baseUrl: AppStrings.githubApiUrl,
        endpoint: '/actions/variables',
        headers: {
          'Authorization': 'Bearer ${AppStrings.githubToken}',
          'Accept': 'application/vnd.github+json',
          'X-GitHub-Api-Version': '2022-11-28'
        },
        fromJson: (json) => ConfigVariables.fromJson(json)
    );
    return response;
  }
}