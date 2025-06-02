abstract class FeedbackState {}

class FeedbackInitial extends FeedbackState {}

class FeedbackSubmitting extends FeedbackState {}

class FeedbackSubmitted extends FeedbackState {}

class FeedbackError extends FeedbackState {
  final String error;

  FeedbackError(this.error);
}
