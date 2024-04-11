
import 'dart:developer';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:dua/providers/app_provider.dart';
import 'package:dua/services/my_dua_service.dart';
import 'package:dua/services/api_service.dart';
import 'package:dua/utils/colors.dart';
import 'package:dua/utils/helper.dart';
import 'package:dua/utils/player.dart';
import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

import 'daily_dua_page.dart';
import 'dua_page.dart';
import 'event_page.dart';
import 'ziyarat_page.dart';
import 'show_more_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final myDua = MyDuaService(ApiService());
  final today = HijriCalendar.now();
  late AppProvider appProvider;

  final List<String> _languages = ['عربي', 'हिंदी', 'English', 'ગુજરાતી'];

  final List<Widget> _pages = [
    DailyDuaPage(),
    DuaPage(),
    EventPage(),
    ZiyaratPage(),
    ShowMorePage(),
  ];

  void fetchHeadlines() {
    myDua.getHeadLines().then((value) {
      final titles = value.message.animatedText;
      final formattedTitles = titles!.map((title) => formatHeading(title.heading));
      log('Headlines: ${formattedTitles}');
      appProvider.setHeadline(formattedTitles.join(' '));
    });
  }

  void fetchEvent() {
    myDua.getEvent().then((value) {
      final event = value.event;
      log('Event: $event');
      appProvider.setHeadline(event!);
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    checkInternetConnectivity((isConnected) {
      if (!isConnected) {
        QuickAlert.show(
          context: context,
          title: 'No Internet Connection',
          text: 'Please connect to the internet to use the app',
          type: QuickAlertType.error,
          disableBackBtn: true,
        );
      }
    }, onProxy: (isVPN) {
      if (isVPN) {
        QuickAlert.show(
          context: context,
          title: 'VPN Detected',
          text: 'Please disable VPN to use the app',
          type: QuickAlertType.warning,
        );
      }
    });

    // Fetch marqueeText when the widget is initialized
    fetchHeadlines();
    fetchEvent();

    determinePosition((lat, long) {
      log('Latitude: $lat, Longitude: $long');
      appProvider.setCoordinates(lat, long);
    }, (error) {
      log('Error: $error');
      QuickAlert.show(
        context: context,
        title: 'Location Error',
        text: error,
        type: QuickAlertType.error,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    appProvider = Provider.of<AppProvider>(context);
    // HijriCalendar.setLocal('ar');

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
            SizedBox(height: 8),
            Expanded(
              child: _pages[_selectedIndex],
            ),
            if (_selectedIndex != 4)
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
            if (_selectedIndex != 4)
              AppPlayer.playerView(),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          backgroundColor: AppColors.primaryColor,
          destinations: <NavigationDestination>[
            NavigationDestination(
              icon: Image.asset('assets/images/hand.png', width: 25.0, height: 25.0),
              label: 'Daily Dua',
            ),
            NavigationDestination(
              icon: Image.asset('assets/images/dua.png', width: 25.0, height: 25.0),
              label: 'Dua',
            ),
            NavigationDestination(
              icon: Image.asset('assets/images/event_img.png', width: 25.0, height: 25.0),
              label: 'Event',
            ),
            NavigationDestination(
              icon: Image.asset('assets/images/mosque.png', width: 25.0, height: 25.0),
              label: 'Ziyarat',
            ),
            NavigationDestination(
              icon: Image.asset('assets/images/more.png', width: 25.0, height: 25.0),
              label: 'More',
            ),
          ],
          selectedIndex: _selectedIndex,
          surfaceTintColor: AppColors.whiteColor,
          onDestinationSelected: _onItemTapped,
        ),
      ),
    );
  }
}