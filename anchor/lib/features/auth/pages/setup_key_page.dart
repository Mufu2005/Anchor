import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/encryption_service.dart';
import '../../home/pages/home_page.dart';

class SetupKeyPage extends StatefulWidget {
  final bool isFirstTime; 
  const SetupKeyPage({super.key, this.isFirstTime = true});

  @override
  State<SetupKeyPage> createState() => _SetupKeyPageState();
}

class _SetupKeyPageState extends State<SetupKeyPage> {
  final TextEditingController _keyController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _keyController.dispose();
    super.dispose();
  }

  void _submitKey() async {
    final text = _keyController.text;
    
    // Regex: Start to End (^...$) must contain only letters (a-z, A-Z).
    final isAlphabetic = RegExp(r'^[a-zA-Z]+$').hasMatch(text);
    
    if (!isAlphabetic || text.length < 8 || text.length > 12) {
      HapticFeedback.heavyImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Key must be 8-12 letters (A-Z) only. No numbers or symbols.",
            style: GoogleFonts.antonio(color: AppTheme.voidBlack),
          ),
          backgroundColor: AppTheme.fogWhite,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    HapticFeedback.mediumImpact();

    await EncryptionService().setKey(text);

    if (mounted) {
      if (widget.isFirstTime) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text("Key updated successfully", style: GoogleFonts.antonio())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.voidBlack,
      // We remove SingleChildScrollView from here to make the layout fixed
      body: SafeArea(
        child: Column(
          children: [
             // --- HEADER ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  if (!widget.isFirstTime)
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.mutedTaupe, size: 30),
                    )
                  else 
                    const Icon(Icons.keyboard_arrow_down, color: Colors.transparent, size: 30),

                  Expanded(
                    child: Center(
                      child: Text(
                        "ENCRYPTION KEY",
                        style: GoogleFonts.antonio(
                          color: AppTheme.fogWhite,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 30),
                ],
              ),
            ),

            const SizedBox(height: 100),

            // const Spacer(), // Pushes content to middle

            // --- 1. INPUT FIELD ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Container(
                height: 55,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: AppTheme.deepTaupe,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: TextField(
                    controller: _keyController,
                    obscureText: true,
                    style: GoogleFonts.antonio(color: AppTheme.fogWhite, fontSize: 18),
                    cursorColor: AppTheme.fogWhite,
                    decoration: InputDecoration(
                      hintText: "secret key",
                      hintStyle: GoogleFonts.antonio(
                        color: AppTheme.fogWhite.withOpacity(0.5),
                        fontSize: 18,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // --- 2. BOOKMARK SUBMIT BUTTON ---
            GestureDetector(
              onTap: _isLoading ? null : _submitKey,
              child: _isLoading 
              ? const CircularProgressIndicator(color: AppTheme.mutedTaupe)
              : const Icon(
                Icons.bookmark,
                color: AppTheme.mutedTaupe,
                size: 40,
              ),
            ),

            // const Spacer(), // Pushes Warning Card to bottom
            const SizedBox(height: 100),

            // --- 3. WARNING CARD (SCROLLABLE) ---
            // Flexible allows this widget to take remaining space but shrinking if needed
            Flexible(
              child: Container(
                width: double.infinity,
                height: 600,
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: AppTheme.deepTaupe,
                  borderRadius: BorderRadius.circular(20),
                ),
                // This SingleChildScrollView makes ONLY the card content scrollable
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "IRREVERSIBLE ACTION",
                        style: GoogleFonts.antonio(
                          color: const Color(0xFFCD1C18),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "This key secures your data with end-to-end encryption. It ensures your information remains hidden from all third parties, including us.\n\nCaution: If you forget this key, your data will be permanently unrecoverable. We highly recommend creating a manual backup of your data before changing devices or logging out.\n\nThe key could only contain Alphabets form A-Z no special characters or numbers. Max length 12 characters, min of 8 characters is accepted.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.beiruti(
                          color: AppTheme.fogWhite.withOpacity(0.9),
                          fontSize: 16,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}