import 'dart:developer';

import 'package:adhan/adhan.dart';
import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:dua/utils/colors.dart';
import 'package:dua/utils/coordinates.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlarmPage extends StatefulWidget {
  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  Map<int, Prayer> prayers = {
    40: Prayer.fajr,
    41: Prayer.sunrise,
    42: Prayer.dhuhr,
    43: Prayer.asr,
    44: Prayer.maghrib,
  };
  List<AlarmSettings> alarms = Alarm.getAlarms();
  Map<int, bool> alarmStatus = {};

  @override
  void initState() {
    super.initState();

    alarmStatus = Map<int, bool>.fromIterable(alarms.map((alarm) => alarm.id), value: (_) => true);
    updateAlarmStatus();
    log(alarmStatus.toString());
  }

  void updateAlarmStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> keys = prefs.getKeys()
        .where((key) => key.startsWith('alarm_'))
        .toList();

    for (String key in keys) {
      int alarmId = int.parse(key.split('_')[1]);
      bool? status = prefs.getBool(key);
      if (status != null) {
        alarmStatus[alarmId] = status;
      }
    }

    List<int> disabledAlarms = alarmStatus.keys.where((id) => !alarms.any((alarm) => alarm.id == id)).toList();
    addDisabledAlarms(disabledAlarms, prefs);
  }

  void addDisabledAlarms(List<int> disabledAlarms, SharedPreferences prefs) async {
    log(disabledAlarms.toString());

    final params = CalculationMethod.karachi.getParameters();
    MyCoordinates coordinates = MyCoordinates(
        prefs.getDouble('latitude') ?? 0.0,
        prefs.getDouble('longitude') ?? 0.0
    );
    PrayerTimes prayerTimes = PrayerTimes.today(coordinates, params);

    for (int alarmId in disabledAlarms) {
      if (prayers[alarmId] == null) {
        continue;
      }

      String prayerName = prayers[alarmId]!.name;
      DateTime prayerTime = prayerTimes.timeForPrayer(prayers[alarmId]!) ?? DateTime.now().add(const Duration(days: 1));
      setState(() {
        alarms.add(AlarmSettings(
          id: alarmId,
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
        ));
      });
    }

    setState(() {
      alarms.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Image.asset(
              'assets/images/logoi.png',
              width: 225
          ),
          backgroundColor: AppColors.primaryColor,
          centerTitle: true,
        ),
        body: alarms.isEmpty ? const Center(
          child: Text('Oops! No alarms set yet...'),
        ) : ListView.builder(
          itemCount: alarms.length,
          padding: const EdgeInsets.all(10),
          itemBuilder: (context, index) {
            DateTime alarmTime = alarms[index].dateTime;
            int alarmId = alarms[index].id;
            return Card(
              margin: EdgeInsets.only(bottom: 15.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
                side: BorderSide(
                  color: AppColors.blackColor,
                ),
              ),
              color: alarmTime.day == DateTime.now().day ? Colors.yellow[200] : null,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                title: Text(
                    '${prayers[alarmId]?.name ?? 'Unknown'} Alarm',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                subtitle: Text(DateFormat('MMM d, yyyy hh:mm a').format(alarmTime)),
                leading: Icon(Icons.alarm),
                // show duration from now
                trailing: Switch(
                  value: alarmStatus[alarmId] ?? false,
                  onChanged: (value) async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();

                    if (value) {
                      await Alarm.set(alarmSettings: alarms[index]);
                      await prefs.setBool('alarm_$alarmId', true);
                    } else {
                      await Alarm.stop(alarmId);
                      await prefs.setBool('alarm_$alarmId', false);
                    }

                    setState(() {
                      alarmStatus[alarmId] = value;
                    });
                    log(alarmStatus.toString());
                  },
                ),
              ),
            );
          },
        )
    );
  }
}