import 'package:expense_tracker/models/color_schemes.dart';
import 'package:expense_tracker/widgets/home.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: darkColorScheme,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            side: BorderSide(color: darkColorScheme.tertiary),
            backgroundColor: darkColorScheme.onTertiary.withOpacity(0.25),
          ),
        ),
      ),
      theme: ThemeData().copyWith(
        colorScheme: lightColorScheme,
        cardTheme: const CardTheme().copyWith(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          margin: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10,
          ),
        ),
      ),
      title: "Expenses tracker",
      home: const Home(),
    ),
  );
}
