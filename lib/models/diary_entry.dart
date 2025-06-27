class DiaryEntry {
  final String id;
  final String title;
  final String content;
  final DateTime date;

  DiaryEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
  });

  // Convert a DiaryEntry to a Map for storage (e.g., in a database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date.toIso8601String(),
    };
  }

  // Create a DiaryEntry from a Map
  factory DiaryEntry.fromMap(Map<String, dynamic> map) {
    return DiaryEntry(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      date: DateTime.parse(map['date']),
    );
  }
}