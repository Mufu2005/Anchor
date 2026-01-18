import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

class JournalEditorPage extends StatefulWidget {
  // Optional: Pass these if editing an existing entry
  final String? initialTitle;
  final String? initialContent;

  const JournalEditorPage({super.key, this.initialTitle, this.initialContent});

  @override
  State<JournalEditorPage> createState() => _JournalEditorPageState();
}

class _JournalEditorPageState extends State<JournalEditorPage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _contentController = TextEditingController(text: widget.initialContent);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.voidBlack,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              // 1. HEADER (Back Arrow + Save/Bookmark)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.mutedTaupe, size: 30),
                  ),
                  IconButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      // TODO: Save Logic
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.bookmark, color: AppTheme.mutedTaupe, size: 28),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 2. TITLE CONTAINER
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(
                  color: AppTheme.deepTaupe, // #5C4E4E
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: _titleController,
                  style: GoogleFonts.antonio(
                    color: AppTheme.fogWhite,
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    hintText: "Title",
                    hintStyle: GoogleFonts.antonio(
                      color: AppTheme.fogWhite.withOpacity(0.5),
                      fontSize: 24,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // 3. MAIN CONTENT CONTAINER (Expands to fill space)
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.deepTaupe, // #5C4E4E
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    controller: _contentController,
                    expands: true, // Allows text to fill the box vertically
                    maxLines: null, // Unlimited lines
                    textAlignVertical: TextAlignVertical.top, // Starts at top
                    style: GoogleFonts.beiruti(
                      color: AppTheme.fogWhite,
                      fontSize: 16,
                      height: 1.5,
                    ),
                    decoration: InputDecoration(
                      hintText: "Write something here !",
                      hintStyle: GoogleFonts.beiruti(
                        color: AppTheme.mutedTaupe,
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 4. THE RED LINE FOOTER
              Container(
                width: 50,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFCD1C18), // "Chili Spice" Red
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFCD1C18).withOpacity(0.5),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}