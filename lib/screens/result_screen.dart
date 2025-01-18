import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:confetti/confetti.dart';
import '../providers/quiz_provider.dart';

class ResultScreen extends StatefulWidget {
  final QuizProvider quizProvider;

  const ResultScreen({
    Key? key,
    required this.quizProvider,
  }) : super(key: key);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> with TickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _bounceController;
  late Animation<double> _scaleAnimation;
  late AnimationController _scaleController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: Duration(seconds: 3));
    _bounceController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _scaleController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );
    
    // Start animations when screen is loaded
    _confettiController.play();
    _scaleController.forward();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _bounceController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  Widget _buildRestartButton(Size size) {
    return AnimatedBuilder(
      animation: _bounceController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _bounceController.value * 10),
          child: ElevatedButton.icon(
            onPressed: () {
              widget.quizProvider.restartQuiz();
            },
            icon: Icon(Icons.replay, color: Colors.white),
            label: Text(
              'Start New Quest',
              style: TextStyle(
                fontSize: size.width * 0.045,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.08,
                vertical: size.height * 0.02,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(size.width * 0.08),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Stack(
      children: [
        ConfettiWidget(
          confettiController: _confettiController,
          blastDirection: -pi / 2,
          emissionFrequency: 0.05,
          numberOfParticles: 20,
          maxBlastForce: 100,
          minBlastForce: 80,
          gravity: 0.2,
        ),
        Center(
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Card(
              elevation: 20,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(size.width * 0.05),
              ),
              child: Container(
                width: size.width * 0.85,
                padding: EdgeInsets.all(size.width * 0.08),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(size.width * 0.05),
                  gradient: LinearGradient(
                    colors: [Colors.purple, Colors.blue],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset(
                      'assets/trophy.json',
                      width: size.width * 0.4,
                      height: size.width * 0.4,
                    ),
                    ShaderMask(
                      shaderCallback: (bounds) {
                        return LinearGradient(
                          colors: [Colors.yellow, Colors.orange],
                        ).createShader(bounds);
                      },
                      child: Text(
                        'Quest Complete!',
                        style: TextStyle(
                          fontSize: size.width * 0.08,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    AnimatedTextKit(
                      animatedTexts: [
                        TyperAnimatedText(
                          'Final Score: ${widget.quizProvider.score}',
                          textStyle: TextStyle(
                            fontSize: size.width * 0.06,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.04),
                    _buildRestartButton(size),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}