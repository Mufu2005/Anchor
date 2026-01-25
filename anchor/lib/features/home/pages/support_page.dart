import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _issueController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _issueController.dispose();
    super.dispose();
  }

  void _submitSupport() {
    HapticFeedback.mediumImpact();
    // TODO: Send email or API request
    if (_emailController.text.isNotEmpty && _issueController.text.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Support request sent!")),
      );
      Navigator.pop(context);
    }
  }

  void _requestDeletion() {
    HapticFeedback.heavyImpact();
    // TODO: Handle account deletion request
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Deletion request submitted.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.voidBlack,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 50, // Ensure scrolling fits
            child: Column(
              children: [
                // --- HEADER ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back, color: AppTheme.mutedTaupe, size: 30),
                    ),
                  ),
                ),

                const Spacer(flex: 1),

                // 1. TITLE
                Text(
                  "SUPPORT",
                  style: GoogleFonts.antonio(
                    color: AppTheme.fogWhite,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 1.0,
                  ),
                ),

                const SizedBox(height: 40),

                // 2. INPUT FIELDS
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      // Email Field
                      _buildTextField(_emailController, "Email"),
                      const SizedBox(height: 20),
                      // Issue Field
                      _buildTextField(_issueController, "Issue"),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // 3. BOOKMARK SUBMIT BUTTON
                GestureDetector(
                  onTap: _submitSupport,
                  child: const Icon(
                    Icons.bookmark,
                    color: AppTheme.mutedTaupe,
                    size: 40,
                  ),
                ),

                const Spacer(flex: 2),

                // 4. ACCOUNT DELETION CARD
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.deepTaupe,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Request account deletion",
                        style: GoogleFonts.antonio(
                          color: AppTheme.fogWhite,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 15),
                      GestureDetector(
                        onTap: _requestDeletion,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF8E8E8E), // Lighter Grey/Taupe for button
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "SUBMIT",
                            style: GoogleFonts.antonio(
                              color: AppTheme.voidBlack,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 5. CONTACT INFO CARD
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: AppTheme.deepTaupe,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildContactRow("Email:", "mufumustali@gmail.com"), // Placeholder
                      const SizedBox(height: 10),
                      _buildContactRow("Number:", "03363621590"), // Placeholder
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---

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
          style: GoogleFonts.antonio(color: AppTheme.fogWhite, fontSize: 16),
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

  Widget _buildContactRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.antonio(
            color: AppTheme.fogWhite,
            fontSize: 20, // Larger label size
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.antonio(
              color: AppTheme.mutedTaupe, // Slightly dimmer for value
              fontSize: 16,
              decoration: TextDecoration.underline, // Optional: Makes it look clickable
              decorationColor: AppTheme.mutedTaupe,
            ),
          ),
        ),
      ],
    );
  }
}