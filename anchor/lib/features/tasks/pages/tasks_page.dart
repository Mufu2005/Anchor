import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../models/task_model.dart';
import '../widgets/task_card.dart';
import 'new_task_page.dart';
import '../../../core/services/online_db_service.dart'; // Ensure this path is correct

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  String _selectedPriority = "All";
  final List<String> _priorities = ["All", "High", "Medium", "Low"];
  
  List<Task> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  // --- 1. FETCH TASKS FROM DB ---
  Future<void> _fetchTasks() async {
    setState(() => _isLoading = true);
    
    try {
      final fetchedTasks = await OnlineDbService().getTasks();
      setState(() {
        _tasks = fetchedTasks;
      });
    } catch (e) {
      debugPrint("Failed to load tasks: $e");
      // Subtle minimalistic error handling (per your prior preference)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Could not sync tasks."),
            backgroundColor: AppTheme.deepTaupe,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // --- 2. DELETE TASK ---
  Future<void> _handleDelete(String taskId) async {
    HapticFeedback.mediumImpact();
    // Optimistically remove from UI
    setState(() {
      _tasks.removeWhere((t) => t.id == taskId);
    });
    
    try {
      await OnlineDbService().deleteTask(taskId);
    } catch (e) {
      // Revert if DB fails
      _fetchTasks();
    }
  }

  // --- 3. TOGGLE COMPLETION ---
  Future<void> _handleToggleCompletion(Task task) async {
    HapticFeedback.lightImpact();
    final newStatus = !task.isCompleted;
    
    // Optimistic UI update
    setState(() {
      task.isCompleted = newStatus;
    });

    try {
      await OnlineDbService().markTaskAsCompleted(task.id, newStatus);
    } catch (e) {
      // Revert if DB fails
      setState(() {
        task.isCompleted = !newStatus;
      });
    }
  }

  // --- 4. COLOR LOGIC ---
  Color _getPriorityColor(String? priority) {
    switch (priority) {
      case "High":
        return const Color.fromARGB(195, 205, 27, 24); // Red
      case "Medium":
        return Colors.amber; // Yellow/Amber
      case "Low":
        return const Color(0xFF00FF41); // Green
      default:
        return AppTheme.mutedTaupe; // Fallback for missing DB priority
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
            // --- HEADER ---
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
                      IconButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.mutedTaupe, size: 30),
                      ),
                      IconButton(
                        onPressed: () async {
                          HapticFeedback.lightImpact();
                          // Wait for NewTaskPage to return, then refresh list
                          await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const NewTaskPage()),
                          );
                          _fetchTasks(); 
                        },
                        icon: const Icon(Icons.add, color: AppTheme.mutedTaupe, size: 30),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // --- TASK LIST ---
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: AppTheme.mutedTaupe),
                    )
                  : _tasks.isEmpty
                      ? Center(
                          child: Text(
                            "NO TASKS FOUND",
                            style: GoogleFonts.antonio(color: AppTheme.mutedTaupe, fontSize: 18),
                          ),
                        )
                      : RefreshIndicator(
                          color: AppTheme.fogWhite,
                          backgroundColor: AppTheme.deepTaupe,
                          onRefresh: _fetchTasks,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: filteredTasks.length,
                            itemBuilder: (context, index) {
                              final task = filteredTasks[index];

                              return TaskCard(
                                title: task.title,
                                description: task.description ?? "No description", // Fallback
                                date: task.time_stamp != null 
                                    ? DateFormat('HH:mm dd MMM yyyy').format(task.time_stamp!).toUpperCase()
                                    : "NO DEADLINE",
                                priorityColor: _getPriorityColor(task.priority),
                                isCompleted: task.isCompleted,
                                onCheck: () => _handleToggleCompletion(task),
                                onEdit: () {
                                  // TODO: Navigate to edit page
                                },
                                onDelete: () => _handleDelete(task.id),
                              );
                            },
                          ),
                        ),
            ),

            // --- FOOTER DROPDOWN ---
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
                    icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.mutedTaupe),
                    style: GoogleFonts.antonio(color: AppTheme.fogWhite, fontSize: 18),
                    isExpanded: true,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() => _selectedPriority = newValue);
                        HapticFeedback.lightImpact();
                      }
                    },
                    items: _priorities.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Center(
                          child: Text(value, style: const TextStyle(color: AppTheme.fogWhite)),
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