import 'dart:async';
import 'dart:developer';

import 'package:app_settings/app_settings.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:intl/intl.dart';

// Check internet connectivity
void checkInternetConnectivity(void Function(bool isConnected) onCompletion, {void Function(bool isVPN)? onProxy}) async {
  final List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult.contains(ConnectivityResult.vpn)) {
    onProxy?.call(true);
    return;
  }

  final isConnected = connectivityResult.contains(ConnectivityResult.mobile) || connectivityResult.contains(ConnectivityResult.wifi);
  onCompletion(isConnected);
}

// Get current Location coordinates
Future<void> determinePosition(void Function(double lat, double long) onCompletion, void Function(String error) onError) async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    onError('Location services are disabled.');
    AppSettings.openAppSettings(type: AppSettingsType.location);
    return;
  }

  permission = await Geolocator.checkPermission();
  log('Permission: $permission');

  if (permission == LocationPermission.denied) {
    onError('Please enable location services to use the app.');
    while (permission == LocationPermission.denied) {
      AppSettings.openAppSettings(type: AppSettingsType.location);
      permission = await Geolocator.requestPermission();
    }
  }

  final position = await Geolocator.getCurrentPosition();
  onCompletion(position.latitude, position.longitude);
}

// Format Heading
String formatHeading(String heading) {
  final cleanedHeading = html_parser.parse(heading).documentElement!.text;
  final boldText = cleanedHeading.replaceAllMapped(RegExp(r'<b>(.*?)</b>'), (match) {
    final boldContent = match.group(1)!;
    return '<b>$boldContent</b>';
  });
  return boldText;
}

String getWeekdayName() {
  DateTime now = DateTime.now();
  String weekdayName = DateFormat('EEEE').format(now);
  return weekdayName;
}