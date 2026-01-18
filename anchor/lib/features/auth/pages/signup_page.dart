import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.voidBlack,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),

              // 1. HEADER
              Center(
                child: Text(
                  "Signup",
                  style: GoogleFonts.antonio(
                    color: AppTheme.fogWhite,
                    fontSize: 40,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),

              const SizedBox(height: 35),

              // 2. INPUT FIELDS (Email, Name, Password)
              _buildFigmaTextField(hint: "Email", obscure: false),
              const SizedBox(height: 20),
              _buildFigmaTextField(hint: "Name", obscure: false),
              const SizedBox(height: 20),
              _buildFigmaTextField(hint: "Password", obscure: true),

              const SizedBox(height: 20),

              // 3. THE ARROW BUTTON
              Center(
                child: GestureDetector(
                  onTap: () {
                    // TODO: Handle Signup Logic
                  },
                  child: Container(
                    width: 80,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.mutedTaupe,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ),
              ),

              const Spacer(flex: 3),

              // 4. LOGIN FOOTER BUTTON (Takes you back)
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Go back to Login
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF5C4E4E),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      "Login",
                      style: GoogleFonts.antonio(
                        color: AppTheme.fogWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Reusing the same text field logic
  Widget _buildFigmaTextField({
    required String hint,
    required bool obscure,
    double width = 300, // <--- CONTROL THE LENGTH HERE (Default is 300px)
  }) {
    return Center(
      // This prevents the box from stretching to the screen edges
      child: Container(
        width: width, // Applies your custom length
        height: 45,
        decoration: BoxDecoration(
          color: AppTheme.deepTaupe,
          borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 25),
        alignment: Alignment.centerLeft,
        child: TextField(
          obscureText: obscure,

          // --- YOUR CUSTOM FONT SETTINGS ---
          style: GoogleFonts.beiruti(
            textStyle: TextStyle( // <--- PUT YOUR FONT NAME HERE
              color: AppTheme.fogWhite,
              fontSize: 16,
            ),
          ),

          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.beiruti(
              textStyle: TextStyle(
                color: AppTheme.fogWhite.withOpacity(0.6),
                fontSize: 17,
              ),
            ),
            border: InputBorder.none,
            isDense: true,
          ),
        ),
      ),
    );
  }
}