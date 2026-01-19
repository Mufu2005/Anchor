import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../models/task_model.dart';
import '../widgets/task_card.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  // --- MOCK DATA ---
  final List<Task> _tasks = [
    Task(
      id: '1',
      title: "Dinner with her",
      description: "this is gibbresshss ajkl jasldfj ljf lasfklasj fkl",
      date: DateTime.now(),
      priorityColor: const Color(0xFFCD1C18), // Red
      isCompleted: true,
    ),
    Task(
      id: '2',
      title: "Gym Session",
      description: "Leg day focus. Don't skip squats.",
      date: DateTime.now(),
      priorityColor: Colors.amber, // Yellow
      isCompleted: false,
    ),
    Task(
      id: '3',
      title: "Project Review",
      description: "",
      date: DateTime.now(),
      priorityColor: Colors.green, // Green
      isCompleted: true,
    ),
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
                        icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.mutedTaupe, size: 30),
                      ),
                      // Add Button
                      IconButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          // TODO: Add Task Logic
                        },
                        icon: const Icon(Icons.add, color: AppTheme.mutedTaupe, size: 30),
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
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  final task = _tasks[index];
                  return TaskCard(
                    title: task.title,
                    description: task.description,
                    date: DateFormat('HH:mm dd MMM yyyy').format(task.date).toUpperCase(),
                    priorityColor: task.priorityColor,
                    isCompleted: task.isCompleted,
                    
                    // Toggle Checkbox Logic
                    onCheck: () {
                      setState(() {
                        task.isCompleted = !task.isCompleted;
                      });
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

            // --- 3. FOOTER DROPDOWN ---
            Padding(
              padding: const EdgeInsets.only(bottom: 20, top: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                width: 200,
                decoration: BoxDecoration(
                  color: AppTheme.deepTaupe,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "High",
                      style: GoogleFonts.antonio(
                        color: AppTheme.fogWhite,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.keyboard_arrow_down, color: AppTheme.mutedTaupe),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}