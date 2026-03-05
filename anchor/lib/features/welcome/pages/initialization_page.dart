import 'package:anchor/core/services/session_manager.dart';
import 'package:anchor/features/auth/pages/lock_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; 
import '../../../core/theme/app_theme.dart';
import '../../auth/pages/login_page.dart';

class InitializationPage extends StatefulWidget {
  const InitializationPage({super.key});

  @override
  State<InitializationPage> createState() => _InitializationPageState();
}

class _InitializationPageState extends State<InitializationPage> with SingleTickerProviderStateMixin {
  Color _statusColor = const Color(0xFFCD1C18); // Start Red
  bool _hasError = false; // <--- ADDED: Tracks if we should show the subtle warning
  
  late AnimationController _pulseController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    _opacityAnimation = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _initializeSystem();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _initializeSystem() async {
    try {
      await Supabase.initialize(
        url: 'https://wlypbfnilnuvsxdtwbia.supabase.co',
        anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndseXBiZm5pbG51dnN4ZHR3YmlhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzA4Mjc0MjksImV4cCI6MjA4NjQwMzQyOX0.eMfgMyK2T6UU_AkzGTSnjkl0997GMK7p3ByiMdC-MDM', 
      );

      // THE TEST PING
      await Supabase.instance.client
          .from('shared_entries')
          .select('id') // Replace 'id' with your actual column name if different
          .limit(1);

      if (mounted) {
        setState(() {
          _statusColor = const Color(0xFF00FF41); 
          _hasError = false; // Ensure error text is hidden
        });
        _pulseController.stop();
        _pulseController.value = 1.0; 
      }

      await Future.delayed(const Duration(seconds: 1));
      
      await SessionManager().setSessionForLoggedInUser();
      
      if (!mounted) return;

      if(SessionManager().isLoggedIn == true){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LockScreen()),
        );
      }
      else{
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    } catch (e) {
      print("CONNECTION FAILED: $e");
      
      // TRIGGER THE SUBTLE ERROR UI
      if (mounted) {
        setState(() {
          _statusColor = const Color(0xFFCD1C18); 
          _hasError = true; // <--- Show the minimal text
        });
        _pulseController.duration = const Duration(milliseconds: 500); // Fast pulse
        _pulseController.repeat(reverse: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.voidBlack,
      body: SafeArea(
        child: Column(
          children: [
            // --- TOP STATUS BAR ---
            Padding(
              padding: const EdgeInsets.only(top: 20.0), 
              child: AnimatedBuilder(
                animation: _opacityAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _opacityAnimation.value,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 40,   
                      height: 4,    
                      decoration: BoxDecoration(
                        color: _statusColor,
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: [
                          BoxShadow(
                            color: _statusColor.withOpacity(0.8),
                            blurRadius: 10, 
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  );
                }
              ),
            ),

            const Spacer(),

            // --- CENTERED TEXT ---
            Center(
              child: Text(
                "ANCHOR",
                style: GoogleFonts.bangers( 
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFD1D0D0),
                  letterSpacing: 4.0, 
                ),
              ),
            ),

            const Spacer(), 

            // --- SUBTLE ERROR TEXT (Only shows if _hasError is true) ---
            SizedBox(
              height: 40, // Keeps the layout stable whether text is there or not
              child: _hasError 
                  ? Text(
                      "SYSTEM OFFLINE",
                      style: GoogleFonts.robotoMono(
                        color: _statusColor.withOpacity(0.6), // Muted red
                        fontSize: 10,
                        letterSpacing: 3.0,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            
            const SizedBox(height: 20), // Bottom padding
          ],
        ),
      ),
    );
  }
}