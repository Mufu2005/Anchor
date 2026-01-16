import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/pages/login_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Scaffold with the Void Black background
    return Scaffold(
      backgroundColor: AppTheme.voidBlack,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Spacer pushes the Logo to the visual center
              const Spacer(),

              // 2. The "ANCHOR" Logo Text
              Center(
                child: Text(
                  "ANCHOR",
                  style: GoogleFonts.oswald(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.fogWhite,
                    letterSpacing: 2.0, // Adds that cinematic "wide" look
                  ),
                ),
              ),

              const Spacer(),

              // 3. The Action Buttons
              // Login Button (Outlined - Minimalist)
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppTheme.mutedTaupe),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "LOGIN",
                  style: GoogleFonts.robotoMono(
                    color: AppTheme.fogWhite,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Sign Up Button (Filled - Prominent)
              ElevatedButton(
                onPressed: () {
                  // TODO: Navigate to Sign Up Page
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.deepTaupe, // The "Card" color
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0, // Flat design, no shadow
                ),
                child: Text(
                  "GET STARTED",
                  style: GoogleFonts.robotoMono(
                    color: AppTheme.fogWhite,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
