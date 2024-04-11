import 'dart:developer';

import 'package:change_case/change_case.dart';
import 'package:dua/models/generic/generic_audio_list.dart';
import 'package:dua/providers/app_provider.dart';
import 'package:dua/providers/audio_provider.dart';
import 'package:dua/providers/auth_provider.dart';
import 'package:dua/services/api_service.dart';
import 'package:dua/services/my_dua_service.dart';
import 'package:dua/utils/colors.dart';
import 'package:dua/widgets/audio_card.dart';
import 'package:flutter/material.dart';
import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  final myDua = MyDuaService(ApiService());
  final prayers = {
    'fajr': Prayer.fajr,
    'sunrise': Prayer.sunrise,
    'dhuhr': Prayer.dhuhr,
    'sunset': Prayer.asr,
    'maghrib': Prayer.maghrib,
  };

  GenericAudioList? allAudioList;
  List<GenericAudioItem>? audioList;

  late AppProvider appProvider;
  late AuthProvider authProvider;
  late AudioProvider audioProvider;

  void fetchAudio() {
    audioProvider = Provider.of<AudioProvider>(context, listen: false);
    authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (audioProvider.sahifa == null) {
      myDua.getSahifa(userId: authProvider.userId).then((value) {
        audioProvider.setSahifa(value);

        setState(() {
          allAudioList = value;
        });
      });
    } else {
      setState(() {
        allAudioList = audioProvider.sahifa;
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

  @override
  void initState() {
    super.initState();

    fetchAudio();
  }

  @override
  Widget build(BuildContext context) {
    appProvider = Provider.of<AppProvider>(context);
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