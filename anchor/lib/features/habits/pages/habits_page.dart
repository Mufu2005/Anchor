import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/online_db_service.dart'; // <--- Import Service
import '../../../core/theme/app_theme.dart';
import '../models/habit_model.dart';
import '../widgets/habit_card.dart';
import 'new_habit_page.dart';

class HabitsPage extends StatefulWidget {
  const HabitsPage({super.key});

  @override
  State<HabitsPage> createState() => _HabitsPageState();
}

class _HabitsPageState extends State<HabitsPage> {
  final OnlineDbService _db = OnlineDbService();
  List<Habit> _habits = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchHabits();
  }

  // --- 1. LOAD DATA ---
  Future<void> _fetchHabits() async {
    final data = await _db.getHabits();
    if (mounted) {
      setState(() {
        _habits = data;
        _isLoading = false;
      });
    }
  }

  // --- 2. DELETE LOGIC ---
  void _deleteHabit(String id) async {
    // Optimistic Update: Remove from UI immediately for speed
    setState(() {
      _habits.removeWhere((h) => h.id == id);
    });
    // Perform actual delete
    await _db.deleteHabit(id);
  }

  // --- 3. TAP LOGIC (Increment) ---
  void _incrementHabit(Habit habit) async {
    HapticFeedback.mediumImpact();
    await _db.incrementStreak(habit.id, habit.streak);
    _fetchHabits(); // Refresh to show new streak/color
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.voidBlack,
      body: SafeArea(
        child: Column(
          children: [
            // HEADER (Kept your exact design)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text("HABITS",
                      style: GoogleFonts.bangers(
                          color: AppTheme.fogWhite,
                          fontSize: 32,
                          letterSpacing: 1.0)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.keyboard_arrow_down,
                            color: AppTheme.mutedTaupe, size: 30),
                      ),
                      IconButton(
                        onPressed: () async {
                          HapticFeedback.lightImpact();
                          // Wait for result from NewPage, then refresh
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const NewHabitPage()),
                          );
                          _fetchHabits();
                        },
                        icon: const Icon(Icons.add,
                            color: AppTheme.mutedTaupe, size: 30),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // GRID
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: Colors.red))
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.9,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                      ),
                      itemCount: _habits.length,
                      itemBuilder: (context, index) {
                        final habit = _habits[index];
                        return HabitCard(
                          title: habit.title,
                          streak: habit.streak,
                          statusColor: habit.statusColor, // Calculated dynamically
                          onTap: () => _incrementHabit(habit),
                          onEdit: () {
                             // TODO: Edit
                          },
                          onDelete: () => _deleteHabit(habit.id),
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