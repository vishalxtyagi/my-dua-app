import 'package:dua/utils/colors.dart';
import 'package:dua/utils/player.dart';
import 'package:flutter/material.dart';

class AudioCard extends StatelessWidget {
  final String title;
  final String duration;
  final String audioUrl;
  final bool isFavorite;
  final Function()? onFavoritePressed;

  AudioCard({
    required this.title,
    required this.duration,
    required this.audioUrl,
    this.isFavorite = false,
    this.onFavoritePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 15.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(
          color: AppColors.blackColor,
        ),
      ),
      child: ListTile(
        tileColor: AppColors.whiteColor,
        contentPadding: const EdgeInsets.fromLTRB(15, 5, 15, 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: BorderSide(color: AppColors.blackColor),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 22.5,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              duration,
              style: TextStyle(
                fontSize: 19.5,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onFavoritePressed != null)
              IconButton(
                icon: Image.asset(
                  isFavorite ? 'assets/images/fav_heart.png' : 'assets/images/unfav_heart.png',
                  width: 35.0,
                ),
                onPressed: () {
                  // Add to favorites
                  onFavoritePressed!();
                },
              ),
            SizedBox(width: 10),
            IconButton(
              icon: Image.asset(
                'assets/images/play.png',
                width: 35.0,
              ),
              onPressed: () {
                AppPlayer.playAudio(audioUrl);
                // AppPlayer.playRawAudio('assets/audios/azzan.mp3');
              },
            ),
          ],
        ),
      ),
    );
  }
}
