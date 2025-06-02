import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hris_ai/modules/feedback/bloc/feedback_event.dart';
import 'package:hris_ai/modules/feedback/bloc/feedback_state.dart';

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  FeedbackBloc() : super(FeedbackInitial()) {
    on<SubmitFeedback>(_onSubmitFeedback);
  }

  Future<void> _onSubmitFeedback(SubmitFeedback event, Emitter<FeedbackState> emit) async {
    emit(FeedbackSubmitting());
    try {
      await Future.delayed(Duration(seconds: 2));
      emit(FeedbackSubmitted());
    } catch (e) {
      emit(FeedbackError(e.toString()));
    }
  }
}
