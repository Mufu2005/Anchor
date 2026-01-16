import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/pages/login_page.dart';

class InitializationPage extends StatefulWidget {
  const InitializationPage({super.key});

  @override
  State<InitializationPage> createState() => _InitializationPageState();
}

class _InitializationPageState extends State<InitializationPage> {
  Color _statusColor = const Color(0xFFCD1C18); // Start Red
  
  @override
  void initState() {
    super.initState();
    _initializeSystem();
  }

  Future<void> _initializeSystem() async {
    // 1. Simulate "System Checks"
    await Future.delayed(const Duration(seconds: 3));

    // 2. Status: Green (Access Granted)
    if (mounted) {
      setState(() {
        _statusColor = const Color(0xFF00FF41); // Bright Terminal Green
      });
    }

    // 3. Wait 2 seconds before launching
    await Future.delayed(const Duration(seconds: 2));

    // 4. Navigate
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.voidBlack,
      body: SafeArea(
        child: Column(
          children: [
            // Spacer pushes content to the middle/bottom
            const Spacer(),

            // 1. The CENTERED TEXT
            Center(
              child: Text(
                "ANCHOR",
                style: GoogleFonts.bangers( // <--- NEW FONT (Sci-fi style)
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFD1D0D0),
                  letterSpacing: 4.0, // Wider spacing looks more "cinematic"
                ),
              ),
            ),

            const Spacer(), // Pushes the line to the bottom

            // 2. The BOTTOM LINE
            Padding(
              padding: const EdgeInsets.only(bottom: 60.0), // Space from bottom edge
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: 40,   // <--- LONGER (was 10)
                height: 4,    // Slightly thinner for a sleek look
                decoration: BoxDecoration(
                  color: _statusColor,
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    // The Glow Effect
                    BoxShadow(
                      color: _statusColor.withOpacity(0.8),
                      blurRadius: 10, // How "glowy" it is
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}