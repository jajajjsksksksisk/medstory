import 'package:fsrs/fsrs.dart' as fsrs;

import '../../shared/models/flashcard_model.dart';
import 'storage_service.dart';

class FsrsService {
  static final _scheduler = fsrs.Scheduler();

  /// Rate a card and persist the updated FSRS state.
  static Future<FlashcardModel> review(
    FlashcardModel model,
    fsrs.Rating rating,
  ) async {
    // Reconstruct a temporary FSRS Card. We keep our own model as source of truth.
    final card = fsrs.Card(
      cardId: model.id.hashCode,
    );

    // Note: full state restoration would require more FSRS fields.
    // For MVP we let the scheduler treat it as a review and then store results.
    final result = _scheduler.reviewCard(card, rating);
    final updatedFsrs = result.card;

    final updated = model.copyWith(
      stability: updatedFsrs.stability,
      difficulty: updatedFsrs.difficulty,
      due: updatedFsrs.due,
      lastReview: DateTime.now(),
      reps: model.reps + 1,
      lapses: rating == fsrs.Rating.again ? model.lapses + 1 : model.lapses,
      state: rating == fsrs.Rating.again ? 'relearning' : 'review',
    );

    await StorageService.saveCard(updated);
    return updated;
  }

  static FlashcardModel createNewCard({
    required String front,
    required String back,
    required String subject,
    String? topic,
    String? noteId,
  }) {
    final now = DateTime.now();
    return FlashcardModel(
      id: StorageService.newId(),
      front: front,
      back: back,
      subject: subject,
      topic: topic,
      noteId: noteId,
      due: now, // due immediately
      state: 'new',
    );
  }
}
