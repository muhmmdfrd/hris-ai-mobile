import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hris_ai/modules/feedback/bloc/feedback_bloc.dart';
import 'package:hris_ai/modules/feedback/bloc/feedback_event.dart';
import 'package:hris_ai/modules/feedback/bloc/feedback_state.dart';

class FeedbackScreen extends StatelessWidget {
  FeedbackScreen({Key? key}) : super(key: key);

  final TextEditingController _feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feedback')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Enter your feedback:', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            TextField(
              controller: _feedbackController,
              maxLines: 5,
              decoration: InputDecoration(border: OutlineInputBorder(), hintText: 'Write your feedback here...'),
            ),
            const SizedBox(height: 20),
            BlocConsumer<FeedbackBloc, FeedbackState>(
              listener: (context, state) {
                if (state is FeedbackSubmitted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Feedback sent successfully!')));
                  _feedbackController.clear();
                } else if (state is FeedbackError) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${state.error}')));
                }
              },
              builder: (context, state) {
                if (state is FeedbackSubmitting) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ElevatedButton(
                  onPressed: () {
                    final feedbackText = _feedbackController.text.trim();
                    if (feedbackText.isNotEmpty) {
                      context.read<FeedbackBloc>().add(SubmitFeedback(feedbackText));
                    } else {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(const SnackBar(content: Text('Feedback cannot be empty')));
                    }
                  },
                  child: const Text('Send Feedback'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
