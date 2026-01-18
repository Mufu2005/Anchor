import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../models/habit_model.dart';
import '../widgets/habit_card.dart';

class HabitsPage extends StatefulWidget {
  const HabitsPage({super.key});

  @override
  State<HabitsPage> createState() => _HabitsPageState();
}

class _HabitsPageState extends State<HabitsPage> {
  // --- MOCK DATA ---
  final List<Habit> _habits = [
    Habit(id: '1', title: "Gym", streak: 6, statusColor: Colors.redAccent),
    Habit(id: '2', title: "Read", streak: 12, statusColor: Colors.greenAccent),
    Habit(id: '3', title: "Water", streak: 3, statusColor: Colors.amberAccent),
    Habit(id: '4', title: "Code", streak: 60, statusColor: Colors.blueAccent),
  ];

  @override
  Widget build(BuildContext context) {
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
                    "HABITS",
                    style: GoogleFonts.bangers(
                      color: AppTheme.fogWhite,
                      fontSize: 32,
                      letterSpacing: 1.0,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back Button
                      IconButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.mutedTaupe, size: 30),
                      ),
                      // Add Button
                      IconButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          // TODO: Add New Habit Logic
                        },
                        icon: const Icon(Icons.add, color: AppTheme.mutedTaupe, size: 30),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // --- 2. GRID OF HABITS ---
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 Columns
                  childAspectRatio: 1.9, // Controls height vs width ratio (Wider cards)
                  crossAxisSpacing: 15, // Gap between cols
                  mainAxisSpacing: 15,  // Gap between rows
                ),
                itemCount: _habits.length,
                itemBuilder: (context, index) {
                  final habit = _habits[index];
                  return HabitCard(
                    title: habit.title,
                    streak: habit.streak,
                    statusColor: habit.statusColor,
                    onTap: () {
                      // TODO: Open Detail or Increment Streak
                    },
                    onEdit: () {
                      // TODO: Edit Logic
                    },
                    onDelete: () {
                      // TODO: Delete Logic
                    },
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