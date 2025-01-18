import 'package:flutter/foundation.dart';
import '../models/quiz_model.dart';
import '../utils/api_service.dart';

class QuizProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  Quiz? _quiz;
  int _currentQuestionIndex = 0;
  double _score = 0.0;
  bool _isLoading = false;
  String? _error;
  Map<int, bool> _answeredQuestions = {};
  Map<int, int> _userAnswers = {};

  // Debug information
  bool get hasQuiz => _quiz != null;
  int get questionsCount => _quiz?.questions.length ?? 0;
  
  // Getters
  Quiz? get quiz => _quiz;
  int get currentQuestionIndex => _currentQuestionIndex;
  double get score => _score;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<int, bool> get answeredQuestions => _answeredQuestions;

  // Get user's answer for a specific question
  int? getUserAnswer(int questionId) {
    return _userAnswers[questionId];
  }

  // Progress related getters
  double get progress {
    if (_quiz == null || _quiz!.questions.isEmpty) return 0.0;
    return (_currentQuestionIndex + 1) / _quiz!.questions.length;
  }

  int get totalQuestions => _quiz?.questions.length ?? 0;
  int get answeredQuestionsCount => _answeredQuestions.length;
  int get remainingQuestions => totalQuestions - answeredQuestionsCount;
  
  double get scorePercentage {
    if (_quiz == null || totalQuestions == 0) return 0.0;
    return (_score / totalQuestions) * 100;
  }

  Question? get currentQuestion {
    if (_quiz == null || 
        _quiz!.questions.isEmpty || 
        _currentQuestionIndex >= _quiz!.questions.length) {
      print('DEBUG: Current question null check - Quiz: ${_quiz != null}, Questions empty: ${_quiz?.questions.isEmpty}, Index: $_currentQuestionIndex');
      return null;
    }
    return _quiz!.questions[_currentQuestionIndex];
  }

  bool get isQuizFinished {
    bool finished = _quiz != null && 
           _quiz!.questions.isNotEmpty && 
           answeredQuestionsCount >= _quiz!.questions.length;
    print('DEBUG: Quiz finished check - Quiz: ${_quiz != null}, Questions count: ${_quiz?.questions.length}, Answered count: $answeredQuestionsCount, Finished: $finished');
    return finished;
  }

  Future<void> loadQuiz() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final quizData = await _apiService.fetchQuizData();
      _quiz = Quiz.fromJson(quizData);
      _resetQuiz();
    } catch (e) {
      _error = e.toString();
      print('DEBUG: Error loading quiz - $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _resetQuiz() {
    _currentQuestionIndex = 0;
    _score = 0.0;
    _answeredQuestions.clear();
    _userAnswers.clear();
    print('DEBUG: Quiz reset - Index: $_currentQuestionIndex');
    notifyListeners();
  }

  bool isQuestionAnswered(int questionId) {
    return _answeredQuestions[questionId] ?? false;
  }

  void answerQuestion(int optionId) {
    final currentQ = currentQuestion;
    if (currentQ == null) {
      print('DEBUG: Cannot answer - current question is null');
      return;
    }

    if (isQuestionAnswered(currentQ.id)) {
      print('DEBUG: Question ${currentQ.id} already answered');
      return;
    }

    // Find the selected option
    final selectedOption = currentQ.options.firstWhere(
      (option) => option.id == optionId,
      orElse: () => Option(id: 0, description: '', isCorrect: false),
    );

    // Mark question as answered and store user's answer
    _answeredQuestions[currentQ.id] = true;
    _userAnswers[currentQ.id] = optionId;

    // Update score
    if (selectedOption.isCorrect) {
      _score += _quiz?.correctAnswerMarks ?? 1.0;
    } else {
      _score = _score - (_quiz?.negativeMarks ?? 0.0);
      // _score = _score < 0 ? 0 : _score;
    }

    notifyListeners();
  }

  void nextQuestion() {
    if (_quiz == null) {
      print('DEBUG: Cannot move to next - quiz is null');
      return;
    }
    
    if (_currentQuestionIndex >= _quiz!.questions.length - 1) {
      print('DEBUG: Cannot move to next - already at last question');
      return;
    }
    
    _currentQuestionIndex++;
    print('DEBUG: Moved to next question - new index: $_currentQuestionIndex');
    notifyListeners();
  }

  void goToQuestion(int index) {
    if (_quiz == null || index < 0 || index >= _quiz!.questions.length) {
      return;
    }
    _currentQuestionIndex = index;
    notifyListeners();
  }

  void restartQuiz() {
    if (_quiz == null) return;
    _resetQuiz();
  }

  bool canGoBack() => _currentQuestionIndex > 0;
  
  bool canGoForward() {
    if (_quiz == null) return false;
    return _currentQuestionIndex < (_quiz!.questions.length - 1);
  }

  void goToPreviousQuestion() {
    if (canGoBack()) {
      _currentQuestionIndex--;
      notifyListeners();
    }
  }

  String getProgressText() {
    if (_quiz == null) return 'No quiz loaded';
    return 'Question ${_currentQuestionIndex + 1} of ${_quiz!.questions.length}';
  }

  Question? getQuestionById(int questionId) {
    if (_quiz == null) return null;
    
    try {
      return _quiz!.questions.firstWhere(
        (q) => q.id == questionId,
      );
    } catch (_) {
      return null;
    }
  }
}
