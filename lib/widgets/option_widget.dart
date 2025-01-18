
// option_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';

class OptionWidget extends StatefulWidget {
  final dynamic option;
  final int index;
  final dynamic question;
  final AnimationController slideController;

  const OptionWidget({
    Key? key,
    required this.option,
    required this.index,
    required this.question,
    required this.slideController,
  }) : super(key: key);

  @override
  State<OptionWidget> createState() => _OptionWidgetState();
}

class _OptionWidgetState extends State<OptionWidget> {
  void _handleOptionSelection(BuildContext context, QuizProvider quizProvider) async {
    // Answer the question first
    quizProvider.answerQuestion(widget.option.id);
    
    // Wait for 3 seconds
    await Future.delayed(const Duration(seconds: 2));
    
    // Check if the widget is still mounted before proceeding
    if (!context.mounted) return;
    
    // Move to next question if quiz is not finished
    if (!quizProvider.isQuizFinished) {
      quizProvider.nextQuestion();
      widget.slideController.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final quizProvider = Provider.of<QuizProvider>(context);
    
    final bool isAnswered = quizProvider.isQuestionAnswered(widget.question.id);
    final bool isCorrect = widget.option.isCorrect;
    final bool isSelected = quizProvider.getUserAnswer(widget.question.id) == widget.option.id;

    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + (widget.index * 100)),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(100 * (1 - value), 0),
          child: Opacity(
            opacity: value,
            child: Card(
              elevation: 8,
              margin: EdgeInsets.only(bottom: size.height * 0.02),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(size.width * 0.04),
              ),
              child: InkWell(
                onTap: isAnswered ? null : () => _handleOptionSelection(context, quizProvider),
                borderRadius: BorderRadius.circular(size.width * 0.04),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(size.width * 0.04),
                    gradient: LinearGradient(
                      colors: isAnswered
                          ? isSelected
                              ? isCorrect
                                  ? [Colors.green.shade200, Colors.green.shade400]
                                  : [Colors.red.shade200, Colors.red.shade400]
                              : isCorrect
                                  ? [Colors.green.shade100, Colors.green.shade300]
                                  : [Colors.white, Colors.white.withOpacity(0.9)]
                          : [Colors.white, Colors.white.withOpacity(0.9)],
                    ),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.05,
                      vertical: size.height * 0.015,
                    ),
                    title: Text(
                      widget.option.description,
                      style: TextStyle(
                        fontSize: size.width * 0.045,
                        color: isAnswered && (isSelected || isCorrect)
                            ? Colors.white
                            : Colors.black87,
                        fontWeight: isAnswered && (isSelected || isCorrect)
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    leading: Container(
                      width: size.width * 0.1,
                      height: size.width * 0.1,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: isAnswered && isSelected
                              ? isCorrect
                                  ? [Colors.green, Colors.green.shade700]
                                  : [Colors.red, Colors.red.shade700]
                              : [Colors.purple, Colors.blue],
                        ),
                      ),
                      child: Center(
                        child: isAnswered && (isSelected || isCorrect)
                            ? Icon(
                                isCorrect ? Icons.check : Icons.close,
                                color: Colors.white,
                                size: size.width * 0.06,
                              )
                            : Text(
                                String.fromCharCode(65 + widget.index),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: size.width * 0.045,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    trailing: isAnswered && (isSelected || isCorrect)
                        ? Icon(
                            isCorrect
                                ? Icons.check_circle
                                : Icons.cancel,
                            color: isCorrect
                                ? Colors.green.shade700
                                : Colors.red.shade700,
                            size: size.width * 0.06,
                          )
                        : null,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}