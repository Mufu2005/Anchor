import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../models/task_model.dart';
import '../widgets/task_card.dart';
import 'new_task_page.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  String _selectedPriority = "All"; // Default view

  final List<String> _priorities = ["All", "High", "Medium", "Low"];

  // --- MOCK DATA ---
  final List<Task> _tasks = [
    Task(
      id: '1',
      title: "Dinner with her",
      description: "Reservations at 8 PM. Don't be late.",
      date: DateTime.now(),
      priority: "High", // <--- Red Bar
      isCompleted: true,
    ),
    Task(
      id: '2',
      title: "Gym Session",
      description: "Leg day focus. Don't skip squats.",
      date: DateTime.now(),
      priority: "Medium", // <--- Yellow Bar
      isCompleted: false,
    ),
    Task(
      id: '3',
      title: "Buy Groceries",
      description: "Milk, Eggs, Coffee.",
      date: DateTime.now(),
      priority: "Low", // <--- Green Bar
      isCompleted: false,
    ),
    Task(
      id: '4',
      title: "Submit Report",
      description: "Finalize the Q1 analysis.",
      date: DateTime.now(),
      priority: "High", // <--- Red Bar
      isCompleted: false,
    ),
  ];

  // --- 3. HELPER: COLOR LOGIC ---
  Color _getPriorityColor(String priority) {
    switch (priority) {
      case "High":
        return const Color.fromARGB(195, 205, 27, 24); // Red
      case "Medium":
        return Colors.amber; // Yellow/Amber
      case "Low":
        return const Color(0xFF00FF41); // Green
      default:
        return AppTheme.mutedTaupe; // Fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = _selectedPriority == "All"
        ? _tasks
        : _tasks.where((t) => t.priority == _selectedPriority).toList();

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
                    "TASKS",
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
                              builder: (context) => const NewTaskPage(),
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

            // --- 2. TASK LIST ---
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: filteredTasks.length,
                itemBuilder: (context, index) {
                  final task = filteredTasks[index];

                  return TaskCard(
                    title: task.title,
                    description: task.description,
                    date: DateFormat(
                      'HH:mm dd MMM yyyy',
                    ).format(task.date).toUpperCase(),

                    // AUTOMATIC COLOR ASSIGNMENT
                    priorityColor: _getPriorityColor(task.priority),

                    isCompleted: task.isCompleted,
                    onCheck: () {
                      setState(() {
                        task.isCompleted = !task.isCompleted;
                      });
                    },
                    onEdit: () {},
                    onDelete: () {},
                  );
                },
              ),
            ),

            // --- 3. FOOTER DROPDOWN ---
            Padding(
              padding: const EdgeInsets.only(bottom: 20, top: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: 200,
                decoration: BoxDecoration(
                  color: AppTheme.deepTaupe,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedPriority,
                    dropdownColor: AppTheme.deepTaupe,
                    borderRadius: BorderRadius.circular(20),
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: AppTheme.mutedTaupe,
                    ),
                    style: GoogleFonts.antonio(
                      color: AppTheme.fogWhite,
                      fontSize: 18,
                    ),
                    isExpanded: true,

                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedPriority = newValue;
                        });
                        HapticFeedback.lightImpact();
                      }
                    },
                    items: _priorities.map<DropdownMenuItem<String>>((
                      String value,
                    ) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Center(
                          child: Text(
                            value,
                            // Optional: Color the text in the dropdown itself
                            style: TextStyle(color: AppTheme.fogWhite),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
