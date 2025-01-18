import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../providers/quiz_provider.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final padding = size.width * 0.05; // 5% padding
    final logoSize = isSmallScreen ? 60.0 : 80.0;
    final titleSize = isSmallScreen ? 24.0 : 32.0;
    final subtitleSize = isSmallScreen ? 16.0 : 18.0;
    final buttonPadding = isSmallScreen 
        ? const EdgeInsets.symmetric(horizontal: 30, vertical: 15)
        : const EdgeInsets.symmetric(horizontal: 40, vertical: 20);
    final statsSpacing = isSmallScreen ? 10.0 : 15.0;

    return Scaffold(
      body: Stack(
        children: [
          // Animated Background
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.rotate(
                angle: _controller.value * 2 * math.pi,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: SweepGradient(
                      colors: const [
                        Color(0xFF6B48FF),
                        Color(0xFF1E88E5),
                        Color(0xFF6B48FF),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                      transform: GradientRotation(_controller.value * 2 * math.pi),
                    ),
                  ),
                ),
              );
            },
          ),
          // Content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: size.height * 0.1),
                    // Logo/Title Container
                    Container(
                      width: min(size.width * 0.9, 500), // Max width of 500
                      padding: EdgeInsets.all(isSmallScreen ? 15 : 20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 15,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Trophy Icon
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                            ).createShader(bounds),
                            child: Icon(
                              Icons.emoji_events,
                              size: logoSize,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: isSmallScreen ? 15 : 20),
                          // Title
                          Text(
                            'QUIZ MASTER',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: titleSize,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF2C3E50),
                              letterSpacing: 2,
                              shadows: const [
                                Shadow(
                                  color: Colors.black26,
                                  offset: Offset(2, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Subtitle
                          Text(
                            'Test Your Knowledge!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: subtitleSize,
                              color: const Color(0xFF34495E),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.05),
                    // Start Button
                    MouseRegion(
                      onEnter: (_) => setState(() => _isHovering = true),
                      onExit: (_) => setState(() => _isHovering = false),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        transform: Matrix4.identity()
                          ..scale(_isHovering ? 1.1 : 1.0),
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<QuizProvider>().loadQuiz();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => QuizScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: buttonPadding,
                            backgroundColor: const Color(0xFF6B48FF),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: _isHovering ? 8 : 4,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.play_arrow, size: isSmallScreen ? 20 : 24),
                              SizedBox(width: isSmallScreen ? 6 : 8),
                              Text(
                                'START QUIZ',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 16 : 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    // Stats Container
                    Container(
                      width: min(size.width * 0.9, 500), // Max width of 500
                      padding: EdgeInsets.all(isSmallScreen ? 10 : 15),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: isSmallScreen
                          ? Column(
                              children: [
                                _buildStatItem(Icons.star, '0', 'Best Score', statsSpacing),
                                _buildDivider(true),
                                _buildStatItem(Icons.timer, '0', 'Quizzes', statsSpacing),
                                _buildDivider(true),
                                _buildStatItem(Icons.emoji_events, '0', 'Achievements', statsSpacing),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildStatItem(Icons.star, '0', 'Best Score', statsSpacing),
                                _buildDivider(false),
                                _buildStatItem(Icons.timer, '0', 'Quizzes', statsSpacing),
                                _buildDivider(false),
                                _buildStatItem(Icons.emoji_events, '0', 'Achievements', statsSpacing),
                              ],
                            ),
                    ),
                    SizedBox(height: size.height * 0.05),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label, double spacing) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacing, vertical: spacing / 2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFF6B48FF), size: 24),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF7F8C8D),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isHorizontal) {
    return Container(
      height: isHorizontal ? 1 : 40,
      width: isHorizontal ? double.infinity : 1,
      margin: EdgeInsets.symmetric(
        vertical: isHorizontal ? 10 : 0,
        horizontal: isHorizontal ? 0 : 10,
      ),
      color: Colors.grey.withOpacity(0.5),
    );
  }

  double min(double a, double b) => a < b ? a : b;
}