
import 'dart:developer';
import 'dart:io';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:dua/pages/web_view_page.dart';
import 'package:dua/providers/app_provider.dart';
import 'package:dua/services/my_dua_service.dart';
import 'package:dua/services/api_service.dart';
import 'package:dua/utils/adhan_alarm.dart';
import 'package:dua/utils/auth.dart';
import 'package:dua/utils/colors.dart';
import 'package:dua/utils/helper.dart';
import 'package:dua/utils/player.dart';
import 'package:dua/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool showErrorMsg = false;
  String? callToAction;
  String? errorMsg;

  final myDua = MyDuaService(ApiService());
  final today = HijriCalendar.now();
  late AppProvider appProvider;

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
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('No Internet Connection'),
                content: const Text(
                    'Please check your internet connection and try again'),
                actions: [
                  TextButton(
                    onPressed: () {
                      exit(0);
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            }
        );
      }
    }, onProxy: (isVPN) {
      if (isVPN) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('VPN Detected'),
                content: const Text(
                    'It seems you are using a VPN. Please disable it because it may cause some issues'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            }
        );
      }
    });

    // Fetch marqueeText when the widget is initialized
    fetchHeadlines();
    fetchEvent();

    checkAndroidScheduleExactAlarmPermission();
    checkNotificationPermission();

    determinePosition((lat, long) async {
      log('Latitude: $lat, Longitude: $long');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setDouble('latitude', lat);
      prefs.setDouble('longitude', long);

      appProvider.setCoordinates(lat, long);
    }, (error) {
      log('Error: $error');
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Location Error'),
              content: const Text(
                  'Please enable location services and try again'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          }
      );
    });

    // initAutoStart();

    getConfig(
      onSuccess: (variables) {
        log('Config variables: $variables');
        for(final variable in variables) {
          switch (variable['name']) {
            case 'IS_APP_ENABLED':
              if (variable['value'] != 'true') {
                exit(0);
              }
              break;
            case 'SHOW_CUSTOM_MESSAGE':
              if (variable['value'] != 'none') {
                setState(() {
                  errorMsg = variable['value'];
                });
              }
              break;
            case 'CALL_TO_ACTION':
              if (variable['value'] != 'none') {
                setState(() {
                  callToAction = variable['value'];
                });
              }
              break;
          }
        }
      },
      onError: (error) {
        log('Error fetching config variables: $error');
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Error'),
                content: const Text(
                    'We are unable to fetch the data. Please try again later'),
                actions: [
                  TextButton(
                    onPressed: () {
                      exit(0);
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    appProvider = Provider.of<AppProvider>(context);

    return SafeArea(
      child: errorMsg == null ? Scaffold(
        appBar: AppBar(
          title: Image.asset(
              'assets/images/logoi.png',
              width: 225
          ),
          actions: [
            if (callToAction != null && errorMsg == null)
              IconButton(
                icon: const Icon(Icons.gpp_good, color: AppColors.whiteColor),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WebViewPage(url: callToAction!))
                  );
                },
              ),
          ],
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
                items: AppStrings.languages,
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
      ) : Scaffold(
        appBar: AppBar(
          title: Image.asset(
              'assets/images/logoi.png',
              width: 225
          ),
          backgroundColor: AppColors.primaryColor,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/warning.png', width: 200),
                    const SizedBox(height: 40),
                    Text(
                      formatHeading(errorMsg!),
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              if (callToAction != null)
                FilledButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => WebViewPage(url: callToAction!)),
                            (route) => false
                    );
                  },
                  child: const Text(
                    'Click here to continue',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      )
    );
  }
}