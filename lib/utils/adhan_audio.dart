import 'dart:developer';

import 'package:adhan/adhan.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> playAdhanAudio(Coordinates coordinates) async {
  final _player = AudioPlayer();
  final _notifications = FlutterLocalNotificationsPlugin();

  // Get the current prayer times
  final params = CalculationMethod.dubai.getParameters();
  final prayerTimes = PrayerTimes.today(coordinates, params);

  // Check the current time and play the adhan audio if it's time
  final now = DateTime.now();
  log('Playing Adhan Audio for: $now');
  if (now.isAfter(prayerTimes.fajr) && now.isBefore(prayerTimes.sunrise)) {
    await _player.setAsset('assets/azzan.mp3');
    await _player.play();
    await _notifications.show(
      0,
      'Fajr Adhan',
      'It\'s time for Fajr prayer.',
      NotificationDetails(
        android: AndroidNotificationDetails(
          'adhan_channel',
          'Adhan Notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  } else if (now.isAfter(prayerTimes.dhuhr) && now.isBefore(prayerTimes.asr)) {
    await _player.setAsset('assets/azzan.mp3');
    await _player.play();
    await _notifications.show(
      0,
      'Dhuhr Adhan',
      'It\'s time for Dhuhr prayer.',
      NotificationDetails(
        android: AndroidNotificationDetails(
          'adhan_channel',
          'Adhan Notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  } else if (now.isAfter(prayerTimes.asr) && now.isBefore(prayerTimes.maghrib)) {
    await _player.setAsset('assets/azzan.mp3');
    await _player.play();
    await _notifications.show(
      0,
      'Asr Adhan',
      'It\'s time for Asr prayer.',
      NotificationDetails(
        android: AndroidNotificationDetails(
          'adhan_channel',
          'Adhan Notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  } else if (now.isAfter(prayerTimes.maghrib) && now.isBefore(prayerTimes.isha)) {
    await _player.setAsset('assets/azzan.mp3');
    await _player.play();
    await _notifications.show(
      0,
      'Maghrib Adhan',
      'It\'s time for Maghrib prayer.',
      NotificationDetails(
        android: AndroidNotificationDetails(
          'adhan_channel',
          'Adhan Notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  } else if (now.isAfter(prayerTimes.isha)) {
    await _player.setAsset('assets/azzan.mp3');
    await _player.play();
    await _notifications.show(
      0,
      'Isha Adhan',
      'It\'s time for Isha prayer.',
      NotificationDetails(
        android: AndroidNotificationDetails(
          'adhan_channel',
          'Adhan Notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }
}
