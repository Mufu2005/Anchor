import 'package:anchor/core/services/encryption_service.dart';
import 'package:anchor/core/services/online_db_service.dart';
import 'package:anchor/features/journal/pages/JournalScannerPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../models/journal_model.dart';
import '../widgets/journal_entry_card.dart';
import 'journal_editor_page.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  // --- 1. DATA & STATE ---
  final OnlineDbService _db = OnlineDbService();
  List<JournalEntry> _entries = [];
  bool _isLoading = true;
  String _selectedCategory = "All";

  final List<String> _categories = [
    "All",
    "Personal",
    "Work",
    "Ideas",
    "Health",
    "Study",
  ];

  @override
  void initState() {
    super.initState();
    _fetchJournals();
  }

  // --- 2. LOAD & DECRYPT DATA ---
  Future<void> _fetchJournals() async {
    // Ensure key is loaded from hardware storage first
    await EncryptionService().loadKeyFromStorage();

    // Fetch all entries for this user from DB
    // Note: Ensure you have a getJournals() method in your OnlineDbService
    final List<JournalEntry> data = await _db.getEntries();

    if (mounted) {
      setState(() {
        _entries = data;
        _isLoading = false;
      });
    }
  }

  // --- 3. DELETE ENTRY ---
  void _deleteEntry(String id) async {
    HapticFeedback.mediumImpact();
    setState(() {
      _entries.removeWhere((e) => e.id == id);
    });
    await _db.deleteEntry(id);
  }

  @override
  Widget build(BuildContext context) {
    // Filter logic remains client-side for speed
    final filteredEntries = _selectedCategory == "All"
        ? _entries
        : _entries.where((e) => e.category == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: AppTheme.voidBlack,
      body: SafeArea(
        child: Column(
          children: [
            // --- HEADER ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    "JOURNAL",
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
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: AppTheme.mutedTaupe,
                          size: 30,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () async {
                              HapticFeedback.lightImpact();
                              // Navigate to the Scanner
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const JournalScannerPage(),
                                ),
                              );
                              // After scanning and returning, refresh the list to show the new entry
                              _fetchJournals();
                            },
                            icon: const Icon(
                              Icons.qr_code_scanner_rounded,
                              color: AppTheme.mutedTaupe,
                              size: 28,
                            ),
                          ),
                          IconButton(
                            onPressed: () => _navigateToEditor(context),
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
                ],
              ),
            ),

            // --- LIST BUILDER ---
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.red),
                    )
                  : filteredEntries.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: filteredEntries.length,
                      itemBuilder: (context, index) {
                        final entry = filteredEntries[index];

                        // DECRYPTING ON THE FLY
                        // If decryption fails, it returns a placeholder
                        final decryptedTitle = EncryptionService().decryptData(
                          entry.title,
                        );
                        final decryptedContent = EncryptionService()
                            .decryptData(entry.content.toString());

                        return JournalEntryCard(
                          id: entry.id,
                          title: decryptedTitle,
                          content: decryptedContent,
                          date: DateFormat(
                            'HH:mm dd MMM yyyy',
                          ).format(entry.timestamp).toUpperCase(),
                          isExpanded: index == 0,
                          onEdit: () =>
                              _navigateToEditor(context, entry: entry),
                          onDelete: () => _deleteEntry(
                            entry.id,
                          ), // Ensure your widget supports onDelete
                        );
                      },
                    ),
            ),

            // --- CATEGORY SELECTOR ---
            _buildCategorySelector(),
          ],
        ),
      ),
    );
  }

  // --- REUSABLE WIDGETS ---

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        "NO ENCRYPTED MEMORIES YET",
        style: GoogleFonts.antonio(color: AppTheme.mutedTaupe, fontSize: 16),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Padding(
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
            value: _selectedCategory,
            dropdownColor: AppTheme.deepTaupe,
            borderRadius: BorderRadius.circular(20),
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: AppTheme.mutedTaupe,
            ),
            style: GoogleFonts.antonio(color: AppTheme.fogWhite, fontSize: 18),
            isExpanded: true,
            alignment: Alignment.center,
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() => _selectedCategory = newValue);
                HapticFeedback.lightImpact();
              }
            },
            items: _categories.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Center(child: Text(value)),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  // --- NAVIGATION ---
  void _navigateToEditor(BuildContext context, {JournalEntry? entry}) async {
    HapticFeedback.lightImpact();

    // We 'await' the result. When user saves and pops, we refresh the list.
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JournalEditorPage(
          initialTitle: entry != null
              ? EncryptionService().decryptData(entry.title)
              : null,
          initialContent: entry != null
              ? EncryptionService().decryptData(entry.content)
              : null,
          initialCategory: entry?.category,
          entryId: entry?.id, // Pass ID if editing
        ),
      ),
    );

    _fetchJournals(); // Refresh data when coming back
  }
}
