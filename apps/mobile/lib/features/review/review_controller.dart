import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nihongo/core/sample_data.dart';

enum Grade { again, hard, good, easy }

class ReviewState {
  const new({required this.reviewed, required this.revealed});

  final int reviewed;
  final bool revealed;

  static const dailyLimit = 15;

  ReviewCard get card => sampleCards[reviewed % sampleCards.length];
  int get left => dailyLimit - (reviewed % dailyLimit);
}

final reviewProvider = NotifierProvider<ReviewController, ReviewState>(
  ReviewController.new,
);

/// Placeholder for the FSRS scheduler (Phase 5). Grades only advance the deck.
class ReviewController extends Notifier<ReviewState> {
  @override
  ReviewState build() => const ReviewState(reviewed: 0, revealed: false);

  void reveal() =>
      state = ReviewState(reviewed: state.reviewed, revealed: true);

  void grade(Grade grade) =>
      state = ReviewState(reviewed: state.reviewed + 1, revealed: false);
}
