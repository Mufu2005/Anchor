import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// --- APP IMPORTS ---
import '../../../core/services/flutter_storage_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/encryption_service.dart';
import '../../../core/services/online_db_service.dart';
import '../../../core/services/session_manager.dart';
import '../../home/pages/home_page.dart';

class SignupPage extends StatefulWidget {
  // We accept the key passed from the previous "Setup Key" page
  final String rawEncryptionKey; 

  const SignupPage({
    super.key, 
    required this.rawEncryptionKey
  });

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // 1. CONTROLLERS
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController(); // <--- Added for new logic
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _nicknameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // --- 2. FUNCTIONALITY (THE NEW LOGIC) ---
  void _handleSignup() async {
    final email = _emailController.text.trim();
    final name = _nameController.text.trim();
    final nickname = _nicknameController.text.trim();
    final password = _passwordController.text.trim();
    final encryptionKey = widget.rawEncryptionKey;
    if (email.isEmpty || name.isEmpty || nickname.isEmpty || password.isEmpty || encryptionKey.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // A. Supabase Auth (Sign Up)
      // final authRes = await Supabase.instance.client.auth.signUp(
      //   email: email,
      //   password: password,
      // );

      // if (authRes.user == null) throw "Signup Failed";

      // B. Encrypt Data (Using the key passed from previous screen)
      // Note: EncryptionService key should already be set, but we set it again to be safe
      await EncryptionService().setKey(widget.rawEncryptionKey);

      final encEmail = EncryptionService().encryptData(email);
      final encName = EncryptionService().encryptData(name);
      final encNick = EncryptionService().encryptData(nickname);
      final encPassword = EncryptionService().encryptData(password);
      final encKey = EncryptionService().encryptData(encryptionKey);

      // C. Save Profile to DB
      String newUserId = await OnlineDbService().createProfile(
        email: encEmail,
        name: encName,
        nickname: encNick,
        password: encPassword,
        encryption_key: encKey,
      );

      // D. Save Session Info to Storage
     final storage = FlutterStorageService(); 
      
      // 2. Feed the data into THAT specific instance
      storage.getSessionInfoFromUser(encryptionKey, name, nickname, newUserId, true);
      
      // 3. Tell THAT specific instance to write to the hard drive
      await storage.setUserInfoToStorage();

      // E. Start Session (Make sure to await this too!)
      await SessionManager().setSession();

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false,
        );
      }

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.voidBlack, // Your original background
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),

              // --- HEADER ---
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

              // --- INPUT FIELDS (Your Custom Style) ---
              
              // 1. Email
              _buildFigmaTextField(
                hint: "Email", 
                obscure: false, 
                controller: _emailController
              ),
              const SizedBox(height: 20),
              
              // 2. Name
              _buildFigmaTextField(
                hint: "Name", 
                obscure: false, 
                controller: _nameController
              ),
              const SizedBox(height: 20),

              // 3. Nickname (Added to fit logic)
              _buildFigmaTextField(
                hint: "Nickname", 
                obscure: false, 
                controller: _nicknameController
              ),
              const SizedBox(height: 20),
              
              // 4. Password
              _buildFigmaTextField(
                hint: "Password", 
                obscure: true, 
                controller: _passwordController
              ),

              const SizedBox(height: 20),

              // --- THE ARROW BUTTON (With Logic Attached) ---
              Center(
                child: GestureDetector(
                  onTap: _isLoading ? null : _handleSignup, // <--- Logic Connected
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
                          width: 20, height: 20, 
                          child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2)
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

              // --- LOGIN FOOTER ---
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

  // --- YOUR ORIGINAL CUSTOM TEXT FIELD ---
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
          style: GoogleFonts.beiruti(
            textStyle: const TextStyle(
              color: AppTheme.fogWhite,
              fontSize: 16,
            ),
          ),
          cursorColor: AppTheme.fogWhite,
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