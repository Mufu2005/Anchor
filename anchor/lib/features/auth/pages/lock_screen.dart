import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import '../../../core/theme/app_theme.dart';
import '../../home/pages/home_page.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _isUnlocked = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _authenticate() async {
    HapticFeedback.mediumImpact();

    try {
      final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
      final bool canAuthenticate = canAuthenticateWithBiometrics || await auth.isDeviceSupported();

      if (!canAuthenticate) {
        _navigateToHome();
        return;
      }

      final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Please authenticate to access Anchor',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );

      if (didAuthenticate) {
        setState(() {
          _isUnlocked = true;
        });

        await Future.delayed(const Duration(seconds: 1));
        
        _navigateToHome();
      }
    } catch (e) {
      debugPrint("Auth Error: $e");
    }
  }

  void _navigateToHome() {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.voidBlack,
      body: SafeArea(
        child: Column(
          children: [
            // --- 1. THE BAR (CORRECTED) ---
            Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 50,
                height: 4,
                margin: const EdgeInsets.only(top: 20),
                
                // PROPERTIES MOVED INSIDE DECORATION
                decoration: BoxDecoration(
                  color: _isUnlocked ? const Color(0xFF00FF41) : const Color(0xFFCD1C18),
                  borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                  topRight: Radius.circular(4),
                  topLeft: Radius.circular(4),
                ),
                  boxShadow: _isUnlocked
                      ? [
                          BoxShadow(
                            color: const Color(0xFF00FF41).withOpacity(0.5),
                            blurRadius: 10,
                            spreadRadius: 2,
                          )
                        ]
                      : [],
                ),
              ),
            ),

            const Spacer(),

            // --- 2. LOCK ICON & BUTTON ---
            GestureDetector(
              onTap: _authenticate,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                              "assets/icons/lock.png", // Ensure you have this small icon
                              width: 70,
                              height: 70,
                              color: AppTheme.fogWhite,
                            ),
                  
                  const SizedBox(height: 10),

                  Text(
                    _isUnlocked ? "GRANTED" : "UNLOCK",
                    style: GoogleFonts.antonio(
                      color: AppTheme.fogWhite,
                      fontSize: 20,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}