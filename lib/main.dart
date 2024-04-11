import 'package:dua/pages/home_page.dart';
import 'package:dua/providers/app_provider.dart';
import 'package:dua/providers/audio_provider.dart';
import 'package:dua/providers/auth_provider.dart';
import 'package:dua/utils/colors.dart';
import 'package:dua/utils/strings.dart';
import 'package:dua/utils/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Wakelock.enable();

  AuthProvider authProvider = AuthProvider();
  await authProvider.checkAuthenticationStatus();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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