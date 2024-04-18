import 'dart:developer';

import 'package:dua/models/generic/generic_audio_list.dart';
import 'package:dua/pages/auth/login_page.dart';
import 'package:dua/providers/app_provider.dart';
import 'package:dua/providers/audio_provider.dart';
import 'package:dua/providers/auth_provider.dart';
import 'package:dua/services/api_service.dart';
import 'package:dua/services/my_dua_service.dart';
import 'package:dua/widgets/audio_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class DuaPage extends StatefulWidget {
  @override
  _DuaPageState createState() => _DuaPageState();
}

class _DuaPageState extends State<DuaPage> {
  final myDua = MyDuaService(ApiService());

  GenericAudioList? allAudioList;
  List<GenericAudioItem>? audioList;

  late AppProvider appProvider;
  late AuthProvider authProvider;
  late AudioProvider audioProvider;

  void fetchAudio() {
    audioProvider = Provider.of<AudioProvider>(context, listen: false);
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (audioProvider.dua == null) {
      myDua.getDua(userId: authProvider.userId).then((value) {
        audioProvider.setDua(value);

        setState(() {
          allAudioList = value;
        });
      });
    } else {
      setState(() {
        allAudioList = audioProvider.dua;
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
        Expanded(
          child: audioList == null
              ? const Center(child: CircularProgressIndicator())
              : (audioList!.isEmpty ? const Center(child: Text('No Dua found', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))
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
                    myDua.updateFavDua(authProvider.userId!, audio.id).then((
                        value) {
                      if (value.type == 'success') {
                        setState(() {
                          audio.fav = value.fav;
                        });
                      }
                    });
                  }
                }
              );
            },
          )),
        )
      ],
    );
  }

}