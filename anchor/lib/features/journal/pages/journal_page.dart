import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../widgets/journal_entry_card.dart';

class JournalPage extends StatelessWidget {
  const JournalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.voidBlack,
      body: SafeArea(
        child: Column(
          children: [
            // --- 1. HEADER ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back / Collapse Arrow
                  IconButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.mutedTaupe, size: 30),
                  ),

                  // Title "JOURNAL"
                  Text(
                    "JOURNAL",
                    style: GoogleFonts.bangers(
                      color: AppTheme.fogWhite,
                      fontSize: 32,
                      letterSpacing: 1.0,
                    ),
                  ),

                  // Actions (Barcode Scan + Add)
                  Row(
                    children: [
                      // The Barcode Scan Icon
                      IconButton(
                        onPressed: () => HapticFeedback.lightImpact(),
                        icon: const Icon(Icons.qr_code_scanner, color: AppTheme.mutedTaupe, size: 24),
                      ),
                      // const SizedBox(width: 8),
                      // Add Button
                      IconButton(
                        onPressed: () => HapticFeedback.lightImpact(),
                        icon: const Icon(Icons.add, color: AppTheme.mutedTaupe, size: 30),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // --- 2. LIST OF ENTRIES ---
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: const [
                  // Item 1 (Expanded by default for demo)
                  JournalEntryCard(
                    title: "Dinner with her",
                    isExpanded: true,
                    date: "08:00 21 JAN 2025",
                    content: "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters...",
                  ),
                  
                  // Item 2 (Collapsed)
                  JournalEntryCard(
                    title: "Project Ideas",
                    isExpanded: false,
                    date: "14:00 20 JAN 2025",
                    content: "Drafting the new UI for the Anchor app. Need to focus on the offline-first architecture...",
                  ),

                  // Item 3 (Collapsed)
                  JournalEntryCard(
                    title: "Morning Routine",
                    isExpanded: false,
                    date: "06:30 20 JAN 2025",
                    content: "Woke up early. Gym session was good. Need to buy more coffee beans.",
                  ),
                ],
              ),
            ),

            // --- 3. BOTTOM DROPDOWN (Priority Filter) ---
            Padding(
              padding: const EdgeInsets.only(bottom: 20, top: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                width: 200, // Fixed width for the pill shape
                decoration: BoxDecoration(
                  color: AppTheme.deepTaupe, // #5C4E4E
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "High",
                      style: GoogleFonts.oswald(
                        color: AppTheme.fogWhite,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.keyboard_arrow_down, color: AppTheme.mutedTaupe),
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