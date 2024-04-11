import 'package:flutter/material.dart';

import 'colors.dart';

class AppThemes {
    static ThemeData lightTheme = ThemeData(
        useMaterial3: true,
        colorSchemeSeed: AppColors.primaryColor,
        buttonTheme: ButtonThemeData(
            minWidth: double.infinity,
        ),
        filledButtonTheme: FilledButtonThemeData(
            style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)),
                shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                )),
            ),
        ),
    );

    static ThemeData darkTheme = ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColors.primaryColor,
    );
}