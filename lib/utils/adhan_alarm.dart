import 'dart:developer';

import 'package:adhan/adhan.dart';
import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'coordinates.dart';

Future<void> setAdhanAlarm(PrayerTimes prayerTimes, {PrayerTimes? tomorrowPrayerTimes}) async {
  log('Setting adhan alarms for today...');
  List<DateTime> prayerTimesList = [
    prayerTimes.fajr,
    prayerTimes.sunrise,
    prayerTimes.dhuhr,
    prayerTimes.asr,
    prayerTimes.maghrib,
  ];

  int i = 39;

  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> keys = prefs.getKeys().where((key) => key.startsWith('alarm_')).toList();

  for (DateTime prayerTime in prayerTimesList) {
    Prayer currentPrayer = prayerTimes.currentPrayerByDateTime(prayerTime);
    String prayerName = currentPrayer.name;

    if (prayerTime.isBefore(DateTime.now())) {
      final nextDayPrayerTime = prayerTime.add(const Duration(days: 1));
      if (tomorrowPrayerTimes != null) {
        prayerTime = tomorrowPrayerTimes.timeForPrayer(currentPrayer) ?? nextDayPrayerTime;
      } else {
        prayerTime = nextDayPrayerTime;
      }
    }

    final alarmSettings = AlarmSettings(
      id: ++i,
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

    if (prefs.getBool('alarm_$i') ?? true) {
      await Alarm.set(alarmSettings: alarmSettings);
      await prefs.setBool('alarm_$i', true);
      log('Adhan alarm set for $prayerName at $prayerTime');
    }

    keys.remove('alarm_$i');
  }

  for (String key in keys) {
    await prefs.remove(key);
  }
}

Future<void> updateAdhanAlarm() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  MyCoordinates coordinates = MyCoordinates(
      prefs.getDouble('latitude') ?? 0.0,
      prefs.getDouble('longitude') ?? 0.0
  );

  final params = CalculationMethod.karachi.getParameters();
  DateComponents tomorrow = DateComponents.from(DateTime.now().add(const Duration(days: 1)));
  log('Tomorrow: ${tomorrow.day}-${tomorrow.month}-${tomorrow.year}');

  final prayerTimes = PrayerTimes.today(coordinates, params);
  final nextPrayerTimes = PrayerTimes(
      coordinates,
      tomorrow,
      params
  );
  await setAdhanAlarm(prayerTimes, tomorrowPrayerTimes: nextPrayerTimes);
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