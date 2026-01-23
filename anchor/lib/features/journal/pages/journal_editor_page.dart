import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

class JournalEditorPage extends StatefulWidget {
  final String? initialTitle;
  final String? initialContent;
  final String? initialCategory; 

  const JournalEditorPage({
    super.key, 
    this.initialTitle, 
    this.initialContent,
    this.initialCategory,
  });

  @override
  State<JournalEditorPage> createState() => _JournalEditorPageState();
}

class _JournalEditorPageState extends State<JournalEditorPage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  // --- CATEGORY STATE ---
  List<String> _categories = ["Personal", "Work", "Ideas", "Health"];
  String _selectedCategory = "Personal"; 

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _contentController = TextEditingController(text: widget.initialContent);
    
    // Ensure the initial category exists in the list
    if (widget.initialCategory != null) {
      if (!_categories.contains(widget.initialCategory)) {
        _categories.add(widget.initialCategory!);
      }
      _selectedCategory = widget.initialCategory!;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  // --- ADD NEW CATEGORY ---
  void _showAddCategoryDialog() {
    TextEditingController newCatController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) {
        return _buildStyledDialog(
          title: "NEW CATEGORY",
          controller: newCatController,
          confirmText: "ADD",
          onConfirm: () {
            if (newCatController.text.isNotEmpty) {
              setState(() {
                _categories.add(newCatController.text);
                _selectedCategory = newCatController.text;
              });
              Navigator.pop(context);
            }
          },
        );
      },
    );
  }

  // --- EDIT / DELETE CATEGORY ---
  void _showEditCategoryDialog(int index) {
    final String currentName = _categories[index];
    TextEditingController editController = TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (context) {
        return _buildStyledDialog(
          title: "EDIT CATEGORY",
          controller: editController,
          confirmText: "SAVE",
          // Show Delete Button on the left
          leadingAction: TextButton(
            onPressed: () {
               // Prevent deleting the last category
               if (_categories.length <= 1) return;

               HapticFeedback.mediumImpact();
               setState(() {
                 _categories.removeAt(index);
                 // If we deleted the active category, switch to the first one
                 if (_selectedCategory == currentName) {
                   _selectedCategory = _categories.isNotEmpty ? _categories[0] : "";
                 }
               });
               Navigator.pop(context);
            },
            child: Text("DELETE", style: GoogleFonts.antonio(color: const Color(0xFFCD1C18))),
          ),
          onConfirm: () {
            if (editController.text.isNotEmpty) {
              setState(() {
                _categories[index] = editController.text;
                // If we renamed the active category, update the selection
                if (_selectedCategory == currentName) {
                  _selectedCategory = editController.text;
                }
              });
              Navigator.pop(context);
            }
          },
        );
      },
    );
  }

  // --- REUSABLE DIALOG WIDGET ---
  Widget _buildStyledDialog({
    required String title,
    required TextEditingController controller,
    required String confirmText,
    required VoidCallback onConfirm,
    Widget? leadingAction,
  }) {
    return Theme(
      data: ThemeData.dark().copyWith(dialogBackgroundColor: AppTheme.deepTaupe),
      child: AlertDialog(
        backgroundColor: AppTheme.deepTaupe,
        title: Text(title, style: GoogleFonts.antonio(color: AppTheme.fogWhite)),
        content: TextField(
          controller: controller,
          cursorColor: AppTheme.fogWhite,
          style: GoogleFonts.antonio(color: AppTheme.fogWhite),
          decoration: InputDecoration(
            hintText: "Category Name",
            hintStyle: GoogleFonts.antonio(color: AppTheme.mutedTaupe),
            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppTheme.mutedTaupe)),
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppTheme.fogWhite)),
          ),
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween, // Pushes Delete to left, Save to right
        actions: [
          leadingAction ?? TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("CANCEL", style: GoogleFonts.antonio(color: AppTheme.mutedTaupe)),
          ),
          TextButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              onConfirm();
            },
            child: Text(confirmText, style: GoogleFonts.antonio(color: AppTheme.fogWhite)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.voidBlack,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              // 1. HEADER
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

                   Text(
                widget.initialTitle == null ? "NEW ENTRY" : "EDIT ENTRY",
                style: GoogleFonts.antonio(
                  color: AppTheme.fogWhite,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  letterSpacing: 1.0,
                ),
              ),

                  IconButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      // TODO: Save Logic
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.bookmark, color: AppTheme.mutedTaupe, size: 28),
                  ),
                ],
              ),

              // 2. TITLE
             

              const SizedBox(height: 20),

              // 3. CATEGORY SELECTOR (Updated with Long Press)
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length + 1,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    // "Add New" Button
                    if (index == _categories.length) {
                      return GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          _showAddCategoryDialog();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppTheme.mutedTaupe),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Center(
                            child: Icon(Icons.add, color: AppTheme.mutedTaupe, size: 20),
                          ),
                        ),
                      );
                    }

                    // Category Chips
                    final category = _categories[index];
                    final isSelected = category == _selectedCategory;

                    return GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                      // --- LONG PRESS TO EDIT/DELETE ---
                      onLongPress: () {
                        HapticFeedback.heavyImpact(); // Stronger vibration for long press
                        _showEditCategoryDialog(index);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: isSelected ? AppTheme.deepTaupe : Colors.transparent,
                          border: Border.all(
                            color: isSelected ? AppTheme.fogWhite : AppTheme.mutedTaupe,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            category,
                            style: GoogleFonts.antonio(
                              color: isSelected ? AppTheme.fogWhite : AppTheme.mutedTaupe,
                              fontSize: 14,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // 4. TITLE INPUT
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(
                  color: AppTheme.deepTaupe,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: _titleController,
                  style: GoogleFonts.antonio(
                    color: AppTheme.fogWhite,
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                  ),
                  cursorColor: AppTheme.fogWhite,
                  decoration: InputDecoration(
                    hintText: "Title",
                    hintStyle: GoogleFonts.antonio(
                      color: AppTheme.fogWhite.withOpacity(0.5),
                      fontSize: 24,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // 5. CONTENT INPUT
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.deepTaupe,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    controller: _contentController,
                    expands: true, 
                    maxLines: null, 
                    textAlignVertical: TextAlignVertical.top,
                    cursorColor: AppTheme.fogWhite,
                    style: GoogleFonts.beiruti(
                      color: AppTheme.fogWhite,
                      fontSize: 16,
                      height: 1.5,
                    ),
                    decoration: InputDecoration(
                      hintText: "Write something here...",
                      hintStyle: GoogleFonts.beiruti(
                        color: AppTheme.mutedTaupe,
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 6. FOOTER
              Container(
                width: 50,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFCD1C18),
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFCD1C18).withOpacity(0.5),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}