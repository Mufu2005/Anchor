import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String description;
  final String date;
  final Color priorityColor;
  final bool isCompleted;
  final VoidCallback onCheck;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.title,
    required this.description,
    required this.date,
    required this.priorityColor,
    required this.isCompleted,
    required this.onCheck,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: AppTheme.deepTaupe, // #5C4E4E
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          // 1. TOP COLOR INDICATOR
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.only(top: 5),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: priorityColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                  topRight: Radius.circular(4),
                  topLeft: Radius.circular(4),

                ),
                boxShadow: [
                  BoxShadow(
                    color: priorityColor.withOpacity(0.6),
                    blurRadius: 6,
                  )
                ],
              ),
            ),
          ),

          // 2. MAIN CONTENT ROW
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
            child: Row(
              children: [
                // --- LEFT SIDE: TEXT INFO ---
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        title,
                        style: GoogleFonts.antonio(
                          color: AppTheme.fogWhite,
                          fontSize: 22,
                          fontWeight: FontWeight.w400,
                          decoration: isCompleted ? TextDecoration.lineThrough : null,
                          decorationColor: const Color.fromARGB(255, 255, 255, 255),
                          decorationThickness: 3,
                        ),
                      ),
                      
                      const SizedBox(height: 4),
                      
                      // Description
                      if (description.isNotEmpty)
                        Text(
                          "Description: $description",
                          style: GoogleFonts.beiruti(
                            color: AppTheme.mutedTaupe,
                            fontSize: 10,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                      const SizedBox(height: 15),

                      // Footer Row: Icons (Left) + Date (Right)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Edit/Delete Icons
                          Row(
                            children: [
                              _buildActionIcon(Icons.edit_outlined, onEdit),
                              const SizedBox(width: 10),
                              _buildActionIcon(Icons.delete_outline, onDelete),
                            ],
                          ),

                          SizedBox(width: 73),
                          
                          // Date
                          Text(
                            date,
                            style: GoogleFonts.bangers(
                              color: AppTheme.fogWhite,
                              fontSize: 10,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                //const SizedBox(width: 15),

                // --- RIGHT SIDE: CHECKBOX ---
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onCheck();
                  },
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted ? AppTheme.fogWhite : Colors.transparent,
                      border: Border.all(
                        color: isCompleted ? AppTheme.fogWhite : AppTheme.mutedTaupe,
                        width: 2,
                      ),
                    ),
                    child: isCompleted
                        ? const Icon(Icons.check, color: AppTheme.voidBlack, size: 24)
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Icon(icon, color: AppTheme.mutedTaupe, size: 18),
    );
  }
}