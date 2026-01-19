class TimeTableEntry {
  final String id;
  final String title;
  final String time; // e.g. "08:00 - 09:00"
  final String day;  // e.g. "Monday", "Wednesday"

  TimeTableEntry({
    required this.id,
    required this.title,
    required this.time,
    required this.day,
  });
}