import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // Used for dynamic dates
import '../../../core/theme/app_theme.dart';
import '../widgets/sidebar_drawer.dart';
import '../../journal/pages/journal_page.dart';
import '../../habits/pages/habits_page.dart';
import '../../tasks/pages/tasks_page.dart';
import '../../timetable/pages/timetable_page.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dynamic Date: Get today's date (e.g., "JAN 7")
    final String todayDate = DateFormat(
      'MMM d',
    ).format(DateTime.now()).toUpperCase();

    return Scaffold(
      backgroundColor: AppTheme.voidBlack,
      drawer: const SidebarDrawer(),

      // We use a Stack to position elements freely (Top, Center, Bottom)
      body: Stack(
        children: [
          // 1. TOP LEFT MENU ICON
          Positioned(
            top: 50,
            left: 20,
            child: Builder(
              builder: (innerContext) {
                return IconButton(
                  icon: const Icon(
                    Icons.menu_rounded,
                    color: Color(0xFF988686),
                    size: 30,
                  ),
                  onPressed: () {
                    // Use 'innerContext' here, not the main 'context'
                    Scaffold.of(innerContext).openDrawer();
                  },
                );
              },
            ),
          ),

          Positioned(
            top: 0,
            bottom: 0,
            left: 30, // 1. Gives it that "Cinematic" padding from the left edge
            right: 20,
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Keeps it vertically centered
              crossAxisAlignment:
                  CrossAxisAlignment.start, // 2. Aligns text to the LEFT
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Welcome back",
                  style: GoogleFonts.antonio(
                    color: AppTheme.fogWhite,
                    fontSize: 40, // Bumped up slightly for impact
                    fontWeight: FontWeight.w100,
                    letterSpacing: 1.0,
                    height: 1.0, // Tighter line height
                  ),
                ),
                const SizedBox(height: 8),

                // 3. The Subtitle with the "Margin to the right" (Indentation)
                Padding(
                  // This shifts the text 60px to the right, creating that "Stepped" look
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

          // 3. FOOTER ASSEMBLY (Date + Nav Bar)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // The Date "JAN 7"
                Text(
                  todayDate,
                  style: GoogleFonts.bangers(
                    color: AppTheme.fogWhite,
                    fontSize: 30,
                    //fontWeight: FontWeight.normal,
                    fontStyle:
                        FontStyle.italic, // Matches the slant in screenshot
                    letterSpacing: 1.5,
                  ),
                ),

                const SizedBox(height: 10), // Spacing between date and bar
                // The Navigation Bar Container
                Container(
                  height: 85,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: const BoxDecoration(
                    color: AppTheme.deepTaupe, // #5C4E4E
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Habits (Lightning)
                      _buildNavIcon(
                        'assets/icons/changes.png',
                        true,
                        42,
                        42,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HabitsPage(),
                            ),
                          );
                        },
                      ),

                      // journal
                      _buildNavIcon(
                        'assets/icons/journal.png',
                        true,
                        33,
                        33,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const JournalPage(),
                            ),
                          );
                        },
                      ),

                      // archive
                      _buildNavIcon(
                        'assets/icons/archive.png',
                        true,
                        40,
                        40,
                        onTap: () {
                          // TODO: Navigate to Habits
                        },
                      ),

                      // Tasks
                      _buildNavIcon(
                        'assets/icons/app.png',
                        true,
                        40,
                        40,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TasksPage(),
                            ),
                          );
                        },
                      ),

                      // timetable
                      _buildNavIcon(
                        'assets/icons/calendar-clock.png',
                        true,
                        40,
                        40,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TimeTablePage(),
                            ),
                          );
                        },
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
  Widget _buildNavIcon(
    String iconPath,
    bool isActive,
    double width,
    double height, {
    VoidCallback? onTap,
  }) {
    return IconButton(
      onPressed: () {
        HapticFeedback.lightImpact(); // Add vibration
        if (onTap != null) {
          onTap(); // Execute the navigation if provided
        }
      },
      // Note: "color" property on Image.asset tints the whole PNG.
      // If your PNGs are already colored, remove the 'color' property below.
      icon: Image.asset(
        iconPath,
        width: width,
        height: height,
        fit: BoxFit.contain,
        color: isActive
            ? AppTheme.fogWhite
            : AppTheme.mutedTaupe.withOpacity(0.6),
      ),
    );
  }
}
