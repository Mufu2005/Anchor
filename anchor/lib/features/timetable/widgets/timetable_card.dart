import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

class TimeTableCard extends StatelessWidget {
  final String title;
  final String time;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TimeTableCard({
    super.key,
    required this.title,
    required this.time,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.deepTaupe, // #5C4E4E
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. TITLE (Left)
          Center(
            child: Text(
              title,
              style: GoogleFonts.antonio(
                color: AppTheme.fogWhite,
                fontSize: 24,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // 2. RIGHT SIDE (Time + Icons)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(height: 10),
              // Time
              Text(
                time,
                style: GoogleFonts.robotoMono(
                  color: AppTheme.mutedTaupe,
                  fontSize: 10,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Edit/Delete Icons
              Row(
                children: [
                  _buildIconBtn(Icons.edit_outlined, onEdit),
                  const SizedBox(width: 10),
                  _buildIconBtn(Icons.delete_outline, onDelete),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconBtn(IconData icon, VoidCallback action) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        action();
      },
      child: Icon(icon, color: AppTheme.mutedTaupe, size: 18),
    );
  }
}