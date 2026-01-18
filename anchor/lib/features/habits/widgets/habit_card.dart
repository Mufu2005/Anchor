import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

class HabitCard extends StatelessWidget {
  final String title;
  final int streak;
  final Color statusColor;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const HabitCard({
    super.key,
    required this.title,
    required this.streak,
    required this.statusColor,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.deepTaupe, // #5C4E4E
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          children: [
            // 1. TOP COLOR LINE INDICATOR
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.only(top: 5),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(4),
                    bottomRight: Radius.circular(4),
                    topRight: Radius.circular(4),
                    topLeft: Radius.circular(4),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: statusColor.withOpacity(0.6),
                      blurRadius: 6,
                    )
                  ],
                ),
              ),
            ),

            // 2. TITLE (Top Left)
            Positioned(
              top: 20,
              left: 20,
              right: 80, // Added right padding so it doesn't hit the streak number
              child: Text(
                title,
                style: GoogleFonts.antonio(
                  color: AppTheme.fogWhite,
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // 3. STREAK COUNTER (Vertically Centered, Right 10px)
            Align(
              alignment: Alignment(1,-0.3), // <--- Vertically Centers it
              child: Padding(
                padding: const EdgeInsets.only(right: 10), // <--- 10px from Right
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "$streak",
                      style: GoogleFonts.antonio(
                        color: AppTheme.fogWhite.withOpacity(0.9),
                        fontSize: 26,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.local_fire_department,
                      color: AppTheme.fogWhite.withOpacity(0.7),
                      size: 30,
                    ),
                  ],
                ),
              ),
            ),

            // 4. EDIT / DELETE ICONS (Bottom 10px)
            Positioned(
              bottom: 4,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildIconBtn(Icons.edit_outlined, onEdit),
                  const SizedBox(width: 13),
                  _buildIconBtn(Icons.delete_outline, onDelete),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconBtn(IconData icon, VoidCallback action) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        action();
      },
      child: Icon(icon, color: AppTheme.mutedTaupe, size: 20),
    );
  }
}