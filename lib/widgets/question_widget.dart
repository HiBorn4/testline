import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import './option_widget.dart';

class QuestionWidget extends StatefulWidget {
  final dynamic question;
  final AnimationController slideController;

  const QuestionWidget({
    Key? key,
    required this.question,
    required this.slideController,
  }) : super(key: key);

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    
    return Consumer<QuizProvider>(
      builder: (context, quizProvider, child) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(size.width * 0.06),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: size.height * 0.1),
                // Progress Bar
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(size.width * 0.025),
                    gradient: LinearGradient(
                      colors: [Colors.purple.withOpacity(0.3), Colors.blue.withOpacity(0.3)],
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(size.width * 0.025),
                    child: LinearProgressIndicator(
                      value: quizProvider.progress,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      minHeight: size.height * 0.015,
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                // Question Number
                Text(
                  'Question ${quizProvider.currentQuestionIndex + 1}',
                  style: TextStyle(
                    fontSize: size.width * 0.045,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                // Question Text
                ShaderMask(
                  shaderCallback: (bounds) {
                    return LinearGradient(
                      colors: [Colors.white, Colors.white70],
                    ).createShader(bounds);
                  },
                  child: Text(
                    widget.question.description,
                    style: TextStyle(
                      fontSize: size.width * 0.06,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.04),
                // Options
                ...widget.question.options.asMap().entries.map((entry) {
                  return OptionWidget(
                    option: entry.value,
                    index: entry.key,
                    question: widget.question,
                    slideController: widget.slideController,
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }
}