import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

// 1. Change to StatefulWidget
class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // 2. Create Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    // Always dispose controllers to free memory
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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

              // HEADER
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

              // 3. Pass controllers to your custom builder
              _buildFigmaTextField(
                hint: "Email", 
                obscure: false, 
                controller: _emailController // <--- CONNECTED
              ),
              const SizedBox(height: 20),
              
              _buildFigmaTextField(
                hint: "Name", 
                obscure: false, 
                controller: _nameController // <--- CONNECTED
              ),
              const SizedBox(height: 20),
              
              _buildFigmaTextField(
                hint: "Password", 
                obscure: true, 
                controller: _passwordController // <--- CONNECTED
              ),

              const SizedBox(height: 20),

              // THE ARROW BUTTON
              Center(
                child: GestureDetector(
                  onTap: () {
                    // 4. FETCH THE STRINGS HERE
                    String email = _emailController.text;
                    String name = _nameController.text;
                    String password = _passwordController.text;

                    print("User Signed Up: $name, $email, $password");
                    
                    // Add your signup logic here
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

              // LOGIN FOOTER
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
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

  // UPDATED WIDGET BUILDER
  Widget _buildFigmaTextField({
    required String hint,
    required bool obscure,
    required TextEditingController controller, // <--- Add this argument
    double width = 300,
  }) {
    return Center(
      child: Container(
        width: width,
        height: 45,
        decoration: const BoxDecoration( // Removed AppTheme reference for simplicity in snippet
          color: AppTheme.deepTaupe,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 25),
        alignment: Alignment.centerLeft,
        child: TextField(
          controller: controller, // <--- Assign controller here
          obscureText: obscure,
          style: GoogleFonts.beiruti(
            textStyle: const TextStyle(
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