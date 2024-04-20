import 'dart:developer';

import 'package:adhan/adhan.dart';
import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> setAdhanAlarm(PrayerTimes prayerTimes) async {
  log('Setting adhan alarms for today...');
  List<DateTime> prayerTimesList = [
    prayerTimes.fajr,
    prayerTimes.sunrise,
    prayerTimes.dhuhr,
    prayerTimes.asr,
    prayerTimes.maghrib,
  ];

  int i = 40;

  for (DateTime prayerTime in prayerTimesList) {

    if (prayerTime.isBefore(DateTime.now())) {
      continue;
    }

    String prayerName = prayerTimes.currentPrayerByDateTime(prayerTime).name;

    final alarmSettings = AlarmSettings(
      id: i++,
      dateTime: prayerTime,
      assetAudioPath: 'assets/azzan.mp3',
      loopAudio: false,
      vibrate: true,
      volume: 1.0,
      fadeDuration: 3.0,
      notificationTitle: '$prayerName Adhan',
      notificationBody: 'It\'s time for $prayerName prayer',
      enableNotificationOnKill: true,
      androidFullScreenIntent: true,
    );

    await Alarm.set(alarmSettings: alarmSettings);
    log('Adhan alarm set for $prayerName at $prayerTime');
  }
}

Future<void> setAdhanForNextDay() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Coordinates coordinates = Coordinates(
      prefs.getDouble('latitude') ?? 0.0,
      prefs.getDouble('longitude') ?? 0.0
  );

  final params = CalculationMethod.dubai.getParameters();
  DateComponents tomorrow = DateComponents.from(DateTime.now().add(const Duration(days: 1)));
  log('Tomorrow: ${tomorrow.day}-${tomorrow.month}-${tomorrow.year}');
  log('Setting adhan alarms for next day...');

  final prayerTimes = PrayerTimes(
      coordinates,
      tomorrow,
      params
  );
  await setAdhanAlarm(prayerTimes);
}

Future<void> checkAndroidScheduleExactAlarmPermission() async {
  final status = await Permission.scheduleExactAlarm.status;
  print('Schedule exact alarm permission: $status.');
  if (status.isDenied) {
    print('Requesting schedule exact alarm permission...');
    final res = await Permission.scheduleExactAlarm.request();
    print('Schedule exact alarm permission ${res.isGranted ? '' : 'not'} granted.');
  }
}

Future<void> checkNotificationPermission() async {
  final status = await Permission.notification.status;
  print('Notification permission: $status.');
  if (status.isDenied) {
    print('Requesting notification permission...');
    final res = await Permission.notification.request();
    print('Notification permission ${res.isGranted ? '' : 'not'} granted.');
  }
}