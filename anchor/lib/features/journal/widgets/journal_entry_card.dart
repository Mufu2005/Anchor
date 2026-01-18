import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For Haptics
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

class JournalEntryCard extends StatefulWidget {
  final String title;
  final String content;
  final String date;
  final bool isExpanded;

  const JournalEntryCard({
    super.key,
    required this.title,
    required this.content,
    required this.date,
    this.isExpanded = false,
  });

  @override
  State<JournalEntryCard> createState() => _JournalEntryCardState();
}

class _JournalEntryCardState extends State<JournalEntryCard> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.deepTaupe, // #5C4E4E
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // --- HEADER ROW (Title + Barcode Icon) ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: GoogleFonts.oswald(
                      color: AppTheme.fogWhite,
                      fontSize: 24,
                      fontWeight: FontWeight.w400, // Lighter weight as requested
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (_isExpanded)
                  // The "Fake" Barcode in the corner
                  Icon(Icons.qr_code_2, color: AppTheme.mutedTaupe, size: 40),
              ],
            ),

            const SizedBox(height: 10),

            // --- EXPANDED CONTENT ---
            if (_isExpanded) ...[
              Text(
                widget.content,
                style: GoogleFonts.robotoMono(
                  color: AppTheme.mutedTaupe,
                  fontSize: 14,
                  height: 1.5, // Better readability
                ),
              ),
              const SizedBox(height: 20),
              
              // --- FOOTER (Date + Edit/Delete Icons) ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.date, // e.g. "08:00 21 JAN 2025"
                    style: GoogleFonts.oswald(
                      color: AppTheme.fogWhite,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.edit_outlined, color: AppTheme.mutedTaupe, size: 20),
                      const SizedBox(width: 10),
                      Icon(Icons.delete_outline, color: AppTheme.mutedTaupe, size: 20),
                    ],
                  ),
                ],
              ),
            ] else ...[
              // --- COLLAPSED HINT ---
              // Optional: Show nothing, or a tiny snippet
            ],
          ],
        ),
      ),
    );
  }
}