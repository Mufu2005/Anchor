import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../home/pages/home_page.dart'; // Import the Home Page
import 'package:flutter/services.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  // Logic to track entered pins (for UI dots only right now)
  List<String> currentPin = [];

  void _onKeyPressed(String value) {
    if (value == "0") {
      // --- TEMPORARY LOGIC: "0" UNLOCKS APP ---
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
      return;
    }

    // Visual updates only for other keys
    setState(() {
      if (currentPin.length < 4) {
        currentPin.add(value);
      }
    });
  }

  void _onBackspace() {
    if (currentPin.isNotEmpty) {
      setState(() {
        currentPin.removeLast();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.voidBlack,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 5),

            // 1. THE PIN DOTS
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                // If index is less than currentPin length, it's filled
                bool isFilled = index < currentPin.length;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isFilled ? AppTheme.fogWhite : AppTheme.deepTaupe,
                  ),
                );
              }),
            ),

            const Spacer(flex: 3),

            // 2. THE KEYPAD
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                children: [
                  _buildRow(['1', '2', '3']),
                  const SizedBox(height: 30),
                  _buildRow(['4', '5', '6']),
                  const SizedBox(height: 30),
                  _buildRow(['7', '8', '9']),
                  const SizedBox(height: 30),
                  
                  // Bottom Row: Biometric - 0 - Backspace
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Biometric Icon (Face ID)
                      IconButton(
                        onPressed: () { 
                            // TODO: Implement Biometric Auth 
                        },
                        icon: Image.asset(
                          'assets/icons/face-id.png',
                          width: 50,
                          height: 50,
                          fit: BoxFit.contain,
                        ),
                        
                        
                      ),

                      // The "0" Key
                      _buildNumberButton('0'),

                      // Backspace Icon
                      IconButton(
                        onPressed: _onBackspace,
                        icon: Image.asset(
                          'assets/icons/backspace.png',
                          width: 50,
                          height: 50,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(flex: 3),
          ],
        ),
      ),
    );
  }

  // Helper to build a row of 3 numbers
  Widget _buildRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: keys.map((key) => _buildNumberButton(key)).toList(),
    );
  }

  // Helper to build a single Number Button
  Widget _buildNumberButton(String number) {
    return GestureDetector(
      onTap: () { 
        HapticFeedback.lightImpact();
        _onKeyPressed(number);
      },
      child: Container(
        width: 60, 
        height: 60,
        alignment: Alignment.center,
        color: Colors.transparent, // Ensures the whole area is tappable
        child: Text(
          number,
          style: GoogleFonts.antonio( // Matches the tall font in your screenshot
            fontSize: 36,
            fontWeight: FontWeight.w400,
            color: AppTheme.fogWhite,
          ),
        ),
      ),
    );
  }
}