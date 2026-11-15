class StoryModel {
  final String id;
  final String title;
  final String concept;
  final String storyText;
  final String subject;
  final String? topic;
  final String? noteId;
  final DateTime createdAt;

  const StoryModel({
    required this.id,
    required this.title,
    required this.concept,
    required this.storyText,
    required this.subject,
    this.topic,
    this.noteId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'concept': concept,
        'storyText': storyText,
        'subject': subject,
        'topic': topic,
        'noteId': noteId,
        'createdAt': createdAt.toIso8601String(),
      };

  factory StoryModel.fromMap(Map<String, dynamic> map) => StoryModel(
        id: map['id'] as String,
        title: map['title'] as String,
        concept: map['concept'] as String,
        storyText: map['storyText'] as String,
        subject: map['subject'] as String,
        topic: map['topic'] as String?,
        noteId: map['noteId'] as String?,
        createdAt: DateTime.parse(map['createdAt'] as String),
      );
}
