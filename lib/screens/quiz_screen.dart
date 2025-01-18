import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../providers/quiz_provider.dart';
import '../widgets/question_widget.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  late AnimationController _slideController;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  Widget _buildLoadingState(Size size) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.network(
            'https://assets2.lottiefiles.com/packages/lf20_szviypry.json',
            width: size.width * 0.5,
            height: size.width * 0.5,
          ),
          SizedBox(height: size.height * 0.02),
          ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                colors: [Colors.purple, Colors.blue, Colors.green],
              ).createShader(bounds);
            },
            child: Text(
              'Preparing Your Adventure...',
              style: TextStyle(
                fontSize: size.width * 0.05,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error, Size size) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.network(
            'https://assets3.lottiefiles.com/packages/lf20_error.json',
            width: size.width * 0.5,
            height: size.width * 0.5,
          ),
          Text(
            'Oops! Something went wrong!',
            style: TextStyle(
              fontSize: size.width * 0.06,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: size.height * 0.02),
          Text(
            error,
            style: TextStyle(
              fontSize: size.width * 0.04,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: AnimatedTextKit(
          animatedTexts: [
            WavyAnimatedText(
              'Quiz Time!',
              textStyle: TextStyle(
                fontSize: size.width * 0.07,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
          isRepeatingAnimation: true,
        ),
        centerTitle: true,
      ),
      body: Container(
        height: size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A237E),
              Color(0xFF3949AB),
              Color(0xFF3F51B5),
            ],
          ),
        ),
        child: Consumer<QuizProvider>(
          builder: (context, quizProvider, _) {
            if (quizProvider.isLoading) {
              return _buildLoadingState(size);
            }

            if (quizProvider.error != null) {
              return _buildErrorState(quizProvider.error!, size);
            }

            if (quizProvider.isQuizFinished) {
              return ResultScreen(
                quizProvider: quizProvider,
              );
            }

            final question = quizProvider.currentQuestion;
            if (question == null) {
              return Center(
                child: Text(
                  'No quests available.',
                  style: TextStyle(
                    fontSize: size.width * 0.05,
                    color: Colors.white,
                  ),
                ),
              );
            }

            return QuestionWidget(
              question: question,
              slideController: _slideController,
            );
          },
        ),
      ),
    );
  }
}