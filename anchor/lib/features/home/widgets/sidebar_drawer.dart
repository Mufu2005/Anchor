import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for Haptics
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../pages/terms_page.dart';
import '../pages/privacy_page.dart';
import '../pages/support_page.dart';

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
                  _buildMenuItem(context, "Support","contact"),
                  _buildMenuItem(context, "Privacy Policy","privacy"),
                  _buildMenuItem(context, "Terms and Condition","terms"),
                  // const SizedBox(height: 40),
                  _buildMenuItem(context, "Logout","logout"),

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

  Widget _buildMenuItem(BuildContext context, String text, String type) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact(); 

        // 1. Decide where to go (or what to do) logic first
        Widget? pageToOpen;

        switch (type) {
          case "privacy":
            pageToOpen = const PrivacyPage();
            break;
          case "terms":
            pageToOpen = const TermsPage();
            break;
          case "contact":
            pageToOpen = const SupportPage();
            break;
          case "logout":
            // Add your logout logic here
            print("Logout clicked");
            break;
          default:
            break;
        }

        // 2. If a page was chosen, Navigate to it
        if (pageToOpen != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => pageToOpen!),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.antonio(
            color: AppTheme.fogWhite,
            fontSize: 18,
            fontWeight: FontWeight.w300,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}