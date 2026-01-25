import 'dart:async'; // Required for StreamSubscription
import 'package:connectivity_plus/connectivity_plus.dart'; // Required for Internet check
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../widgets/sidebar_drawer.dart';
import '../../journal/pages/journal_page.dart';
import '../../habits/pages/habits_page.dart';
import '../../tasks/pages/tasks_page.dart';
import '../../timetable/pages/timetable_page.dart';
import '../widgets/quick_add_sheet.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // --- CONNECTIVITY STATE ---
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    // Listen for network changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Initial check
  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (_) {
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }
    return _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) {
    setState(() {
      _connectionStatus = result;
    });
  }

  // Helper to determine if we are offline
  bool get _isOffline => _connectionStatus.contains(ConnectivityResult.none);

  @override
  Widget build(BuildContext context) {
    // Dynamic Date
    final String todayDate = DateFormat('MMM d').format(DateTime.now()).toUpperCase();

    return Scaffold(
      backgroundColor: AppTheme.voidBlack,
      drawer: const SidebarDrawer(),
      body: Stack(
        children: [
          // --- 1. CONNECTIVITY BAR (Most Left Side) ---
          Positioned(
            left: 0,
            top: 55, // Vertically aligned with the Menu Icon (top: 50 + padding)
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: 4, // Slim vertical bar
              height: 40, // Height of the indicator
              decoration: BoxDecoration(
                // RED if Offline, GREEN if Online
                color: _isOffline ? const Color(0xFFCD1C18) : const Color(0xFF00FF41),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: (_isOffline ? const Color(0xFFCD1C18) : const Color(0xFF00FF41)).withOpacity(0.6),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),

          // --- 2. MENU ICON ---
          Positioned(
            top: 50,
            left: 20,
            right: 20, // Defines the width constraints for the Row
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Pushes items to opposite ends
              children: [
                // 1. LEFT: MENU ICON
                Builder(
                  builder: (innerContext) {
                    return IconButton(
                      icon: const Icon(
                        Icons.menu_rounded,
                        color: Color(0xFF988686),
                        size: 30,
                      ),
                      onPressed: () {
                        // Uses innerContext to find the Scaffold
                        Scaffold.of(innerContext).openDrawer();
                      },
                    );
                  },
                ),

                // 2. RIGHT: QUICK ADD MENU
                const QuickAddMenu(),
              ],
            ),
          ),

          // --- 3. MAIN CONTENT (Welcome Text) ---
          Positioned(
            top: 0,
            bottom: 0,
            left: 30,
            right: 20,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Welcome back",
                  style: GoogleFonts.antonio(
                    color: AppTheme.fogWhite,
                    fontSize: 40,
                    fontWeight: FontWeight.w100,
                    letterSpacing: 1.0,
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 90.0),
                  child: Text(
                    "Whats on your mind!",
                    style: GoogleFonts.beiruti(
                      color: AppTheme.mutedTaupe,
                      fontSize: 16,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // --- 4. FOOTER (Date + Nav Bar) ---
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  todayDate,
                  style: GoogleFonts.bangers(
                    color: AppTheme.fogWhite,
                    fontSize: 30,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 85,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: const BoxDecoration(
                    color: Color(0xFF5C4E4E),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Habits
                      _buildNavIcon(
                        'assets/icons/changes.png',
                        true, 42, 42,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HabitsPage())),
                      ),
                      // Journal
                      _buildNavIcon(
                        'assets/icons/journal.png',
                        true, 33, 33,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const JournalPage())),
                      ),
                      
                      // Archive (Placeholder)
                      _buildNavIcon(
                        'assets/icons/archive.png',
                        true, 40, 40,
                        onTap: () {},
                      ),
                      // Tasks
                      _buildNavIcon(
                        'assets/icons/app.png',
                        true, 40, 40,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TasksPage())),
                      ),
                      // Timetable
                      _buildNavIcon(
                        'assets/icons/calendar-clock.png',
                        true, 40, 40,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TimeTablePage())),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget for Nav Icons
  Widget _buildNavIcon(String iconPath, bool isActive, double width, double height, {VoidCallback? onTap}) {
    return IconButton(
      onPressed: () {
        HapticFeedback.lightImpact();
        if (onTap != null) onTap();
      },
      icon: Image.asset(
        iconPath,
        width: width,
        height: height,
        fit: BoxFit.contain,
        color: isActive ? AppTheme.fogWhite : AppTheme.mutedTaupe.withOpacity(0.6),
      ),
    );
  }
}