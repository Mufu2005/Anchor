import 'package:anchor/core/services/encryption_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/online_db_service.dart';
import '../../../core/theme/app_theme.dart';

class NewHabitPage extends StatefulWidget {
  const NewHabitPage({super.key});

  @override
  State<NewHabitPage> createState() => _NewHabitPageState();
}

class _NewHabitPageState extends State<NewHabitPage> {
  final TextEditingController _nameController = TextEditingController();
  final OnlineDbService _db = OnlineDbService();

  bool _isSaving = false;

  // New State Variables
  bool _isStrict = true;
  double _deadline = 24.0; // Default to midnight

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveHabit() async {
    HapticFeedback.mediumImpact();
    if (_nameController.text.isEmpty) return;

    setState(() => _isSaving = true);

    final String encTittle = EncryptionService().encryptData(_nameController.text);
    // Call the updated create function
    await _db.createHabit(
      title: encTittle,
      isStrict: _isStrict,
      deadline: _deadline.toInt(),
    );

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.voidBlack,
      resizeToAvoidBottomInset:
          false, // Prevents pixel overflow when keyboard opens
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 2),

              // --- TITLE ---
              Center(
                child: Text(
                  "NEW HABIT",
                  style: GoogleFonts.antonio(
                    color: AppTheme.fogWhite,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 1.0,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // --- 1. NAME INPUT ---
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: AppTheme.deepTaupe,
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

              const SizedBox(height: 30),

              // --- 2. STRICT MODE TOGGLE ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "STRICT MODE",
                    style: GoogleFonts.antonio(
                      color: AppTheme.fogWhite,
                      fontSize: 18,
                    ),
                  ),
                  Switch(
                    value: _isStrict,
                    activeColor: AppTheme.fogWhite, // Red
                    inactiveTrackColor: AppTheme.deepTaupe,
                    onChanged: (val) => setState(() => _isStrict = val),
                  ),
                ],
              ),
              Text(
                _isStrict
                    ? "Resets streak if missed."
                    : "Just a counter. No pressure.",
                style: GoogleFonts.beiruti(color: Colors.grey, fontSize: 12),
              ),

              const SizedBox(height: 30),

              // --- 3. DEADLINE SLIDER ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "DEADLINE",
                    style: GoogleFonts.antonio(
                      color: AppTheme.fogWhite,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    "${_deadline.toInt()}:00",
                    style: GoogleFonts.antonio(
                      color: AppTheme.deepTaupe,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: const Color.fromARGB(255, 255, 255, 255),
                  inactiveTrackColor: AppTheme.deepTaupe,
                  thumbColor: AppTheme.fogWhite,
                  overlayColor: AppTheme.deepTaupe.withOpacity(0.2),
                ),
                child: Slider(
                  value: _deadline,
                  min: 1,
                  max: 24,
                  divisions: 23,
                  onChanged: (val) => setState(() => _deadline = val),
                ),
              ),

              const Spacer(flex: 2),

              // --- SAVE BUTTON ---
              Center(
                child: GestureDetector(
                  // Disable tap while saving to prevent double-saves
                  onTap: _isSaving ? null : _saveHabit,
                  child: _isSaving
                      ? const SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(
                            color: Colors.red,
                            strokeWidth: 3,
                          ),
                        )
                      : const Icon(
                          Icons.bookmark,
                          // Make sure AppTheme is imported, or use a specific color like Color(0xFF8E8E93)
                          color: AppTheme.mutedTaupe,
                          size: 40,
                        ),
                ),
              ),

              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }
}
