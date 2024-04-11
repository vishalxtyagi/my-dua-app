

import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:dua/utils/strings.dart';

class AppProvider with ChangeNotifier {
  // app name
  String get appName => AppStrings.appName;

  // language
  String _language = 'English';
  String get appLanguage => _language;

  void setLanguage(String language) {
    _language = language;
    notifyListeners();
  }

  // coordinates
  Coordinates _coordinates = Coordinates(0.0, 0.0);

  Coordinates get coordinates => _coordinates;

  void setCoordinates(double lat, double long) {
    _coordinates = Coordinates(lat, long);
    notifyListeners();
  }

  // prayer times
  PrayerTimes? _prayerTimes;
  PrayerTimes? get prayerTimes => _prayerTimes;

  void setPrayerTimes(PrayerTimes prayerTimes) {
    Future.microtask(() {
      _prayerTimes = prayerTimes;
      notifyListeners();
    });
  }

  // headline
  String _headline = 'My Dua';
  String get headline => _headline;

  void setHeadline(String headline) {
    _headline = headline;
    notifyListeners();
  }

  // event
  String? _event;
  String? get event => _event;

  void setEvent(String event) {
    _event = event;
    notifyListeners();
  }

}