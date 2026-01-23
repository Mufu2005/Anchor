import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';

class NewTaskPage extends StatefulWidget {
  const NewTaskPage({super.key});

  @override
  State<NewTaskPage> createState() => _NewTaskPageState();
}

class _NewTaskPageState extends State<NewTaskPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  
  // State for selections
  String _selectedPriority = "High"; // High (Red), Medium (Yellow), Low (Green)
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _saveTask() {
    HapticFeedback.mediumImpact();
    // TODO: Save logic goes here
    if (_titleController.text.isNotEmpty) {
      Navigator.pop(context);
    }
  }

  // Helper to pick date/time
  Future<void> _pickDateTime() async {
    HapticFeedback.lightImpact();
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppTheme.mutedTaupe,
              onPrimary: AppTheme.voidBlack,
              surface: AppTheme.deepTaupe,
              onSurface: AppTheme.fogWhite,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDate),
      );
      
      if (time != null) {
        setState(() {
          _selectedDate = DateTime(
            date.year, date.month, date.day, time.hour, time.minute
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.voidBlack,
      body: SafeArea(
        child: SingleChildScrollView( // Prevents overflow when keyboard opens
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 50, // Full height minus safe area
            child: Column(
              children: [
                const Spacer(flex: 2),

                // 1. TITLE
                Text(
                  "NEW TASK",
                  style: GoogleFonts.antonio(
                    color: AppTheme.fogWhite,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 1.0,
                  ),
                ),

                const SizedBox(height: 50),

                // 2. INPUT FIELDS
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      // Name Field
                      _buildTextField(_titleController, "NAME"),
                      
                      const SizedBox(height: 20),
                      
                      // Description Field
                      _buildTextField(_descController, "Description"),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // 3. PRIORITY & DATE ROW
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Priority Dots (Red, Yellow, Green)
                      Row(
                        children: [
                          _buildPriorityDot("High", const Color(0xFFCD1C18)),
                          const SizedBox(width: 15),
                          _buildPriorityDot("Medium", Colors.amber),
                          const SizedBox(width: 15),
                          _buildPriorityDot("Low", const Color(0xFF00FF41)),
                        ],
                      ),

                      // Date Pill
                      GestureDetector(
                        onTap: _pickDateTime,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppTheme.deepTaupe,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            DateFormat('HH:mm dd MMM yyyy').format(_selectedDate).toUpperCase(),
                            style: GoogleFonts.antonio(
                              color: AppTheme.fogWhite,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(flex: 2),

                // 4. SAVE BUTTON (Centered Bookmark)
                GestureDetector(
                  onTap: _saveTask,
                  child: const Icon(
                    Icons.bookmark,
                    color: AppTheme.mutedTaupe,
                    size: 40,
                  ),
                ),

                const Spacer(flex: 2),

                // 5. RED LINE FOOTER
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCD1C18),
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
        ),
      ),
    );
  }

  // Helper Widget for Text Inputs
  Widget _buildTextField(TextEditingController controller, String hint) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppTheme.deepTaupe,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          style: GoogleFonts.antonio(color: AppTheme.fogWhite, fontSize: 18),
          cursorColor: AppTheme.fogWhite,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.antonio(
              color: AppTheme.fogWhite.withOpacity(0.5),
              fontSize: 14,
            ),
            border: InputBorder.none,
            isDense: true,
          ),
        ),
      ),
    );
  }

  // Helper Widget for Priority Dots
  Widget _buildPriorityDot(String priority, Color color) {
    final isSelected = _selectedPriority == priority;
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() {
          _selectedPriority = priority;
        });
      },
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: AppTheme.fogWhite, width: 2) : null,
          boxShadow: isSelected
              ? [BoxShadow(color: color.withOpacity(0.6), blurRadius: 8)]
              : [],
        ),
      ),
    );
  }
}