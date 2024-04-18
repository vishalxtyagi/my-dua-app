import 'dart:developer';

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


class FavouritePage extends StatefulWidget {

  @override
  _FavouritePageState createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  final myDua = MyDuaService(ApiService());
  final today = HijriCalendar.now();

  final Map<String, dynamic> _tiles = {
    'dua': {
      'title': 'Listen your favorite Dua',
      'icon': 'dua_icon.jpg'
    },
    'sahifa': {
      'title': 'Listen your favorite Sahifa Sajjadia',
      'icon': 'sahifa_icon.jpg'
    },
    'ziyarat': {
      'title': 'Listen your favorite Ziyarat',
      'icon': 'ziyarat_icon.jpg'
    },
    'surah': {
      'title': 'Listen your favorite Surah',
      'icon': 'surah_icon.jpg'
    },
    'all': {
      'title': 'Listen all your favorite',
      'icon': 'all_fav_icon.jpg'
    },
  };

  late AppProvider appProvider;
  late AuthProvider authProvider;

  List<GenericAudioItem>? audioList;
  String favouriteType = 'dua';

  void fetchFavDua() {
    myDua.getFavDua(authProvider.userId!).then((value) {
      setState(() {
        audioList = value;
      });
    });
  }

  void fetchFavSahifa() {
    myDua.getFavSahifa(authProvider.userId!).then((value) {
      setState(() {
        audioList = value;
      });
    });
  }

  void fetchFavZiyarat() {
    myDua.getFavZiyarat(authProvider.userId!).then((value) {
      setState(() {
        audioList = value;
      });
    });
  }

  void fetchFavSurah() {
    myDua.getFavSurah(authProvider.userId!).then((value) {
      setState(() {
        audioList = value;
      });
    });
  }

  void fetchFavAll() {
    myDua.getFavAll(authProvider.userId!).then((value) {
      setState(() {
        audioList = value;
      });
    });
  }

  void fetchAudio() async {
    authProvider = Provider.of<AuthProvider>(context, listen: false);

    setState(() {
      audioList = null;
    });

    switch (favouriteType) {
      case 'dua':
        fetchFavDua();
        break;
      case 'sahifa':
        fetchFavSahifa();
        break;
      case 'ziyarat':
        fetchFavZiyarat();
        break;
      case 'surah':
        fetchFavSurah();
        break;
      case 'all':
        fetchFavAll();
        break;
      default:
        fetchFavDua();
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
                  : (audioList!.isEmpty ? Center(child: Text('No favourite $favouriteType found', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))
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
                          myDua.updateFavDua(authProvider.userId!, int.parse(audio.id)).then((
                              value) {
                            if (value.type == 'success') {
                              setState(() {
                                audio.fav = value.fav;
                              });

                              if (value.fav == 'No') {
                                audioList!.removeAt(index);
                              }
                            }
                          });
                        }
                      }
                  );
                },
              )),
            ),
            AppPlayer.playerView(),
            Container(
              color: AppColors.primaryColor,
              margin: const EdgeInsets.symmetric(vertical: 10),
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (var tile in _tiles.keys)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          favouriteType = tile;
                          fetchAudio();
                        });
                      },
                      child: Container(
                        width: 180,
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.blackColor,
                          ),
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/${_tiles[tile]!['icon']}',
                              height: 100,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(height: 12),
                            Text(
                              _tiles[tile]!['title'],
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

}