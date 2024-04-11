import 'dart:developer';

import 'package:dua/pages/audio_list_page.dart';
import 'package:dua/pages/auth/login_page.dart';
import 'package:dua/pages/favourite_page.dart';
import 'package:dua/pages/profile_page.dart';
import 'package:dua/pages/web_view_page.dart';
import 'package:dua/providers/audio_provider.dart';
import 'package:dua/providers/auth_provider.dart';
import 'package:dua/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MoreData {
  final String title;
  final String? image;
  final Widget? page;

  MoreData(this.title, {this.image, this.page});
}

class ShowMorePage extends StatefulWidget {
  final String? type;

  const ShowMorePage({super.key, this.type});

  @override
  _ShowMorePageState createState() => _ShowMorePageState();
}

class _ShowMorePageState extends State<ShowMorePage> {
  List<MoreData> listData = [];

  late AudioProvider audioProvider;
  late AuthProvider authProvider;

  void addMorePageData({bool isAuthenticated = false}) {
    // Add your data to the list
    setState(() {
      listData.clear();
      listData.addAll([
        MoreData("Surah", image: "assets/images/quran.png", page: const AudioListPage(type: "surah")),
        MoreData("Sahifa Sajjadia", image: "assets/images/islam.png", page: const AudioListPage(type: "sahifaSajjadia",)),
        MoreData("Aamaal and Namaz", image: "assets/images/namaz.png", page: const WebViewPage(url: "https://mydua.online/aamaal-and-namaz/")),
        MoreData("My Favourites", image: "assets/images/favourite.png", page: isAuthenticated ? FavouritePage() : LoginPage(redirectTo: FavouritePage())),
        MoreData("Quotes", image: "assets/images/quote_request.png", page: const WebViewPage(url: "https://mydua.online/quotes/")),
        MoreData("Hijri Date Adjustment", image: "assets/images/clock.png"),
        MoreData("Azan Settings Notification", image: "assets/images/ajan.jpeg"),
        MoreData("Our Radio", image: "assets/images/radio.png", page: const WebViewPage(url: "https://azadar.media/")),
        MoreData("Waqf", image: "assets/images/arabic.png", page: const WebViewPage(url: "https://mydua.online/apppage-for-waqf/")),
        MoreData("Feedback", image: "assets/images/rating.png", page: const WebViewPage(url: "https://mydua.online/feedback/")),
        MoreData("Our Supporter", image: "assets/images/call.png", page: const WebViewPage(url: "https://mydua.online/our-supporter/")),
      ]);

      if (isAuthenticated) {
        listData.add(MoreData("My Profile", image: "assets/images/profile_user.png", page: const ShowMorePage(type: 'profile')));
      } else {
        listData.add(MoreData("Login", image: "assets/images/profile_user.png", page: const LoginPage()));
      }
    });
  }

  void addProfileData() {
    // Add your data to the list
    setState(() {
      listData.clear();
      listData.addAll([
        MoreData("My Profile", page: ProfilePage()),
        MoreData("Change Password", page: const AudioListPage(type: "sahifaSajjadia",)),
        MoreData("Logout"),
      ]);
    });
  }

  void loadMenuData(bool isAuthenticated) {
    if (widget.type == 'profile' && isAuthenticated) {
      addProfileData();
    } else {
      addMorePageData(isAuthenticated: isAuthenticated);
    }
  }

  void onItemClick(int position) {
    switch (listData[position].title) {
      case "Logout":
        authProvider.logout();
        audioProvider.clearAll();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => listData[position].page ?? const LoginPage(),
          ),
        );
        break;
      default:
        log('Clicked on: ${listData[position].title}');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => listData[position].page ?? const WebViewPage(url: 'https://mydua.online'),
          ),
        );
        break;
    }
  }

  Widget buildMenuList() {
    return ListView.builder(
      itemCount: listData.length,
      padding: const EdgeInsets.all(10),
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.only(bottom: 15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: BorderSide(
              color: AppColors.blackColor,
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            tileColor: Colors.white,
            title: Text(listData[index].title, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
            leading: listData[index].image != null ? Image.asset(
              listData[index].image!,
              width: 25.0,
              height: 25.0,
            ) : null,
            trailing: Image.asset(
              'assets/images/right_arrow.png', // Assuming you have this image
              width: 20.0,
              height: 20.0,
            ),
            onTap: () {
              onItemClick(index);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    audioProvider = Provider.of<AudioProvider>(context);
    authProvider = Provider.of<AuthProvider>(context);

    loadMenuData(authProvider.userId != null);

    return widget.type == null ? buildMenuList() : Scaffold(
      appBar: AppBar(
        title: Image.asset(
            'assets/images/logoi.png',
            width: 225
        ),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
      ),
      body: buildMenuList(),
    );
  }

}