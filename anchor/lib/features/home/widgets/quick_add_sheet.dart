import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../tasks/pages/new_task_page.dart';
import '../../habits/pages/new_habit_page.dart';
import '../../journal/pages/journal_editor_page.dart';
import '../../timetable/pages/new_schedule_page.dart';

class QuickAddMenu extends StatefulWidget {
  const QuickAddMenu({super.key});

  @override
  State<QuickAddMenu> createState() => _QuickAddMenuState();
}

class _QuickAddMenuState extends State<QuickAddMenu> {
  // Links the button to the overlay
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  void _toggleMenu() {
    if (_isOpen) {
      _closeMenu();
    } else {
      _openMenu();
    }
  }

  void _openMenu() {
    HapticFeedback.mediumImpact();
    setState(() => _isOpen = true);

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _closeMenu() {
    HapticFeedback.lightImpact();
    setState(() => _isOpen = false);
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  // --- THE DROPDOWN DESIGN ---
  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: 180, // Fixed width for the menu
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(-(180 - size.width), size.height + 10), // Align right edge
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.deepTaupe,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: AppTheme.mutedTaupe.withOpacity(0.3)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildMenuItem("NEW TASK", Icons.check_circle_outline, () => const NewTaskPage()),
                  _buildDivider(),
                  _buildMenuItem("NEW HABIT", Icons.bolt, () => const NewHabitPage()),
                  _buildDivider(),
                  _buildMenuItem("NEW ENTRY", Icons.edit_outlined, () => const JournalEditorPage()),
                  _buildDivider(),
                  _buildMenuItem("NEW SCHEDULE", Icons.calendar_today, () => const NewSchedulePage()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(String text, IconData icon, Widget Function() page) {
    return InkWell(
      onTap: () {
        _closeMenu();
        Navigator.push(context, MaterialPageRoute(builder: (context) => page()));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.mutedTaupe, size: 20),
            const SizedBox(width: 15),
            Text(
              text,
              style: GoogleFonts.antonio(
                color: AppTheme.fogWhite,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppTheme.mutedTaupe.withOpacity(0.2),
      indent: 15,
      endIndent: 15,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleMenu,
        child: Container(
          width: 40,
          height: 40,
          // decoration: BoxDecoration(
          // //   color: _isOpen ? AppTheme.fogWhite : const Color(0xFF5C4E4E), // White when open, Red when closed
          // //   shape: BoxShape.circle,
          // //   boxShadow: [
          // //     BoxShadow(
          // //       color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.4),
          // //       blurRadius: 8,
          // //     ),
          // //   ],
          // // ),
          child: Icon(
            _isOpen ? Icons.close : Icons.add,
            color: _isOpen ? const Color.fromARGB(255, 255, 255, 255) : AppTheme.fogWhite,
            size: 30,
          ),
        ),
      ),
    );
  }
}