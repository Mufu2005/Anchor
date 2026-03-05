import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/theme/app_theme.dart';

class JournalTicketView extends StatelessWidget {
  final String id;
  final String title;
  final String date;
  final String entryId;
  final String shareKey;

  const JournalTicketView({
    super.key,
    required this.id,
    required this.title,
    required this.date,
    required this.entryId,
    required this.shareKey,
  });

  @override
  Widget build(BuildContext context) {
    // 1. DATA PACKING
    // We combine the ID and the Key into the QR code.
    // Format: entryId|shareKey
    final String combinedData = "$id|$entryId|$shareKey";

    return Scaffold(
      backgroundColor: AppTheme.voidBlack,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppTheme.mutedTaupe),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),

            // --- THE TICKET CARD ---
            Center(
              child: Container(
                width: 340,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 30,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.deepTaupe,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppTheme.fogWhite.withOpacity(0.1)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // TOP DECORATIVE ELEMENT (Keeps the ticket vibe)
                    const SizedBox(height: 15),

                    // TITLE
                    Text(
                      title.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.antonio(
                        color: AppTheme.fogWhite,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // DATE
                    Text(
                      date,
                      style: GoogleFonts.robotoMono(
                        color: AppTheme.fogWhite.withOpacity(0.6),
                        fontSize: 11,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // --- THE QR CODE (The Core Data) ---
                    Container(
                      padding: const EdgeInsets.all(
                        20,
                      ), // Slightly more padding for the glow
                      decoration: BoxDecoration(
                        color: AppTheme.fogWhite.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(
                          24,
                        ), // Softer corners
                        border: Border.all(
                          color: AppTheme.fogWhite.withOpacity(0.1),
                        ),
                        // Optional: Add a subtle glow behind the QR code
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.fogWhite.withOpacity(0.05),
                            blurRadius: 20,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // USE A STACK TO LAYER THE LOGO ON TOP
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              // 1. THE QR CODE (Background Layer)
                              QrImageView(
                                data: combinedData,
                                version: QrVersions.auto,
                                size: 160.0,

                                // CRITICAL: High error correction allows the code to work
                                // even though we are covering the middle.
                                errorCorrectionLevel: QrErrorCorrectLevel.H,

                                // ❌ REMOVED 'embeddedImage' property from here
                                dataModuleStyle: QrDataModuleStyle(
                                  dataModuleShape: QrDataModuleShape.circle,
                                  color: AppTheme.fogWhite.withOpacity(0.9),
                                ),

                                eyeStyle: const QrEyeStyle(
                                  eyeShape: QrEyeShape.circle,
                                  color: AppTheme.fogWhite,
                                ),
                                padding: const EdgeInsets.all(0),
                              ),

                              // 2. THE LOGO WITH "CUTOUT" BACKGROUND (Top Layer)
                              Container(
                                width:
                                    45, // Approx 20-25% of QR size (160 * 0.22 = ~35)
                                height: 45,
                                padding: const EdgeInsets.all(
                                  3,
                                ), // Space between logo and the "cutout" edge
                                decoration: BoxDecoration(
                                  // ⚠️ IMPORTANT: Change this color to match the CARD background
                                  // behind this QR code. (e.g., Colors.black, or Color(0xFF1E1E1E))
                                  color: AppTheme.deepTaupe,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Image.asset(
                                  'assets/images/logo.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // INSTRUCTION TEXT
                          Text(
                            "SCAN TO SYNCHRONIZE",
                            style: GoogleFonts.robotoMono(
                              color: AppTheme.fogWhite.withOpacity(0.4),
                              fontSize: 10,
                              letterSpacing: 2,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // VISUAL ID DISPLAY (Safe Substring Fix)
                    Text(
                      entryId.length >= 13
                          ? entryId.substring(0, 13).toUpperCase()
                          : entryId.toUpperCase(),
                      style: GoogleFonts.oswald(
                        color: AppTheme.fogWhite,
                        fontSize: 22,
                        letterSpacing: 3.0,
                      ),
                    ),

                    const SizedBox(height: 20),
                    const Divider(color: Colors.white10),
                    const SizedBox(height: 15),

                    // SECURITY FOOTER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.lock_outline,
                          color: Color.fromARGB(255, 0, 0, 0),
                          size: 14,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "TEMPORARY SHARED VAULT ACCESS",
                          style: GoogleFonts.robotoMono(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // ACTION BUTTON
            _buildFooterAction(
              icon: Icons.ios_share_rounded,
              label: "SEND ACCESS TICKET",
              onTap: () {
                HapticFeedback.heavyImpact();
                // Logic for saving as image
              },
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: AppTheme.fogWhite, size: 32),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.antonio(
              color: AppTheme.fogWhite,
              fontSize: 12,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
