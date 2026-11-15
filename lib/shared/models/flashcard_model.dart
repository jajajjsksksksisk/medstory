class FlashcardModel {
  final String id;
  final String front;
  final String back;
  final String subject;
  final String? topic;
  final String? noteId;
  final List<String> tags;

  // FSRS fields
  final double stability;
  final double difficulty;
  final DateTime due;
  final DateTime? lastReview;
  final int reps;
  final int lapses;
  final String state; // new, learning, review, relearning

  const FlashcardModel({
    required this.id,
    required this.front,
    required this.back,
    required this.subject,
    this.topic,
    this.noteId,
    this.tags = const [],
    this.stability = 0,
    this.difficulty = 0,
    required this.due,
    this.lastReview,
    this.reps = 0,
    this.lapses = 0,
    this.state = 'new',
  });

  bool get isDue => due.isBefore(DateTime.now()) || due.isAtSameMomentAs(DateTime.now());

  Map<String, dynamic> toMap() => {
        'id': id,
        'front': front,
        'back': back,
        'subject': subject,
        'topic': topic,
        'noteId': noteId,
        'tags': tags,
        'stability': stability,
        'difficulty': difficulty,
        'due': due.toIso8601String(),
        'lastReview': lastReview?.toIso8601String(),
        'reps': reps,
        'lapses': lapses,
        'state': state,
      };

  factory FlashcardModel.fromMap(Map<String, dynamic> map) => FlashcardModel(
        id: map['id'] as String,
        front: map['front'] as String,
        back: map['back'] as String,
        subject: map['subject'] as String,
        topic: map['topic'] as String?,
        noteId: map['noteId'] as String?,
        tags: List<String>.from(map['tags'] ?? []),
        stability: (map['stability'] as num?)?.toDouble() ?? 0,
        difficulty: (map['difficulty'] as num?)?.toDouble() ?? 0,
        due: DateTime.parse(map['due'] as String),
        lastReview: map['lastReview'] != null
            ? DateTime.parse(map['lastReview'] as String)
            : null,
        reps: map['reps'] as int? ?? 0,
        lapses: map['lapses'] as int? ?? 0,
        state: map['state'] as String? ?? 'new',
      );

  FlashcardModel copyWith({
    String? id,
    String? front,
    String? back,
    String? subject,
    String? topic,
    String? noteId,
    List<String>? tags,
    double? stability,
    double? difficulty,
    DateTime? due,
    DateTime? lastReview,
    int? reps,
    int? lapses,
    String? state,
  }) {
    return FlashcardModel(
      id: id ?? this.id,
      front: front ?? this.front,
      back: back ?? this.back,
      subject: subject ?? this.subject,
      topic: topic ?? this.topic,
      noteId: noteId ?? this.noteId,
      tags: tags ?? this.tags,
      stability: stability ?? this.stability,
      difficulty: difficulty ?? this.difficulty,
      due: due ?? this.due,
      lastReview: lastReview ?? this.lastReview,
      reps: reps ?? this.reps,
      lapses: lapses ?? this.lapses,
      state: state ?? this.state,
    );
  }
}
