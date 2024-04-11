import 'package:bottom_navbar_player/bottom_navbar_player.dart';
import 'package:flutter/cupertino.dart';

class AppPlayer {
  static final bottomNavBarPlayer = BottomNavBarPlayer();

  static Widget playerView() {
    return bottomNavBarPlayer.view();
  }

  static void playAudio(String url) {
    bottomNavBarPlayer.play(
        url,
        sourceType: SourceType.url,
        playerSize: PlayerSize.max,
        mediaType: MediaType.audio
    );
  }

  static void playRawAudio(String path) {
    bottomNavBarPlayer.play(
        path,
        sourceType: SourceType.asset,
        playerSize: PlayerSize.min,
        mediaType: MediaType.audio
    );
  }
}
