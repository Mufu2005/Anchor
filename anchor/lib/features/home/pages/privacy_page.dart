import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.voidBlack,
      body: SafeArea(
        child: Column(
          children: [
            // --- HEADER ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Stack(
                // <--- Use Stack instead of Row
                alignment: Alignment
                    .centerLeft, // Default alignment for children (like the back button)
                children: [
                  // 1. BACK BUTTON (Aligned Left by default)
                  IconButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: AppTheme.mutedTaupe,
                      size: 30,
                    ),
                  ),

                  // 2. TEXT (Centered perfectly)
                  Center(
                    // <--- This now centers relative to the whole width
                    child: Text(
                      "PRIVACY POLICY",
                      style: GoogleFonts.antonio(
                        color: AppTheme.fogWhite,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // --- SCROLL WINDOW ---
            Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: AppTheme.deepTaupe,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Scrollbar(
                  thumbVisibility: true,
                  radius: const Radius.circular(10),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle("1. Data Collection"),
                        _buildParagraph(
                          "Anchor prioritizes your privacy. We do not collect, transmit, or sell your personal data. All information you input into the app (including journal entries, tasks, and schedules) is stored locally on your device's internal memory.",
                        ),

                        _buildSectionTitle("2. Biometric Data"),
                        _buildParagraph(
                          "If you use the 'Lock Screen' feature, the app utilizes your device's native biometric authentication (FaceID, TouchID) or passcode systems. Anchor does not store or have access to your raw biometric data. The authentication process is handled entirely by the operating system, which simply reports a 'Success' or 'Failure' status to the app.",
                        ),

                        _buildSectionTitle("3. Third-Party Services"),
                        _buildParagraph(
                          "The app does not use third-party services that may collect information used to identify you, with the exception of standard operating system services required for the app to function (e.g., Local Authentication, Notifications).",
                        ),

                        _buildSectionTitle("4. Data Security"),
                        _buildParagraph(
                          "Since your data is stored locally, the security of your data relies on the security of your device. We recommend keeping your device software updated and using the in-app security lock for sensitive journal entries.",
                        ),

                        _buildSectionTitle("5. Children’s Privacy"),
                        _buildParagraph(
                          "We do not knowingly collect personally identifiable information from children under 13. In the case we discover that a child under 13 has provided us with personal information, we immediately delete this from our servers (if applicable).",
                        ),

                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Text(
        text,
        style: GoogleFonts.antonio(
          color: AppTheme.fogWhite,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Text(
      text,
      style: GoogleFonts.beiruti(
        color: AppTheme.fogWhite.withOpacity(0.8),
        fontSize: 16,
        height: 1.5,
      ),
    );
  }
}
