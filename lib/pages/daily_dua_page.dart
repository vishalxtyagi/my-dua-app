import 'dart:developer';

import 'package:change_case/change_case.dart';
import 'package:dua/models/generic/generic_audio_list.dart';
import 'package:dua/providers/app_provider.dart';
import 'package:dua/providers/audio_provider.dart';
import 'package:dua/services/api_service.dart';
import 'package:dua/services/my_dua_service.dart';
import 'package:dua/utils/colors.dart';
import 'package:dua/utils/helper.dart';
import 'package:dua/widgets/audio_card.dart';
import 'package:flutter/material.dart';
import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


class DailyDuaPage extends StatefulWidget {
  @override
  _DailyDuaPageState createState() => _DailyDuaPageState();
}

class _DailyDuaPageState extends State<DailyDuaPage> {
  final myDua = MyDuaService(ApiService());
  final prayers = {
    'fajr': Prayer.fajr,
    'sunrise': Prayer.sunrise,
    'dhuhr': Prayer.dhuhr,
    'sunset': Prayer.asr,
    'maghrib': Prayer.maghrib,
  };

  bool isPrayerLoading = true;

  GenericAudioList? allAudioList;
  List<GenericAudioItem>? audioList;

  late AppProvider appProvider;
  late AudioProvider audioProvider;

  void fetchAudio() async {
    audioProvider = Provider.of<AudioProvider>(context, listen: false);
    if (audioProvider.dailyDua == null) {
      final day = getWeekdayName();
      log('Day: $day');
      await myDua.getDailyDua(day).then((value) {
        audioProvider.setDailyDua(value);

        setState(() {
          allAudioList = value;
        });
      });
    } else {
      setState(() {
        allAudioList = audioProvider.dailyDua;
      });
    }
  }

  List<GenericAudioItem>? getAudioList(String? language) {
    if (allAudioList == null) {
      return null;
    }

    switch (language) {
      case 'عربي':
        return allAudioList!.arabicDua;
      case 'हिंदी':
        return allAudioList!.hindiDua;
      case 'English':
        return allAudioList!.englishDua;
      case 'ગુજરાતી':
        return allAudioList!.gujratiDua;
      default:
        return allAudioList!.arabicDua;
    }
  }

  void fetchPrayerTimesIfNeeded() {
    log('isPrayerLoading: $isPrayerLoading');
    if (isPrayerLoading) {
      final params = CalculationMethod.dubai.getParameters();
      final prayerTimes = PrayerTimes.today(appProvider.coordinates, params);
      appProvider.setPrayerTimes(prayerTimes);
      setState(() {
        isPrayerLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    fetchAudio();
  }

  @override
  Widget build(BuildContext context) {
    appProvider = Provider.of<AppProvider>(context);
    fetchPrayerTimesIfNeeded();

    audioList = getAudioList(appProvider.appLanguage);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (var prayer in prayers.keys)
              Column(
                children: [
                  Image.asset(
                    'assets/images/$prayer.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 8),
                  Text(prayer.toTitleCase(), style: TextStyle(fontSize: 16)),
                  if (appProvider.prayerTimes != null)
                    Text(
                      DateFormat.jm().format(
                        appProvider.prayerTimes!.timeForPrayer(prayers[prayer]!)!,
                      ),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                        fontSize: 14,
                      ),
                    ),
                ],
              ),
          ],
        ),
        SizedBox(height: 20),
        Expanded(
          child: audioList == null
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: audioList!.length,
                  itemBuilder: (context, index) {
                    final audio = audioList![index];
                    return AudioCard(
                      title: audio.name,
                      duration: audio.duration,
                      audioUrl: audio.file,
                    );
                  },
              ),
        )
      ],
    );
  }

}