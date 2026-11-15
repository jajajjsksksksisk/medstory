class NoteModel {
  final String id;
  final String title;
  final String originalText;
  final String summary;
  final String? lastDayNotes; // ultra-short high-yield for final revision
  final String subject;
  final String? topic;
  final DateTime createdAt;
  final List<String> flashcardIds;
  final List<String> storyIds;

  const NoteModel({
    required this.id,
    required this.title,
    required this.originalText,
    required this.summary,
    this.lastDayNotes,
    required this.subject,
    this.topic,
    required this.createdAt,
    this.flashcardIds = const [],
    this.storyIds = const [],
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'originalText': originalText,
        'summary': summary,
        'lastDayNotes': lastDayNotes,
        'subject': subject,
        'topic': topic,
        'createdAt': createdAt.toIso8601String(),
        'flashcardIds': flashcardIds,
        'storyIds': storyIds,
      };

  factory NoteModel.fromMap(Map<String, dynamic> map) => NoteModel(
        id: map['id'] as String,
        title: map['title'] as String,
        originalText: map['originalText'] as String,
        summary: map['summary'] as String,
        lastDayNotes: map['lastDayNotes'] as String?,
        subject: map['subject'] as String,
        topic: map['topic'] as String?,
        createdAt: DateTime.parse(map['createdAt'] as String),
        flashcardIds: List<String>.from(map['flashcardIds'] ?? []),
        storyIds: List<String>.from(map['storyIds'] ?? []),
      );
}
