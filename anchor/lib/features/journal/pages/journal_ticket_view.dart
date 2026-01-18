import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:barcode_widget/barcode_widget.dart';
import '../../../core/theme/app_theme.dart';

class JournalTicketView extends StatelessWidget {
  final String title;
  final String date;
  final String entryId; // e.g., "ABDS116445-A"

  const JournalTicketView({
    super.key,
    required this.title,
    required this.date,
    required this.entryId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.voidBlack,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),

            // --- THE TICKET CARD ---
            Center(
              child: Container(
                width: 350, // Fixed width like a phone screen/ticket
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                decoration: BoxDecoration(
                  color: AppTheme.deepTaupe, // #5C4E4E
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. TOP SECTION (Title + Date)
                    const Divider(color: Colors.white30, height: 1),
                    const SizedBox(height: 15),
                    Text(
                      title,
                      style: GoogleFonts.antonio(
                        color: AppTheme.fogWhite,
                        fontSize: 28,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Divider(color: Colors.white30, height: 1),
                    const SizedBox(height: 10),
                    Text(
                      date, // e.g. "08:00 21 Jan 2025"
                      style: GoogleFonts.robotoMono(
                        color: AppTheme.fogWhite.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Divider(color: Colors.white30, height: 1),

                    const SizedBox(height: 20),

                    // 2. BARCODE SECTION
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // The Barcode
                        BarcodeWidget(
                          barcode: Barcode.code128(),
                          data: entryId,
                          color: AppTheme.fogWhite.withOpacity(0.6),
                          width: 200,
                          height: 50,
                          drawText: false,
                        ),
                        // The Vertical "ANCHOR" Label
                        RotatedBox(
                          quarterTurns: 3,
                          child: Text(
                            "ANCHOR",
                            style: GoogleFonts.bangers(
                              color: AppTheme.fogWhite,
                              fontSize: 12,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Divider(color: Colors.white30, height: 1),

                    const SizedBox(height: 40),

                    // 3. SCANNER GRAPHIC (Brackets + Anchor)
                    Center(
                      child: SizedBox(
                        width: 120,
                        height: 120,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // The Brackets (using a large icon)
                           Image.asset(
                              "assets/icons/scanning.png", // Ensure you have this small icon
                              width: 200,
                              height: 200,
                              color: AppTheme.fogWhite,
                            ),
                            // The Anchor in the center
                            Image.asset(
                              "assets/images/logo.png", // Ensure you have this small icon
                              width: 50,
                              height: 50,
                              color: AppTheme.fogWhite,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // 4. ID CODE + ARROW
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Down Arrow (Expand?)
                        //const Icon(Icons.keyboard_arrow_down, color: AppTheme.mutedTaupe, size: 50),

                        //const SizedBox(width: 40),
                        
                        // The Big ID Code
                        Text(
                          entryId,
                          style: GoogleFonts.oswald(
                            color: AppTheme.fogWhite,
                            fontSize: 28,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 1.0,
                          ),
                        ),
                        
                        //const SizedBox(width: 30), // Spacer to balance the row
                      ],
                    ),

                    const SizedBox(height: 30),

                    // 5. RED WARNING
                    Center(
                      child: Text(
                        "Scan with caution",
                        style: GoogleFonts.robotoMono(
                          color: const Color(0xFFCD1C18), // Red
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // --- FOOTER: DOWNLOAD ICON ---
            IconButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                // TODO: Download Image Logic
              },
              icon: const Icon(Icons.download_outlined, color: AppTheme.fogWhite, size: 30),
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}