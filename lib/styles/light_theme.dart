import 'package:flutter/material.dart';

ThemeData lightTheme() {
  return ThemeData(
    snackBarTheme: SnackBarThemeData(
      elevation: 0,
      backgroundColor: const Color.fromRGBO(255, 31, 31, 0.3),
      // Color.fromRGBO(35, 35, 35, 1.0)
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5), // Прямоугольная форма
      ),
      behavior: SnackBarBehavior.floating,
      contentTextStyle: const TextStyle(
        color: Colors.white,
        fontFamily: 'Montserrat',
      ),
    ),

    textSelectionTheme: const TextSelectionThemeData(
        selectionColor: Color.fromRGBO(102, 255, 108, 99),
        selectionHandleColor: Color.fromRGBO(102, 255, 108, 99),
        cursorColor: Color.fromRGBO(197, 62, 110, 1.0)),

    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Color.fromRGBO(197, 62, 110, 1.0),
    ),

    colorScheme: ColorScheme.fromSeed(
        seedColor: const Color.fromRGBO(118, 239, 123, 10),
        primary: Colors.white, /// основной
        onPrimary: Colors.grey, /// на основном
        secondary: const Color.fromRGBO(34, 34, 34, 1), /// второстепенный
        secondaryContainer: const Color.fromRGBO(149, 149, 149, 0.3), /// поля
        secondaryFixed: const Color.fromRGBO(51, 51, 51, 1), /// textfield на странице редактирования профиля
        onSecondary: Colors.white, /// на второстепенном
        tertiary: const Color.fromRGBO(197, 62, 110, 1.0), /// акцентный
        tertiaryContainer: const Color.fromRGBO(249, 196, 214, 1), /// второй акцентный
        scrim: const Color.fromRGBO(0, 204, 8, 1), /// градиент главной кнопки на белом экране
        shadow: const Color.fromRGBO(218, 222, 227, 1), /// тени
        tertiaryFixedDim: const Color.fromRGBO(45, 255, 30, 0.3), /// контейнер успеха
        error: const Color.fromRGBO(208, 61, 61, 1.0),
        errorContainer: const Color.fromRGBO(255, 31, 31, 0.3), /// контейнер ошибки
        onError: Colors.white, /// на ошибке
        surface: const Color.fromRGBO(237, 237, 237, 1), /// карточки
        surfaceBright: const Color.fromRGBO(150, 150, 150, 100), /// контейнер поиска
        surfaceTint: const Color.fromRGBO(150, 150, 150, 1), /// крестик поиска
        surfaceContainerHigh: const Color.fromRGBO(220, 220, 220, 100), /// хайлайт крестика поиска
        surfaceContainer: const Color.fromRGBO(102, 100, 108, 100), /// плюс, foreground кнопок на белом фоне
        surfaceDim: const Color.fromRGBO(170, 170, 170, 1), /// выделение кнопки на белом фоне
        onSurface: const Color.fromRGBO(77, 77, 77, 1)), /// на карточках
  );
}