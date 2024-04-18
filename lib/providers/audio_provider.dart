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
}