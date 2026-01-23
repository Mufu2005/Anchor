import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../models/timetable_model.dart';
import '../widgets/timetable_card.dart';
import 'new_schedule_page.dart';

class TimeTablePage extends StatefulWidget {
  const TimeTablePage({super.key});

  @override
  State<TimeTablePage> createState() => _TimeTablePageState();
}

class _TimeTablePageState extends State<TimeTablePage> {
  // Current selected day
  String _selectedDay = "Wednesday";

  // List of days for the dropdown
  final List<String> _days = [
    "All",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];

  // Mock Data
  final List<TimeTableEntry> _allEntries = [
    TimeTableEntry(
      id: '1',
      title: "Dinner with her",
      time: "20:00",
      day: "Wednesday",
    ),
    TimeTableEntry(
      id: '2',
      title: "Physics Class",
      time: "10:00",
      day: "Monday",
    ),
    TimeTableEntry(
      id: '3',
      title: "Gym Leg Day",
      time: "18:00",
      day: "Wednesday",
    ),
    TimeTableEntry(
      id: '4',
      title: "Team Meeting",
      time: "09:00",
      day: "Friday",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Filter the list based on the selected day
    final currentEntries = _selectedDay == "All"
        ? _allEntries // Show everything if "All" is selected
        : _allEntries.where((e) => e.day == _selectedDay).toList();

    return Scaffold(
      backgroundColor: AppTheme.voidBlack,
      body: SafeArea(
        child: Column(
          children: [
            // --- 1. HEADER ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    "TIME TABLE",
                    style: GoogleFonts.bangers(
                      color: AppTheme.fogWhite,
                      fontSize: 32,
                      letterSpacing: 1.0,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back Arrow
                      IconButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: AppTheme.mutedTaupe,
                          size: 30,
                        ),
                      ),
                      // Add Button
                      IconButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NewSchedulePage(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.add,
                          color: AppTheme.mutedTaupe,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // --- 2. DAY SELECTOR DROPDOWN ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: AppTheme.deepTaupe,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedDay,
                    dropdownColor: AppTheme.deepTaupe,
                    borderRadius: BorderRadius.circular(12),
                    isExpanded: true,
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: AppTheme.mutedTaupe,
                    ),
                    style: GoogleFonts.antonio(
                      color: AppTheme.fogWhite,
                      fontSize: 18,
                    ),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedDay = newValue;
                        });
                        HapticFeedback.lightImpact();
                      }
                    },
                    items: _days.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Center(child: Text(value)),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // --- 3. LIST OF ENTRIES ---
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: currentEntries.length,
                itemBuilder: (context, index) {
                  final entry = currentEntries[index];
                  return TimeTableCard(
                    title: entry.title,
                    time:
                        "${entry.time} 21 JAN 2025", // Hardcoded date for visual match
                    onEdit: () {},
                    onDelete: () {},
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
