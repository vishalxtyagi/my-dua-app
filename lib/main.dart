import 'package:alarm/alarm.dart';
import 'package:dua/pages/home_page.dart';
import 'package:dua/providers/app_provider.dart';
import 'package:dua/providers/audio_provider.dart';
import 'package:dua/providers/auth_provider.dart';
import 'package:dua/utils/adhan_alarm.dart';
import 'package:dua/utils/colors.dart';
import 'package:dua/utils/strings.dart';
import 'package:dua/utils/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Wakelock.enable();

  await Alarm.init(showDebugLogs: true);
  Alarm.ringStream.stream.listen((_) => updateAdhanAlarm());

  AuthProvider authProvider = AuthProvider();
  await authProvider.checkAuthenticationStatus();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Enable Crashlytics and analytics only in production
  if (kReleaseMode) {
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  // Initialize the FlutterLocalNotificationsPlugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // Initialize the Android-specific settings
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  // Create the initialization settings
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  // Initialize the plugin
  flutterLocalNotificationsPlugin.initialize(initializationSettings);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: AppColors.primaryColor
  ));
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  ).then(
        (_) => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AppProvider()),
          ChangeNotifierProvider(create: (context) => AudioProvider()),
          ChangeNotifierProvider.value(value: authProvider),
        ],
        child: const MyDua(),
      ),
    ),
  );
}

class MyDua extends StatelessWidget {
  const MyDua({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      theme: AppThemes.lightTheme,
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}