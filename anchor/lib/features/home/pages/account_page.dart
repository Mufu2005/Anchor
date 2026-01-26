import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/pages/setup_key_page.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  // --- LOGIC: LOG OUT ---
  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.deepTaupe,
        title: Text("LOG OUT?", style: GoogleFonts.antonio(color: AppTheme.fogWhite)),
        content: Text(
          "You will need to re-enter your master key to access your data again.",
          style: GoogleFonts.beiruti(color: AppTheme.fogWhite, fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("CANCEL", style: GoogleFonts.antonio(color: AppTheme.mutedTaupe)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const SetupKeyPage(isFirstTime: true)),
                (Route<dynamic> route) => false,
              );
            },
            child: Text("LOG OUT", style: GoogleFonts.antonio(color: const Color(0xFFCD1C18))),
          ),
        ],
      ),
    );
  }

  // --- LOGIC: CHANGE PASSWORD DIALOG ---
  void _handleChangePassword(BuildContext context) {
    final TextEditingController oldPassController = TextEditingController();
    final TextEditingController newPassController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.deepTaupe,
        title: Text("CHANGE PASSWORD", style: GoogleFonts.antonio(color: AppTheme.fogWhite)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogInput(oldPassController, "Current Password"),
            const SizedBox(height: 15),
            _buildDialogInput(newPassController, "New Password"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("CANCEL", style: GoogleFonts.antonio(color: AppTheme.mutedTaupe)),
          ),
          TextButton(
            onPressed: () {
               HapticFeedback.lightImpact();
               Navigator.pop(context);
               ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(content: Text("Password updated successfully", style: GoogleFonts.antonio())),
               );
            },
            child: Text("UPDATE", style: GoogleFonts.antonio(color: AppTheme.fogWhite)),
          ),
        ],
      ),
    );
  }

  // --- MOCK LOGIC: EXPORT DATA (Animation Only) ---
  Future<void> _handleExport(BuildContext context) async {
    // 1. Show Loading UI
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.voidBlack)),
            const SizedBox(width: 15),
            Text("Compiling encrypted backup...", style: GoogleFonts.antonio(color: AppTheme.voidBlack)),
          ],
        ),
        backgroundColor: AppTheme.fogWhite,
        duration: const Duration(seconds: 2), // Simulate work time
      ),
    );

    // 2. Simulate Delay
    await Future.delayed(const Duration(seconds: 2));

    // 3. Show Success Message
    if (context.mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Backup ready! (Mock)", style: GoogleFonts.antonio(color: AppTheme.fogWhite)),
          backgroundColor: AppTheme.deepTaupe,
        ),
      );
    }
  }

  // --- MOCK LOGIC: IMPORT DATA (Animation Only) ---
  Future<void> _handleImport(BuildContext context) async {
    // 1. Show Loading UI
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.voidBlack)),
            const SizedBox(width: 15),
            Text("Reading file & restoring...", style: GoogleFonts.antonio(color: AppTheme.voidBlack)),
          ],
        ),
        backgroundColor: AppTheme.fogWhite,
        duration: const Duration(seconds: 2),
      ),
    );

    // 2. Simulate Processing Delay
    await Future.delayed(const Duration(seconds: 2));

    // 3. Show Success Dialog
    if (context.mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      _showSuccessDialog(context, "Data restored successfully.");
    }
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.deepTaupe,
        title: Text("SUCCESS", style: GoogleFonts.antonio(color: AppTheme.fogWhite)),
        content: Text(message, style: GoogleFonts.beiruti(color: AppTheme.fogWhite, fontSize: 16)),
        actions: [
          TextButton(
             onPressed: () => Navigator.pop(context),
             child: Text("OK", style: GoogleFonts.antonio(color: AppTheme.fogWhite)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.voidBlack,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                // --- HEADER ---
                // Row(
                //   children: [
                //     IconButton(
                //       onPressed: () {
                //         HapticFeedback.lightImpact();
                //         Navigator.pop(context);
                //       },
                //       icon: const Icon(Icons.arrow_back, color: AppTheme.mutedTaupe, size: 30),
                //     ),
                //     const SizedBox(width: 10),
                //     Text(
                //       "ACCOUNT",
                //       style: GoogleFonts.antonio(
                //         color: AppTheme.fogWhite,
                //         fontSize: 32,
                //         fontWeight: FontWeight.bold,
                //         fontStyle: FontStyle.italic,
                //         letterSpacing: 1.0,
                //       ),
                //     ),
                //   ],
                // ),

                const SizedBox(height: 30),

                // --- 1. PROFILE HEADER (CENTERED) ---
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppTheme.deepTaupe,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppTheme.fogWhite.withOpacity(0.2), width: 1),
                          boxShadow: [
                             BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 15, offset: const Offset(0, 5))
                          ]
                        ),
                        child: Center(
                          child: Text(
                            "JD",
                            style: GoogleFonts.antonio(
                              color: AppTheme.fogWhite,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "John Doe",
                        style: GoogleFonts.antonio(
                          color: AppTheme.fogWhite,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "johndoe@email.com",
                        style: GoogleFonts.beiruti(
                          color: AppTheme.mutedTaupe,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // --- 2. THE STATS GRID ---
                Row(
                  children: [
                    _buildStatTile("TASKS", "124", Icons.check_circle_outline, Colors.blueGrey),
                    const SizedBox(width: 15),
                    _buildStatTile("STREAK", "12", Icons.local_fire_department_outlined, const Color(0xFFCD1C18)),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    _buildStatTile("HABITS", "5", Icons.bolt, Colors.amber.shade700),
                    const SizedBox(width: 15),
                    _buildStatTile("ENTRIES", "42", Icons.auto_stories_outlined, AppTheme.fogWhite),
                  ],
                ),

                const SizedBox(height: 40),

                // --- 3. FUNCTIONAL CONTROL PANEL ---
                
                // SECURITY
                _buildControlWidget(
                  title: "SECURITY",
                  child: Column(
                    children: [
                      // Change Password (Popup)
                      _buildActionButton(
                        context,
                        "Change Password",
                        "Update login credentials",
                        Icons.lock_outline,
                        () => _handleChangePassword(context),
                      ),
                      const SizedBox(height: 10),
                      // Encryption Key Info
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: AppTheme.deepTaupe.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: AppTheme.mutedTaupe.withOpacity(0.1)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.vpn_key_off, color: AppTheme.mutedTaupe, size: 20),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Text(
                                "Master Encryption Key cannot be changed.",
                                style: GoogleFonts.beiruti(color: AppTheme.mutedTaupe, fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // DATA MANAGEMENT
                _buildControlWidget(
                  title: "DATA MANAGEMENT",
                  child: Column(
                    children: [
                      // EXPORT
                      _buildActionButton(
                        context,
                        "Export Data",
                        "Download JSON backup",
                        Icons.download_outlined,
                        () => _handleExport(context),
                      ),
                      
                      const SizedBox(height: 15), 
                      
                      // IMPORT
                      _buildActionButton(
                        context,
                        "Import Data",
                        "Restore from backup file",
                        Icons.upload_file_outlined,
                        () => _handleImport(context),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
                
                // LOG OUT
                GestureDetector(
                  onTap: () {
                     HapticFeedback.heavyImpact();
                     _handleLogout(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFCD1C18).withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      "LOG OUT",
                      style: GoogleFonts.antonio(
                        color: const Color(0xFFCD1C18),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
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

  Widget _buildDialogInput(TextEditingController controller, String hint) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: AppTheme.voidBlack,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        obscureText: true,
        style: GoogleFonts.antonio(color: AppTheme.fogWhite),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.antonio(color: AppTheme.mutedTaupe),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildStatTile(String label, String value, IconData icon, Color accentColor) {
    return Expanded(
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppTheme.deepTaupe.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.mutedTaupe.withOpacity(0.2)),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -10,
              top: -10,
              child: Icon(icon, size: 80, color: accentColor.withOpacity(0.1)),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(icon, color: accentColor.withOpacity(0.8), size: 24),
                const Spacer(),
                Text(
                  value,
                  style: GoogleFonts.antonio(
                    color: AppTheme.fogWhite,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    height: 1.0,
                  ),
                ),
                Text(
                  label,
                  style: GoogleFonts.antonio(
                    color: AppTheme.mutedTaupe,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlWidget({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.antonio(
            color: AppTheme.mutedTaupe,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),
        const SizedBox(height: 10),
        child,
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, String title, String subtitle, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.deepTaupe,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppTheme.mutedTaupe.withOpacity(0.2)),
          boxShadow: [
             BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))
          ]
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.voidBlack,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppTheme.fogWhite, size: 24),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.antonio(
                      color: AppTheme.fogWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.beiruti(
                      color: AppTheme.mutedTaupe,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward, color: AppTheme.mutedTaupe, size: 20),
          ],
        ),
      ),
    );
  }
}