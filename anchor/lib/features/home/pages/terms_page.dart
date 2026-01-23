import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

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
                alignment: Alignment.center, // Centers everything by default
                children: [
                  // 1. Back Button (Aligned to the Left)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
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
                  ),

                  // 2. The Text (Truly Centered)
                  Text(
                    "TERMS & CONDITIONS",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.antonio(
                      color: AppTheme.fogWhite,
                      fontSize: 32, // Adjusted size to fit if needed
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      letterSpacing: 1.0,
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
                  color: AppTheme.deepTaupe, // #5C4E4E
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Scrollbar(
                  thumbVisibility: true,
                  radius: const Radius.circular(10),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle("1. Introduction"),
                        _buildParagraph(
                          "Welcome to Anchor. By downloading or using the app, these terms will automatically apply to you – you should make sure therefore that you read them carefully before using the app.",
                        ),

                        _buildSectionTitle("2. Intellectual Property"),
                        _buildParagraph(
                          "You are not allowed to copy or modify the app, any part of the app, or our trademarks in any way. The app itself, and all the trade marks, copyright, database rights and other intellectual property rights related to it, still belong to the developer.",
                        ),

                        _buildSectionTitle("3. User Data & Local Storage"),
                        _buildParagraph(
                          "Anchor is designed as a local-first application. All data entered into the app (journals, tasks, habits) is stored locally on your device. We do not transmit your personal content to external servers unless you explicitly enable a cloud backup feature (if available). You are responsible for keeping your phone and access to the app secure.",
                        ),

                        _buildSectionTitle("4. Updates & Changes"),
                        _buildParagraph(
                          "We are committed to ensuring that the app is as useful and efficient as possible. For that reason, we reserve the right to make changes to the app or to charge for its services, at any time and for any reason. We will never charge you for the app or its services without making it very clear to you exactly what you’re paying for.",
                        ),

                        _buildSectionTitle("5. Limitation of Liability"),
                        _buildParagraph(
                          "The app is provided 'as is'. We accept no liability for any loss, direct or indirect, you experience as a result of relying wholly on this functionality of the app.",
                        ),

                        const SizedBox(height: 50), // Bottom padding
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
