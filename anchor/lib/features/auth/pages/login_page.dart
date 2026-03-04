import 'package:anchor/features/auth/pages/setup_key_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// === App imports ===
import '../../../core/theme/app_theme.dart';
import '../../../core/services/encryption_service.dart';
import '../../../core/services/online_db_service.dart';
import '../../../core/services/session_manager.dart';
import '../../home/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // 1. CONTROLLERS
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController =
      TextEditingController(); // <--- FOR THE ENCRYPTION KEY
  final TextEditingController _keyController =
      TextEditingController(); // <--- FOR THE ENCRYPTION KEY

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _keyController.dispose();
    super.dispose();
  }

  // --- 2. LOGIN & DECRYPTION LOGIC ---
  void _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final encryptionKey = _keyController.text.trim();

    if (email.isEmpty || password.isEmpty || encryptionKey.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email, Password, and Secret Key are required."),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    HapticFeedback.mediumImpact();

    try {
      // A. AUTHENTICATE WITH SUPABASE
      final profileData = await OnlineDbService().getUserByHashEmail(email);
      final profile = profileData.first;

      if (profileData.isEmpty) throw "No user found.";

      // B. INITIALIZE ENCRYPTION SERVICE
      // We use the key provided in the UI to unlock the "vault"
      await EncryptionService().setKey(encryptionKey);

      final String decryptedEmail = EncryptionService().decryptData(
        profile.email,
      );
      final String decryptedPassword = EncryptionService().decryptData(
        profile.password,
      );

      if (decryptedEmail != email || decryptedPassword != password)
        throw "Invalid credentials.";

      // C. FETCH ENCRYPTED PROFILE

      if (profile.id.isNotEmpty) {
        // D. DECRYPT DATA ON-THE-FLY
        final String decryptedName = EncryptionService().decryptData(
          profile.name,
        );
        final String decryptedNick = EncryptionService().decryptData(
          profile.nickname,
        );

        // E. START THE SESSION
        SessionManager().setSessionForNewLoggedInUser(
          encryptionKey,
          decryptedName,
          decryptedNick,
          profile.id,
          true,
        );

        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
            (route) => false,
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString().split('\n')[0]}")),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.voidBlack,
      resizeToAvoidBottomInset: false, // Prevents keyboard layout issues
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
                  "Login",
                  style: GoogleFonts.antonio(
                    color: AppTheme.fogWhite,
                    fontSize: 40,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ),

              const SizedBox(height: 35),

              // --- INPUT FIELDS ---
              _buildFigmaTextField(
                hint: "Email",
                obscure: false,
                controller: _emailController,
              ),
              const SizedBox(height: 20),

              _buildFigmaTextField(
                hint: "Password",
                obscure: true,
                controller: _passwordController,
              ),
              const SizedBox(height: 20),

              // NEW ENCRYPTION KEY FIELD
              _buildFigmaTextField(
                hint: "Secret Key",
                obscure: true,
                controller: _keyController,
              ),

              const SizedBox(height: 30),

              // --- ACTION BUTTON ---
              Center(
                child: GestureDetector(
                  onTap: _isLoading ? null : _handleLogin,
                  child: Container(
                    width: 80,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.mutedTaupe,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.black,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.black,
                              size: 20,
                            ),
                    ),
                  ),
                ),
              ),

              const Spacer(flex: 3),

              // --- FOOTER (SIGNUP) ---
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SetupKeyPage(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF5C4E4E),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      "Signup",
                      style: GoogleFonts.antonio(
                        color: AppTheme.fogWhite,
                        fontSize: 16,
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

  // --- REUSABLE TEXT FIELD WIDGET ---
  Widget _buildFigmaTextField({
    required String hint,
    required bool obscure,
    required TextEditingController controller,
    double width = 300,
  }) {
    return Center(
      child: Container(
        width: width,
        height: 45,
        decoration: const BoxDecoration(
          color: AppTheme.deepTaupe,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 25),
        alignment: Alignment.centerLeft,
        child: TextField(
          controller: controller,
          obscureText: obscure,
          cursorColor: AppTheme.fogWhite,
          style: GoogleFonts.beiruti(
            textStyle: const TextStyle(color: AppTheme.fogWhite, fontSize: 16),
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
