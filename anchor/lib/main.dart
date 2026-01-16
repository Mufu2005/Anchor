import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';

// Update this import to point to your new Landing Page
import 'features/welcome/pages/landing_page.dart'; 

void main() {
  runApp(const ProviderScope(child: AnchorApp()));
}

class AnchorApp extends StatelessWidget {
  const AnchorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Anchor',
      theme: AppTheme.darkTheme,
      home: const LandingPage(), // <--- CHANGED THIS
    );
  }
}