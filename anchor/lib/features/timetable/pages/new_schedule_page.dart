import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

class NewSchedulePage extends StatefulWidget {
  const NewSchedulePage({super.key});

  @override
  State<NewSchedulePage> createState() => _NewSchedulePageState();
}

class _NewSchedulePageState extends State<NewSchedulePage> {
  final TextEditingController _nameController = TextEditingController();
  
  // --- STATE ---
  String _frequency = "EVERY WEEK"; 
  String _selectedDay = "Monday";
  TimeOfDay _selectedTime = const TimeOfDay(hour: 8, minute: 0);

  final List<String> _days = [
    "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveSchedule() {
    HapticFeedback.mediumImpact();
    if (_nameController.text.isNotEmpty) {
      // TODO: Save logic
      Navigator.pop(context);
    }
  }

  Future<void> _pickTime() async {
    HapticFeedback.lightImpact();
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
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

    if (time != null && mounted) {
      setState(() {
        _selectedTime = time;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final timeString = '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}';

    return Scaffold(
      backgroundColor: AppTheme.voidBlack,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 50,
            child: Column(
              children: [
                const Spacer(flex: 2),

                // 1. TITLE
                Text(
                  "NEW SCHEDULE",
                  style: GoogleFonts.antonio(
                    color: AppTheme.fogWhite,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 1.0,
                  ),
                ),

                const SizedBox(height: 50),

                // 2. NAME FIELD
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: AppTheme.deepTaupe,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: TextField(
                        controller: _nameController,
                        style: GoogleFonts.antonio(color: AppTheme.fogWhite, fontSize: 18),
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

                const SizedBox(height: 17),

                // 3. DAY & TIME SELECTORS (MOVED UP)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    children: [
                      // --- DAY DROPDOWN ---
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          height: 50, // Matched height with Name field
                          decoration: BoxDecoration(
                            color: AppTheme.deepTaupe,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedDay,
                              dropdownColor: AppTheme.deepTaupe,
                              borderRadius: BorderRadius.circular(12),
                              icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.fogWhite),
                              style: GoogleFonts.antonio(
                                color: AppTheme.fogWhite,
                                fontSize: 18, // Matched font size
                              ),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    _selectedDay = newValue;
                                  });
                                  HapticFeedback.lightImpact();
                                }
                              },
                              items: _days.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 15),

                      // --- TIME PICKER PILL ---
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: _pickTime,
                          child: Container(
                            height: 50, // Matched height
                            decoration: BoxDecoration(
                              color: AppTheme.deepTaupe,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppTheme.mutedTaupe.withOpacity(0.5)),
                            ),
                            child: Center(
                              child: Text(
                                timeString,
                                style: GoogleFonts.antonio(
                                  color: AppTheme.fogWhite,
                                  fontSize: 18, // Matched font size
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // 4. FREQUENCY TOGGLES (MOVED DOWN)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildToggle("EVERY MONTH"),
                      const SizedBox(width: 15),
                      _buildToggle("EVERY WEEK"),
                    ],
                  ),
                ),

                const Spacer(flex: 2),

                // 5. SAVE BUTTON
                GestureDetector(
                  onTap: _saveSchedule,
                  child: const Icon(
                    Icons.bookmark,
                    color: AppTheme.mutedTaupe,
                    size: 40,
                  ),
                ),

                const Spacer(flex: 2),

                // 6. RED LINE FOOTER
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

  Widget _buildToggle(String label) {
    final isSelected = _frequency == label;
    
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() {
          _frequency = label; 
        });
      },
      child: AnimatedContainer( // Added animation for smoother toggle
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.deepTaupe,
          borderRadius: BorderRadius.circular(30), // Rounder pills
          border: Border.all(
            color: isSelected ? AppTheme.fogWhite : Colors.transparent, 
            width: 2
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.antonio(
            color: isSelected ? AppTheme.fogWhite : AppTheme.fogWhite.withOpacity(0.6),
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}