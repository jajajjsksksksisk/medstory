/// Simple model that wraps FSRS Card with medical content.
class FlashcardModel {
  final String id;
  final String front;
  final String back;
  final String? subject;
  final String? topic;
  final List<String> tags;

  // FSRS state will be stored separately or embedded
  final double? stability;
  final double? difficulty;
  final DateTime? due;
  final DateTime? lastReview;

  const FlashcardModel({
    required this.id,
    required this.front,
    required this.back,
    this.subject,
    this.topic,
    this.tags = const [],
    this.stability,
    this.difficulty,
    this.due,
    this.lastReview,
  });

  FlashcardModel copyWith({
    String? id,
    String? front,
    String? back,
    String? subject,
    String? topic,
    List<String>? tags,
    double? stability,
    double? difficulty,
    DateTime? due,
    DateTime? lastReview,
  }) {
    return FlashcardModel(
      id: id ?? this.id,
      front: front ?? this.front,
      back: back ?? this.back,
      subject: subject ?? this.subject,
      topic: topic ?? this.topic,
      tags: tags ?? this.tags,
      stability: stability ?? this.stability,
      difficulty: difficulty ?? this.difficulty,
      due: due ?? this.due,
      lastReview: lastReview ?? this.lastReview,
    );
  }
}
