class JournalEntry {
  final String id;
  final String title;
  final String content;
  final DateTime date;
  final String category;

  JournalEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.category,
  });
}