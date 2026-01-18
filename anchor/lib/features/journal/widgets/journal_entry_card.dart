import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For Haptics
import 'package:google_fonts/google_fonts.dart';
import 'package:barcode_widget/barcode_widget.dart'; // <--- REQUIRED IMPORT
import '../../../core/theme/app_theme.dart';
import '../pages/journal_ticket_view.dart';

class JournalEntryCard extends StatefulWidget {
  final String title;
  final String content;
  final String date;
  final bool isExpanded;
  final VoidCallback? onEdit;

  const JournalEntryCard({
    super.key,
    required this.title,
    required this.content,
    required this.date,
    this.isExpanded = false,
    this.onEdit,
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
            // --- HEADER ROW (Title + Barcode) ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: GoogleFonts.antonio(
                      color: AppTheme.fogWhite,
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // --- BARCODE SECTION (UPDATED) ---
                if (_isExpanded)
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      // Navigate to the Ticket View
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JournalTicketView(
                            title: widget.title,
                            date: widget.date,
                            // In a real app, pass the actual ID from your database
                            entryId: "ANCH-8821", 
                          ),
                        ),
                      );
                    },
                    child: BarcodeWidget(
                      barcode: Barcode.code128(),
                      data: 'ANCH-8821', 
                      color: AppTheme.mutedTaupe, 
                      width: 80,
                      height: 30,
                      drawText: false,
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 10),

            // --- EXPANDED CONTENT ---
            if (_isExpanded) ...[
              Text(
                widget.content,
                style: GoogleFonts.beiruti(
                  color: AppTheme.mutedTaupe,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              
              // --- FOOTER (Date + Edit/Delete Icons) ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.date,
                    style: GoogleFonts.bangers(
                      color: AppTheme.fogWhite,
                      fontSize: 12,
                      letterSpacing: 1.0,
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          if (widget.onEdit != null) {
                            widget.onEdit!(); 
                          }
                        },
                        child: const Icon(Icons.edit_outlined, color: AppTheme.mutedTaupe, size: 25),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.delete_outline, color: AppTheme.mutedTaupe, size: 25),
                    ],
                  ),
                ],
              ),
            ] else ...[
              // Collapsed state (empty)
            ],
          ],
        ),
      ),
    );
  }
}