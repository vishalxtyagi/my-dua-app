import 'package:dua/models/event/hijri_date_api.dart';
import 'package:dua/models/favourite/favourite_api.dart';
import 'package:dua/models/generic/generic_audio_list.dart';
import 'package:dua/models/theme/theme_options.dart';
import 'package:dua/services/api_service.dart';

class MyDuaService {
  final ApiService apiService;

  MyDuaService(this.apiService);

  Future<ThemeOptions> getHeadLines() async {
    final response = await apiService.fetchData<ThemeOptions>(
        endpoint: '/themeoptions',
        fromJson: (json) => ThemeOptions.fromJson(json)
    );
    return response;
  }

  Future<HijriDateApi> getEvent() async {
    final response = await apiService.fetchData<HijriDateApi>(
        method: 'POST',
        endpoint: '/hijridateapi',
        fromJson: (json) => HijriDateApi.fromJson(json)
    );
    return response;
  }

  Future<GenericAudioList> getDailyDua(String day) async {
    final response = await apiService.fetchData<GenericAudioList>(
        endpoint: '/dailydua',
        query: {'day': day},
        fromJson: (json) => GenericAudioList.fromJson(json)
    );
    return response;
  }

  // Sahifa
  Future<GenericAudioList> getSahifa({int? userId}) async {
    final response = await apiService.fetchData<GenericAudioList>(
        endpoint: '/sahifalist',
        query: userId != null ? {'userid': userId.toString()} : {},
        fromJson: (json) => GenericAudioList.fromJson(json)
    );
    return response;
  }

  Future<FavouriteApi> updateFavSahifa(int userId, int audioId) async {
    final response = await apiService.fetchData<FavouriteApi>(
        endpoint: '/sahifafavaudio',
        query: {
          'userid': userId.toString(),
          'audioid': audioId.toString()
        },
        method: 'POST',
        fromJson: (json) => FavouriteApi.fromJson(json)
    );
    return response;
  }

  Future<List<GenericAudioItem>> getFavSahifa(int userId) async {
    final response = await apiService.fetchData<List<GenericAudioItem>>(
        endpoint: '/favouriteshifa',
        query: {'userid': userId.toString()},
        fromJson: (json) => (json as List).map((e) => GenericAudioItem.fromJson(e)).toList(),
    );
    return response;
  }

  // Ziyarat
  Future<GenericAudioList> getZiyarat({int? userId}) async {
    final response = await apiService.fetchData<GenericAudioList>(
        endpoint: '/ziyaratlist',
        query: userId != null ? {'userid': userId.toString()} : {},
        fromJson: (json) => GenericAudioList.fromJson(json)
    );
    return response;
  }

  Future<FavouriteApi> updateFavZiyarat(int userId, int audioId) async {
    final response = await apiService.fetchData<FavouriteApi>(
        endpoint: '/ziyaratfavaudio',
        query: {
          'userid': userId.toString(),
          'audioid': audioId.toString()
        },
        method: 'POST',
        fromJson: (json) => FavouriteApi.fromJson(json)
    );
    return response;
  }

  Future<List<GenericAudioItem>> getFavZiyarat(int userId) async {
    final response = await apiService.fetchData<List<GenericAudioItem>>(
      endpoint: '/favouriteziyarat',
      query: {'userid': userId.toString()},
      fromJson: (json) => (json as List).map((e) => GenericAudioItem.fromJson(e)).toList(),
    );
    return response;
  }

  // Dua
  Future<GenericAudioList> getDua({int? userId}) async {
    final response = await apiService.fetchData<GenericAudioList>(
        endpoint: '/dualist',
        query: userId != null ? {'userid': userId.toString()} : {},
        fromJson: (json) => GenericAudioList.fromJson(json)
    );
    return response;
  }

  Future<FavouriteApi> updateFavDua(int userId, int audioId) async {
    final response = await apiService.fetchData<FavouriteApi>(
        endpoint: '/duafavaudio',
        query: {
          'userid': userId.toString(),
          'audioid': audioId.toString()
        },
        method: 'POST',
        fromJson: (json) => FavouriteApi.fromJson(json)
    );
    return response;
  }

  Future<List<GenericAudioItem>> getFavDua(int userId) async {
    final response = await apiService.fetchData<List<GenericAudioItem>>(
      endpoint: '/favouritedua',
      query: {'userid': userId.toString()},
      fromJson: (json) => (json as List).map((e) => GenericAudioItem.fromJson(e)).toList(),
    );
    return response;
  }

  // Surah
  Future<GenericAudioList> getSurah({int? userId}) async {
    final response = await apiService.fetchData<GenericAudioList>(
        endpoint: '/surahlist',
        query: userId != null ? {'userid': userId.toString()} : {},
        fromJson: (json) => GenericAudioList.fromJson(json)
    );
    return response;
  }

  Future<FavouriteApi> updateSurahDua(int userId, int audioId) async {
    final response = await apiService.fetchData<FavouriteApi>(
        endpoint: '/surahfavaudio',
        query: {
          'userid': userId.toString(),
          'audioid': audioId.toString()
        },
        method: 'POST',
        fromJson: (json) => FavouriteApi.fromJson(json)
    );
    return response;
  }

  Future<List<GenericAudioItem>> getFavSurah(int userId) async {
    final response = await apiService.fetchData<List<GenericAudioItem>>(
      endpoint: '/favouritesurah',
      query: {'userid': userId.toString()},
      fromJson: (json) => (json as List).map((e) => GenericAudioItem.fromJson(e)).toList(),
    );
    return response;
  }

  // Favourite All
  Future<FavouriteApi> updateFavAll(int userId, int audioId) async {
    final response = await apiService.fetchData<FavouriteApi>(
        endpoint: '/allfavourite',
        query: {
          'userid': userId.toString(),
          'audioid': audioId.toString()
        },
        method: 'POST',
        fromJson: (json) => FavouriteApi.fromJson(json)
    );
    return response;
  }

  Future<List<GenericAudioItem>> getFavAll(int userId) async {
    final response = await apiService.fetchData<List<GenericAudioItem>>(
      endpoint: '/allfavourite',
      query: {'userid': userId.toString()},
      fromJson: (json) => (json as List<Map<String, dynamic>>).map((e) => GenericAudioItem.fromJson(e)).toList(),
    );
    return response;
  }

}