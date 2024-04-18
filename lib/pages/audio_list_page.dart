import 'dart:developer';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:dua/models/generic/generic_audio_list.dart';
import 'package:dua/pages/auth/login_page.dart';
import 'package:dua/providers/app_provider.dart';
import 'package:dua/providers/audio_provider.dart';
import 'package:dua/providers/auth_provider.dart';
import 'package:dua/services/api_service.dart';
import 'package:dua/services/my_dua_service.dart';
import 'package:dua/utils/colors.dart';
import 'package:dua/utils/player.dart';
import 'package:dua/widgets/audio_card.dart';
import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';


class AudioListPage extends StatefulWidget {
  final String type;

  const AudioListPage({super.key, required this.type});

  @override
  _AudioListPageState createState() => _AudioListPageState();
}

class _AudioListPageState extends State<AudioListPage> {
  final myDua = MyDuaService(ApiService());
  final today = HijriCalendar.now();

  final List<String> _languages = ['عربي', 'हिंदी', 'English', 'ગુજરાતી'];

  late AppProvider appProvider;
  late AuthProvider authProvider;
  late AudioProvider audioProvider;

  GenericAudioList? allAudioList;
  List<GenericAudioItem>? audioList;

  void fetchAudio() {
    audioProvider = Provider.of<AudioProvider>(context, listen: false);
    authProvider = Provider.of<AuthProvider>(context, listen: false);

    log('Fetching audio for: ${widget.type}');
    switch (widget.type) {
      case 'surah':
        fetchSurahAudio();
        break;
      case 'sahifaSajjadia':
        fetchSahifaAudio();
        break;
      default:
        fetchSahifaAudio();
    }
  }

  void fetchSurahAudio() {
    if (audioProvider.surah == null) {
      myDua.getSurah(userId: authProvider.userId).then((value) {
        audioProvider.setSurah(value);

        setState(() {
          allAudioList = value;
        });
      });
    }

    setState(() {
      allAudioList = audioProvider.surah;
    });
  }

  void fetchSahifaAudio() {
    if (audioProvider.sahifa == null) {
      myDua.getSahifa(userId: authProvider.userId).then((value) {
        audioProvider.setSahifa(value);

        setState(() {
          allAudioList = value;
        });
      });
    }

    setState(() {
      allAudioList = audioProvider.sahifa;
    });
  }

  List<GenericAudioItem>? getAudioList(String? language) {
    if (allAudioList == null) {
      return null;
    }

    if (widget.type == 'surah') {
      return allAudioList!.arabicSurah;
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

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Image.asset(
              'assets/images/logoi.png',
              width: 225
          ),
          backgroundColor: AppColors.primaryColor,
          centerTitle: true,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (appProvider.headline.isNotEmpty)
              Container(
                color: AppColors.marqueeBgColor,
                height: 35.0,
                child: Marquee(
                  text: appProvider.headline,
                  style: const TextStyle(fontSize: 16),
                  startAfter: const Duration(seconds: 2),
                  startPadding: 50,
                  blankSpace: 50,
                ),
              ),
            SizedBox(height: 12),
            Text(
              today.fullDate(),
              style: const TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18
              ),
              textAlign: TextAlign.center,
            ),
            if (appProvider.event != null && appProvider.event!.isNotEmpty)
              Text(
                appProvider.event!,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                ),
                textAlign: TextAlign.center,
              ),
            SizedBox(height: 12),
            Expanded(
              child: audioList == null
                  ? const Center(child: CircularProgressIndicator())
                  : (audioList!.isEmpty ? Center(child: Text('No ${widget.type} found', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))
                  : ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: audioList!.length,
                itemBuilder: (context, index) {
                  GenericAudioItem audio = audioList![index];
                  return AudioCard(
                      title: audio.name,
                      duration: audio.duration,
                      audioUrl: audio.file,
                      isFavorite: audio.fav != null && audio.fav == 'Yes',
                      onFavoritePressed: () {
                        if (authProvider.userId == null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        } else {
                          if (widget.type == "surah") {
                            myDua.updateSurahDua(authProvider.userId!, audio.id)
                                .then((value) {
                              if (value.type == 'success') {
                                setState(() {
                                  audio.fav = value.fav;
                                });
                              }
                            });
                          } else {
                            myDua.updateFavSahifa(authProvider.userId!, audio.id)
                                .then((value) {
                              if (value.type == 'success') {
                                setState(() {
                                  audio.fav = value.fav;
                                });
                              }
                            });
                          }
                        }
                      }
                  );
                },
              )),
            ),
            CustomDropdown<String>(
              hintText: 'Select Language',
              items: _languages,
              initialItem: appProvider.appLanguage,
              decoration: CustomDropdownDecoration(
                closedFillColor: AppColors.marqueeBgColor,
                closedBorderRadius: BorderRadius.circular(0),
              ),
              onChanged: (value) {
                log('changing language to: $value');
                appProvider.setLanguage(value);
              },
            ),
            AppPlayer.playerView(),
          ],
        ),
      ),
    );
  }

}