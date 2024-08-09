import 'package:artists_eye/src/challenges/routes/challenges_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
      title: "Artist's Eye",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: GoogleFonts.crimsonProTextTheme(),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple[200],
          ),
        ),
        appBarTheme: AppBarTheme(
          titleTextStyle: GoogleFonts.alata(textStyle: textTheme.displayMedium),
        ),
      ),
      home: const ChallengesList(),
    );
  }
}
