import 'package:flutter/material.dart';
import 'features/loading/loading_screen.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'portfolio.sh',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF1d2021),
        scrollbarTheme: ScrollbarThemeData(
          thumbColor: WidgetStateProperty.all(const Color(0xFF3c3836)),
          trackColor: WidgetStateProperty.all(const Color(0xFF1d2021)),
          thickness: WidgetStateProperty.all(4),
          radius: const Radius.circular(2),
        ),
      ),
      home: const LoadingScreen(),
    );
  }
}
