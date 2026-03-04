class JournalEntry {
  final String id;
  final String user_id;
  final String title;
  final String content;
  final String category;
  final DateTime timestamp;

  JournalEntry({
    required this.id,
    required this.user_id,
    required this.title,
    required this.content,
    required this.category,
    required this.timestamp,
  });

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
        id: json['id']?.toString() ?? '',
      user_id: json['userId']?.toString() ?? '',      
      title: json['title'] ?? 'Untitled',
      content: json['entry'] ?? '',
      category: json['category'] ?? 'Personal', 
      timestamp: json['timeStamp']!= null 
          ? DateTime.tryParse(json['timeStamp'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}