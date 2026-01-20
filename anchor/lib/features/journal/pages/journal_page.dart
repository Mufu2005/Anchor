import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // Required for Date Formatting
import '../../../core/theme/app_theme.dart';
import '../models/journal_model.dart'; // Ensure this file exists
import '../widgets/journal_entry_card.dart';
import 'journal_editor_page.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  // --- 1. THE DATA (Simulating your Database) ---

  String _selectedCategory = "All";

  final List<String> _categories = [
    "All", 
    "Personal", 
    "Work", 
    "Ideas", 
    "Health",
    "study"
  ];

  final List<JournalEntry> _entries = [
    JournalEntry(
      id: '1',
      title: "Dinner with her",
      // Your long text example
      content: "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text...",
      date: DateTime.now(),
      category: "study",
    ),
    JournalEntry(
      id: '2',
      title: "Project Ideas",
      content: "Drafting the new UI for the Anchor app. Need to focus on the offline-first architecture...",
      date: DateTime.now().subtract(const Duration(days: 1)),
      category: "study",
    ),
    JournalEntry(
      id: '3',
      title: "Morning Routine",
      content: "Woke up early. Gym session was good. Need to buy more coffee beans.",
      date: DateTime.now().subtract(const Duration(days: 2)),
      category: "study",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredEntries = _selectedCategory == "All"
        ? _entries
        : _entries.where((e) => e.category == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: AppTheme.voidBlack,
      body: SafeArea(
        child: Column(
          children: [
            // --- 2. HEADER (Your Design) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // CENTER TITLE
                  Text(
                    "JOURNAL",
                    style: GoogleFonts.bangers(
                      color: AppTheme.fogWhite,
                      fontSize: 32,
                      letterSpacing: 1.0,
                    ),
                  ),

                  // BUTTONS LAYER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back Arrow
                      IconButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.mutedTaupe, size: 30),
                      ),

                      // Action Icons (Nudged Right)
                      Transform.translate(
                        offset: const Offset(8, 0), 
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Barcode Icon
                            IconButton(
                              onPressed: () => HapticFeedback.lightImpact(),
                              icon: Image.asset(
                                "assets/icons/product.png",
                                width: 35,
                                height: 35,
                                fit: BoxFit.contain,
                              ),
                            ),
                            
                            // Add Button (Connected to Editor)
                            IconButton(
                              onPressed: () => _navigateToEditor(context), // <--- CLICK TO ADD NEW
                              icon: const Icon(Icons.add, color: AppTheme.mutedTaupe, size: 30),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // --- 3. AUTOMATED LIST BUILDER ---
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _entries.length,
                itemBuilder: (context, index) {
                  final entry = filteredEntries[index];
                  
                  return JournalEntryCard(
                    title: entry.title,
                    content: entry.content,
                    // Formats date to: "08:00 21 JAN 2025"
                    date: DateFormat('HH:mm dd MMM yyyy').format(entry.date).toUpperCase(),
                    isExpanded: index == 0, // Auto-expand the first item only
                    // The Magic: Pass data to Editor automatically
                    onEdit: () {
                      _navigateToEditor(context, entry: entry);
                    },
                  );
                },
              ),
            ),

            // --- 4. FOOTER (Your Design) ---
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
                    value: _selectedCategory,
                    dropdownColor: AppTheme.deepTaupe,
                    borderRadius: BorderRadius.circular(20), // Round borders for popup
                    icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.mutedTaupe),
                    style: GoogleFonts.antonio(
                      color: AppTheme.fogWhite,
                      fontSize: 18,
                    ),
                    isExpanded: true, // Centers the text
                    alignment: Alignment.center, // Ensures text stays centered
                    
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedCategory = newValue;
                        });
                        HapticFeedback.lightImpact();
                      }
                    },
                    items: _categories.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Center(child: Text(value)), // Centers text in popup
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

  // --- SMART NAVIGATION HELPER ---
  void _navigateToEditor(BuildContext context, {JournalEntry? entry}) {
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JournalEditorPage(
          // If 'entry' is null, these will be null (Add Mode)
          // If 'entry' exists, these will be filled (Edit Mode)
          initialTitle: entry?.title,
          initialContent: entry?.content,
        ),
      ),
    );
  }
}