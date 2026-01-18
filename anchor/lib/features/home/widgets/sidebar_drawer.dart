import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for Haptics
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

class SidebarDrawer extends StatelessWidget {
  const SidebarDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Drawer(
      width: screenWidth,
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Row(
        children: [
          // 1. LEFT PANEL
          Expanded(
            flex: 7,
            child: Container(
              color: AppTheme.deepTaupe,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.person, color: AppTheme.fogWhite, size: 28),
                      IconButton(
                        onPressed: () {
                          HapticFeedback.lightImpact(); // <--- VIBRATION ADDED
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.fogWhite, size: 24),
                      ),
                    ],
                  ),

                  const Spacer(flex: 2),

                  // MENU ITEMS (Lighter Fonts)
                  _buildMenuItem("Contact us"),
                  _buildMenuItem("Privacy Policy"),
                  _buildMenuItem("Terms and Condition"),
                  // const SizedBox(height: 40),
                  _buildMenuItem("Logout"),

                  const Spacer(flex: 3),

                  // USER NAME (Lighter Weight)
                  Text(
                    "MUFADDAL",
                    style: GoogleFonts.bangers(
                      color: AppTheme.fogWhite,
                      fontSize: 32,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. RIGHT STRIP
          Expanded(
            flex: 3,
            child: Container(
              color: AppTheme.voidBlack,
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Spacer(),
                  
                  RotatedBox(
                    quarterTurns: 3,
                    child: Text(
                      "ANCHOR",
                      style: GoogleFonts.bangers(
                        color: AppTheme.fogWhite,
                        fontSize: 56,                        
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                  
                  const Spacer(),

                  Text(
                    "Ver 1.00",
                    style: GoogleFonts.robotoMono(
                      color: AppTheme.fogWhite,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String text) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact(); // <--- VIBRATION ADDED
        // TODO: Handle Navigation
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.antonio(
            color: AppTheme.fogWhite,
            fontSize: 18,
            fontWeight: FontWeight.w300, // <--- VERY LIGHT WEIGHT
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}