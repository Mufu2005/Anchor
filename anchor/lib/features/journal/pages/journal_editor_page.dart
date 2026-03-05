import 'package:anchor/core/services/encryption_service.dart';
import 'package:anchor/core/services/online_db_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

class JournalEditorPage extends StatefulWidget {
  final String? initialTitle;
  final String? initialContent;
  final String? initialCategory;
  final String? entryId; // Pass this if editing an existing entry

  const JournalEditorPage({
    super.key,
    this.initialTitle,
    this.initialContent,
    this.initialCategory,
    this.entryId,
  });

  @override
  State<JournalEditorPage> createState() => _JournalEditorPageState();
}

class _JournalEditorPageState extends State<JournalEditorPage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  final OnlineDbService _db = OnlineDbService();
  
  bool _isSaving = false;

  // --- CATEGORY STATE ---
  List<String> _categories = ["Personal", "Work", "Ideas", "Health", "Study"];
  String _selectedCategory = "Personal";

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _contentController = TextEditingController(text: widget.initialContent);

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

  // --- SAVE TO DATABASE (ENCRYPTED) ---
  void _saveEntry() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Title and Content cannot be empty")),
      );
      return;
    }

    setState(() => _isSaving = true);
    HapticFeedback.mediumImpact();

    try {
      // 1. Encrypt data locally
      final String encTitle = EncryptionService().encryptData(_titleController.text);
      final String encContent = EncryptionService().encryptData(_contentController.text);
      final String encCategory = EncryptionService().encryptData(_selectedCategory);

      // 2. Push to DB
      await _db.createNewEntry(
        title: encTitle,
        content: encContent,
        category: encCategory,
      );

      if (mounted) {
        Navigator.pop(context); // Return to Journal List
      }
    } catch (e) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Encryption failed: $e")),
      );
    }
  }

  // --- CATEGORY DIALOGS ---
  void _showAddCategoryDialog() {
    TextEditingController newCatController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => _buildStyledDialog(
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
      ),
    );
  }

  void _showEditCategoryDialog(int index) {
    final String currentName = _categories[index];
    TextEditingController editController = TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (context) => _buildStyledDialog(
        title: "EDIT CATEGORY",
        controller: editController,
        confirmText: "SAVE",
        leadingAction: TextButton(
          onPressed: () {
            if (_categories.length <= 1) return;
            HapticFeedback.mediumImpact();
            setState(() {
              _categories.removeAt(index);
              if (_selectedCategory == currentName) {
                _selectedCategory = _categories[0];
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
              if (_selectedCategory == currentName) _selectedCategory = editController.text;
            });
            Navigator.pop(context);
          }
        },
      ),
    );
  }

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
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          leadingAction ?? TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("CANCEL", style: GoogleFonts.antonio(color: AppTheme.mutedTaupe)),
          ),
          TextButton(
            onPressed: onConfirm,
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
              // HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.mutedTaupe, size: 30),
                  ),
                  Text(
                    widget.initialTitle == null ? "NEW ENTRY" : "EDIT ENTRY",
                    style: GoogleFonts.antonio(
                      color: AppTheme.fogWhite,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  IconButton(
                    onPressed: _isSaving ? null : _saveEntry,
                    icon: _isSaving
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.red))
                        : const Icon(Icons.bookmark, color: AppTheme.mutedTaupe, size: 28),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // CATEGORY SELECTOR
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length + 1,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    if (index == _categories.length) {
                      return GestureDetector(
                        onTap: _showAddCategoryDialog,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(border: Border.all(color: AppTheme.mutedTaupe), borderRadius: BorderRadius.circular(20)),
                          child: const Icon(Icons.add, color: AppTheme.mutedTaupe, size: 20),
                        ),
                      );
                    }
                    final category = _categories[index];
                    final isSelected = category == _selectedCategory;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedCategory = category),
                      onLongPress: () => _showEditCategoryDialog(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: isSelected ? AppTheme.deepTaupe : Colors.transparent,
                          border: Border.all(color: isSelected ? AppTheme.fogWhite : AppTheme.mutedTaupe),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(category, style: GoogleFonts.antonio(color: isSelected ? AppTheme.fogWhite : AppTheme.mutedTaupe, fontSize: 14)),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // TITLE INPUT
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(color: AppTheme.deepTaupe, borderRadius: BorderRadius.circular(20)),
                child: TextField(
                  controller: _titleController,
                  style: GoogleFonts.antonio(color: AppTheme.fogWhite, fontSize: 24),
                  cursorColor: AppTheme.fogWhite,
                  decoration: InputDecoration(
                    hintText: "Title",
                    hintStyle: GoogleFonts.antonio(color: AppTheme.fogWhite.withOpacity(0.5), fontSize: 24),
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // CONTENT INPUT
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: AppTheme.deepTaupe, borderRadius: BorderRadius.circular(20)),
                  child: TextField(
                    controller: _contentController,
                    expands: true,
                    maxLines: null,
                    textAlignVertical: TextAlignVertical.top,
                    cursorColor: AppTheme.fogWhite,
                    style: GoogleFonts.beiruti(color: AppTheme.fogWhite, fontSize: 16, height: 1.5),
                    decoration: InputDecoration(
                      hintText: "Write something here...",
                      hintStyle: GoogleFonts.beiruti(color: AppTheme.mutedTaupe, fontSize: 14),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // FOOTER LINE
              Container(
                width: 50,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFCD1C18),
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [BoxShadow(color: const Color(0xFFCD1C18).withOpacity(0.5), blurRadius: 6)],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}