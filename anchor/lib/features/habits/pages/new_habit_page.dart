import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

class NewHabitPage extends StatefulWidget {
  const NewHabitPage({super.key});

  @override
  State<NewHabitPage> createState() => _NewHabitPageState();
}

class _NewHabitPageState extends State<NewHabitPage> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveHabit() {
    HapticFeedback.mediumImpact();
    // TODO: Save logic goes here (e.g., Hive box.add)
    if (_nameController.text.isNotEmpty) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.voidBlack,
      body: SafeArea(
        child: Column(
          children: [
            // Push content to the visual center
            const Spacer(flex: 2),

            // 1. THE TITLE
            Text(
              "NEW HABIT",
              style: GoogleFonts.antonio(
                color: AppTheme.fogWhite,
                fontSize: 32,
                fontWeight: FontWeight.bold, // Italic/Bold style
                fontStyle: FontStyle.italic,
                letterSpacing: 1.0,
              ),
            ),

            const SizedBox(height: 40),

            // 2. INPUT ROW
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                children: [
                  // Text Field Container
                  Expanded(
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: AppTheme.deepTaupe, // #5C4E4E
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: TextField(
                          controller: _nameController,
                          style: GoogleFonts.antonio(
                            color: AppTheme.fogWhite,
                            fontSize: 18,
                          ),
                          cursorColor: AppTheme.fogWhite,
                          decoration: InputDecoration(
                            hintText: "NAME",
                            hintStyle: GoogleFonts.antonio(
                              color: AppTheme.fogWhite.withOpacity(0.5),
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 15),

                  // Save Button (Bookmark Icon)
                  GestureDetector(
                    onTap: _saveHabit,
                    child: const Icon(
                      Icons.bookmark, 
                      color: AppTheme.mutedTaupe, 
                      size: 36,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(flex: 3),

            // 3. RED LINE FOOTER
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFCD1C18), // Red
                borderRadius: BorderRadius.circular(2),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFCD1C18).withOpacity(0.5),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}