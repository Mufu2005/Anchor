import 'package:anchor/features/testing/test_db_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme/app_theme.dart';
import 'features/home/pages/home_page.dart';

// Update this import to point to your new Landing Page
import 'features/welcome/pages/landing_page.dart'; 

void main() async {

  await Supabase.initialize(
    url: 'https://wlypbfnilnuvsxdtwbia.supabase.co', 
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndseXBiZm5pbG51dnN4ZHR3YmlhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzA4Mjc0MjksImV4cCI6MjA4NjQwMzQyOX0.eMfgMyK2T6UU_AkzGTSnjkl0997GMK7p3ByiMdC-MDM', 
  );

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
      // const TestDbPage(),
    );
  }
}