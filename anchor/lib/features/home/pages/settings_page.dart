import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/pages/setup_key_page.dart'; // Import for navigation
import 'account_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // State
  bool _zenMode = false;
  bool _biometricLock = true;
  bool _notifications = true;
  double _hapticIntensity = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.voidBlack,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- HEADER ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                         HapticFeedback.lightImpact();
                         Navigator.pop(context);
                      },
                      icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.mutedTaupe, size: 30),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "SETTINGS",
                      style: GoogleFonts.antonio(
                        color: AppTheme.fogWhite,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // --- 1. GENERAL ---
              _buildSectionHeader("GENERAL"),
              _buildSettingsTile(
                context,
                "Account & Data",
                Icons.person_outline,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AccountPage()),
                  );
                },
              ),
              _buildSwitchTile(
                "Notifications", 
                "Daily briefings & reminders", 
                _notifications, 
                (val) => setState(() => _notifications = val)
              ),

              const SizedBox(height: 30),

              // --- 2. SECURITY (Restored Encryption Key) ---
              _buildSectionHeader("SECURITY"),
              
              // *** THE MISSING ENCRYPTION KEY BUTTON ***
              _buildSettingsTile(
                context,
                "Encryption Key",
                Icons.vpn_key, // Key Icon
                onTap: () {
                  // Navigate to Key Page (View/Update Mode)
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SetupKeyPage(isFirstTime: false)),
                  );
                },
              ),
              
              _buildSwitchTile(
                "Biometric Lock", 
                "Require FaceID on entry", 
                _biometricLock, 
                (val) => setState(() => _biometricLock = val)
              ),

              const SizedBox(height: 30),

              // --- 3. IMMERSION ---
              _buildSectionHeader("IMMERSION"),
              _buildSwitchTile(
                "Zen Mode", 
                "Hide interface when scrolling", 
                _zenMode, 
                (val) => setState(() => _zenMode = val)
              ),
              
              // Haptic Slider
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "HAPTIC FEEDBACK",
                      style: GoogleFonts.antonio(color: AppTheme.fogWhite, fontSize: 18),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.vibration, color: AppTheme.mutedTaupe, size: 20),
                        Expanded(
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: const Color.fromARGB(255, 255, 255, 255),
                              inactiveTrackColor: AppTheme.deepTaupe,
                              thumbColor: AppTheme.fogWhite,
                              overlayColor: AppTheme.deepTaupe.withOpacity(0.2),
                            ),
                            child: Slider(
                              value: _hapticIntensity,
                              onChanged: (val) {
                                setState(() => _hapticIntensity = val);
                                if (val > 0) HapticFeedback.selectionClick();
                              },
                              divisions: 2, 
                              label: _hapticIntensity == 0 ? "Off" : (_hapticIntensity == 0.5 ? "Light" : "Industrial"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // --- 4. DATA ---
              _buildSectionHeader("DATA"),
              _buildSettingsTile(
                context,
                "Clear Cache",
                Icons.cleaning_services_outlined,
                onTap: () {
                  HapticFeedback.mediumImpact();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Cache cleared", style: GoogleFonts.antonio())),
                  );
                },
              ),
              
              const SizedBox(height: 40),
              
              // --- FOOTER ---
              Center(
                child: Column(
                  children: [
                    Text(
                      "ANCHOR v1.0.0",
                      style: GoogleFonts.antonio(color: AppTheme.mutedTaupe, fontSize: 14),
                    ),
                    Text(
                      "Local First. Zero Knowledge.",
                      style: GoogleFonts.beiruti(color: AppTheme.mutedTaupe, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, bottom: 10),
      child: Text(
        title,
        style: GoogleFonts.antonio(
          color: const Color.fromARGB(255, 152, 126, 126), // Red Accent
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildSettingsTile(BuildContext context, String title, IconData icon, {required VoidCallback onTap}) {
    return ListTile(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      leading: Icon(icon, color: AppTheme.fogWhite, size: 28),
      title: Text(
        title,
        style: GoogleFonts.antonio(color: AppTheme.fogWhite, fontSize: 20),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: AppTheme.mutedTaupe, size: 16),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      value: value,
      onChanged: (val) {
        HapticFeedback.lightImpact();
        onChanged(val);
      },
      activeColor: const Color.fromARGB(255, 255, 255, 255),
      inactiveTrackColor: AppTheme.deepTaupe,
      contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      title: Text(
        title,
        style: GoogleFonts.antonio(color: AppTheme.fogWhite, fontSize: 20),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.beiruti(color: AppTheme.mutedTaupe, fontSize: 14),
      ),
    );
  }
}