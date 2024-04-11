import 'package:dua/models/generic/generic_audio_list.dart';
import 'package:flutter/material.dart';

class AudioProvider with ChangeNotifier {
  // Daily Dua
  GenericAudioList? _dailyDua;
  GenericAudioList? get dailyDua => _dailyDua;

  void setDailyDua(GenericAudioList dailyDua) {
    _dailyDua = dailyDua;
    notifyListeners();
  }

  // Dua
  GenericAudioList? _dua;
  GenericAudioList? get dua => _dua;

  void setDua(GenericAudioList? dua) {
    _dua = dua;
    notifyListeners();
  }

  // Surah
  GenericAudioList? _surah;
  GenericAudioList? get surah => _surah;

  void setSurah(GenericAudioList? surah) {
    _surah = surah;
    notifyListeners();
  }

  // Sahifa
  GenericAudioList? _sahifa;
  GenericAudioList? get sahifa => _sahifa;

  void setSahifa(GenericAudioList? sahifa) {
    _sahifa = sahifa;
    notifyListeners();
  }

  // Ziyarat
  GenericAudioList? _ziyarat;
  GenericAudioList? get ziyarat => _ziyarat;

  void setZiyarat(GenericAudioList? ziyarat) {
    _ziyarat = ziyarat;
    notifyListeners();
  }

  void clearAll() {
    _dailyDua = null;
    _dua = null;
    _surah = null;
    _sahifa = null;
    _ziyarat = null;
    notifyListeners();
  }

  // Favourite Dua
  List<GenericAudioItem>? _favouriteDua;
  List<GenericAudioItem>? get favouriteDua => _favouriteDua;

  void setFavouriteDua(List<GenericAudioItem>? favouriteDua) {
    _favouriteDua = favouriteDua;
    notifyListeners();
  }

  // Favourite Surah
  List<GenericAudioItem>? _favouriteSurah;
  List<GenericAudioItem>? get favouriteSurah => _favouriteSurah;

  void setFavouriteSurah(List<GenericAudioItem>? favouriteSurah) {
    _favouriteSurah = favouriteSurah;
    notifyListeners();
  }

  // Favourite Sahifa
  List<GenericAudioItem>? _favouriteSahifa;
  List<GenericAudioItem>? get favouriteSahifa => _favouriteSahifa;

  void setFavouriteSahifa(List<GenericAudioItem>? favouriteSahifa) {
    _favouriteSahifa = favouriteSahifa;
    notifyListeners();
  }

  // Favourite Ziyarat
  List<GenericAudioItem>? _favouriteZiyarat;
  List<GenericAudioItem>? get favouriteZiyarat => _favouriteZiyarat;

  void setFavouriteZiyarat(List<GenericAudioItem>? favouriteZiyarat) {
    _favouriteZiyarat = favouriteZiyarat;
    notifyListeners();
  }

  // Favorite All
  List<GenericAudioItem>? _favouriteAll;
  List<GenericAudioItem>? get favouriteAll => _favouriteAll;

  void setFavouriteAll(List<GenericAudioItem>? favouriteAll) {
    _favouriteAll = favouriteAll;
    notifyListeners();
  }

  void clearFavourite() {
    _favouriteDua = null;
    _favouriteSurah = null;
    _favouriteSahifa = null;
    _favouriteZiyarat = null;
    _favouriteAll = null;
    notifyListeners();
  }
}