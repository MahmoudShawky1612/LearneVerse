import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/utils/snackber_util.dart';

import '../../data/models/question_model.dart';
import '../../data/models/quiz_model.dart';
import '../../logic/cubit/quiz_cubit.dart';

enum QuestionType { SINGLE, MULTI, TRUE_FALSE }

class QuizTakingScreen extends StatefulWidget {
  final Quiz quiz;
  final int communityId;

  const QuizTakingScreen(
      {Key? key, required this.quiz, required this.communityId})
      : super(key: key);

  @override
  State<QuizTakingScreen> createState() => _QuizTakingScreenState();
}

class _QuizTakingScreenState extends State<QuizTakingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  final Map<int, dynamic> _answers = {};
  bool _isFinished = false;
  int _score = 0;
  int _totalPoints = 0;
  int _currentQuestionIndex = 0;

  // Timer related variables
  late Timer _timer;
  late DateTime _startTime;
  Duration _elapsedTime = Duration.zero;

  late AnimationController _progressController;
  late AnimationController _cardController;
  late AnimationController _resultController;

  @override
  void initState() {
    super.initState();
    _calculateTotalPoints();
    _startTime = DateTime.now();
    _startTimer();

    _progressController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _cardController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _resultController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _cardController.forward();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isFinished) {
        setState(() {
          _elapsedTime = DateTime.now().difference(_startTime);
        });
      }
    });
  }

  void _calculateTotalPoints() {
    _totalPoints = widget.quiz.quizQuestions.fold(
      0,
      (sum, question) => sum + question.points,
    );
  }

  void _submitAnswer(int questionId, dynamic answer, QuestionType type) {
    setState(() {
      _answers[questionId] = answer;
    });

    // Animate progress
    _progressController.animateTo(
      _answers.length / widget.quiz.quizQuestions.length,
    );
  }

  bool _isAnswerCorrect(QuizQuestion question) {
    final userAnswer = _answers[question.questionId];
    final correctAnswers = question.question.answer;

    if (correctAnswers.length == 1) {
      return userAnswer == correctAnswers.first;
    } else {
      if (userAnswer is List<String>) {
        return userAnswer.toSet().containsAll(correctAnswers.toSet()) &&
            correctAnswers.toSet().containsAll(userAnswer.toSet());
      }
      return false;
    }
  }

  void _finishQuiz() async {
    _timer.cancel();
    int score = 0;
    for (var question in widget.quiz.quizQuestions) {
      if (_isAnswerCorrect(question)) {
        score += question.points;
      }
    }

    setState(() {
      _score = score;
      _isFinished = true;
    });

    _resultController.forward();

    // Submit quiz results to API
    try {
      final endTime = DateTime.now();
      await context.read<QuizCubit>().submitQuiz(
            widget.quiz.id,
            _startTime,
            endTime,
            score,
          );

      if (context.mounted) {
        SnackBarUtils.showSuccessSnackBar(context,
            message: 'Quiz submitted successfully!');
      }
    } catch (e) {
      if (context.mounted) {
        SnackBarUtils.showErrorSnackBar(context,
            message: 'Failed to submit quiz results: $e');
      }
    }
  }

  QuestionType _getQuestionType(QuizQuestion question) {
    if (question.question.options.length == 2 &&
        question.question.options.contains('True') &&
        question.question.options.contains('False')) {
      return QuestionType.TRUE_FALSE;
    } else if (question.question.answer.length > 1) {
      return QuestionType.MULTI;
    } else {
      return QuestionType.SINGLE;
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  String formatRemainingDuration(Duration total, Duration elapsed) {
    final remaining = total - elapsed;
    final clamped = remaining.isNegative ? Duration.zero : remaining;
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(clamped.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(clamped.inSeconds.remainder(60));
    return "${twoDigits(clamped.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    if (_isFinished) {
      return _buildResultsScreen();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildModernAppBar(),
      body: Column(
        children: [
          _buildProgressSection(),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  _currentQuestionIndex = index;
                });
              },
              itemCount: widget.quiz.quizQuestions.length,
              itemBuilder: (context, index) {
                final question = widget.quiz.quizQuestions[index];
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.3, 0),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _cardController,
                    curve: Curves.easeOutCubic,
                  )),
                  child: _buildQuestionCard(question, index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildModernAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: Container(
        margin: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => _showExitDialog(),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.quiz.name,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            _formatDuration(_elapsedTime),
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      actions: [
        Container(
          margin: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: TextButton(
            onPressed: _showFinishDialog,
            child: Text(
              'Finish',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Exit Quiz?'),
          content: const Text(
              'Are you sure you want to exit? Your progress will be lost.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Exit'),
            ),
          ],
        );
      },
    );
  }

  void _showFinishDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Finish Quiz?'),
          content: Text(
              'You have answered ${_answers.length} out of ${widget.quiz.quizQuestions.length} questions. Are you sure you want to finish?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _finishQuiz();
              },
              child: const Text('Finish'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProgressSection() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_currentQuestionIndex + 1} of ${widget.quiz.quizQuestions.length}',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      size: 16.w,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      formatRemainingDuration(
                          Duration(minutes: widget.quiz.duration),
                          _elapsedTime),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          AnimatedBuilder(
            animation: _progressController,
            builder: (context, child) {
              return Container(
                height: 8.h,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: (_currentQuestionIndex + 1) /
                      widget.quiz.quizQuestions.length,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColor.withOpacity(0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(QuizQuestion quizQuestion, int index) {
    final questionType = _getQuestionType(quizQuestion);

    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              'Question ${index + 1}',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quizQuestion.question.questionHeader,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 24.h),
                _buildQuestionOptions(quizQuestion, questionType),
              ],
            ),
          ),
          SizedBox(height: 32.h),
          _buildNavigationButtons(index),
        ],
      ),
    );
  }

  Widget _buildQuestionOptions(QuizQuestion quizQuestion, QuestionType type) {
    switch (type) {
      case QuestionType.TRUE_FALSE:
        return _buildTrueFalseOptions(quizQuestion);
      case QuestionType.MULTI:
        return _buildMultiChoiceOptions(quizQuestion);
      case QuestionType.SINGLE:
      default:
        return _buildSingleChoiceOptions(quizQuestion);
    }
  }

  Widget _buildSingleChoiceOptions(QuizQuestion quizQuestion) {
    return Column(
      children: quizQuestion.question.options.map((option) {
        final isSelected = _answers[quizQuestion.questionId] == option;
        return GestureDetector(
          onTap: () => _submitAnswer(
              quizQuestion.questionId, option, QuestionType.SINGLE),
          child: Container(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).primaryColor.withOpacity(0.1)
                  : Colors.grey[50],
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.grey[200]!,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 24.w,
                  height: 24.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.grey[400]!,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check,
                          size: 16.w,
                          color: Colors.white,
                        )
                      : null,
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Text(
                    option,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMultiChoiceOptions(QuizQuestion quizQuestion) {
    final selectedAnswers =
        _answers[quizQuestion.questionId] as List<String>? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select all that apply:',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 16.h),
        ...quizQuestion.question.options.map((option) {
          final isSelected = selectedAnswers.contains(option);
          return GestureDetector(
            onTap: () {
              List<String> newAnswers = List.from(selectedAnswers);
              if (isSelected) {
                newAnswers.remove(option);
              } else {
                newAnswers.add(option);
              }
              _submitAnswer(
                  quizQuestion.questionId, newAnswers, QuestionType.MULTI);
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).primaryColor.withOpacity(0.1)
                    : Colors.grey[50],
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.grey[200]!,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 24.w,
                    height: 24.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.r),
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.transparent,
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Colors.grey[400]!,
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? Icon(
                            Icons.check,
                            size: 16.w,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Text(
                      option,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildTrueFalseOptions(QuizQuestion quizQuestion) {
    return Row(
      children: [
        Expanded(
          child: _buildTrueFalseButton(
            quizQuestion,
            'True',
            Icons.check_circle_outline,
            Colors.green,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: _buildTrueFalseButton(
            quizQuestion,
            'False',
            Icons.cancel_outlined,
            Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildTrueFalseButton(
    QuizQuestion quizQuestion,
    String value,
    IconData icon,
    Color color,
  ) {
    final isSelected = _answers[quizQuestion.questionId] == value;

    return GestureDetector(
      onTap: () => _submitAnswer(
          quizQuestion.questionId, value, QuestionType.TRUE_FALSE),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.grey[50],
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? color : Colors.grey[200]!,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32.w,
              color: isSelected ? color : Colors.grey[400],
            ),
            SizedBox(height: 8.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: isSelected ? color : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButtons(int currentIndex) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (currentIndex < widget.quiz.quizQuestions.length - 1)
          _buildNavButton(
            'Next',
            Icons.arrow_forward_ios,
            true,
            () {
              _cardController.reset();
              _cardController.forward();
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
          ),
      ],
    );
  }

  Widget _buildNavButton(
      String text, IconData icon, bool isNext, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor.withOpacity(0.8),
            Theme.of(context).primaryColor,
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 8.w),
            Icon(icon, size: 18.w, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsScreen() {
    final percentage = (_score / _totalPoints) * 100;
    final correctAnswers =
        widget.quiz.quizQuestions.where((q) => _isAnswerCorrect(q)).length;
    final incorrectAnswers = widget.quiz.quizQuestions.length - correctAnswers;

    String grade;
    Color gradeColor;
    String gradeDescription;

    if (percentage >= 90) {
      grade = 'A+';
      gradeColor = Colors.green;
      gradeDescription = 'Outstanding!';
    } else if (percentage >= 80) {
      grade = 'A';
      gradeColor = Colors.blue;
      gradeDescription = 'Excellent!';
    } else if (percentage >= 70) {
      grade = 'B';
      gradeColor = Colors.orange;
      gradeDescription = 'Good Job!';
    } else if (percentage >= 60) {
      grade = 'C';
      gradeColor = Colors.deepOrange;
      gradeDescription = 'Keep Trying!';
    } else {
      grade = 'F';
      gradeColor = Colors.red;
      gradeDescription = 'Need Improvement';
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Quiz Results'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const SizedBox(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          children: [
            // Header Section
            FadeTransition(
              opacity: _resultController,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, -0.3),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: _resultController,
                  curve: Curves.easeOutBack,
                )),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(32.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        gradeColor.withOpacity(0.1),
                        gradeColor.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24.r),
                    border: Border.all(
                      color: gradeColor.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 100.w,
                        height: 100.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              gradeColor,
                              gradeColor.withOpacity(0.7),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: gradeColor.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.emoji_events,
                          size: 50.w,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Text(
                        'Quiz Completed!',
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        gradeDescription,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: gradeColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 32.h),

            // Stats Cards
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Grade',
                    grade,
                    gradeColor,
                    Icons.school,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: _buildStatCard(
                    'Score',
                    '${percentage.toInt()}%',
                    gradeColor,
                    Icons.trending_up,
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Time',
                    _formatDuration(_elapsedTime),
                    Colors.blue,
                    Icons.timer,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: _buildStatCard(
                    'Points',
                    '$_score/$_totalPoints',
                    Colors.purple,
                    Icons.stars,
                  ),
                ),
              ],
            ),

            SizedBox(height: 32.h),

            // Detailed Results
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Detailed Results',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Column(
                    children: [
                      _buildResultItem(
                        'Correct Answers',
                        correctAnswers.toString(),
                        Colors.green,
                        Icons.check_circle,
                      ),
                      _buildResultItem(
                        'Incorrect Answers',
                        incorrectAnswers.toString(),
                        Colors.red,
                        Icons.cancel,
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  _buildResultItem(
                    'Total Questions',
                    widget.quiz.quizQuestions.length.toString(),
                    Colors.grey[600]!,
                    Icons.quiz,
                  ),
                ],
              ),
            ),

            SizedBox(height: 32.h),

            // Answer Review Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Answer Review',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  ...widget.quiz.quizQuestions.asMap().entries.map((entry) {
                    final index = entry.key;
                    final question = entry.value;
                    final isCorrect = _isAnswerCorrect(question);
                    final userAnswer = _answers[question.questionId];
                    final correctAnswer = question.question.answer;

                    return Container(
                      margin: EdgeInsets.only(bottom: 16.h),
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: isCorrect
                            ? Colors.green.withOpacity(0.05)
                            : Colors.red.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: isCorrect ? Colors.green : Colors.red,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: isCorrect ? Colors.green : Colors.red,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Text(
                                  'Q${index + 1}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Icon(
                                isCorrect ? Icons.check_circle : Icons.cancel,
                                color: isCorrect ? Colors.green : Colors.red,
                                size: 20.w,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                isCorrect ? 'Correct' : 'Incorrect',
                                style: TextStyle(
                                  color: isCorrect ? Colors.green : Colors.red,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${question.points} pts',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            question.question.questionHeader,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          if (userAnswer != null) ...[
                            Text(
                              'Your Answer: ${_formatAnswer(userAnswer)}',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: isCorrect ? Colors.green : Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 4.h),
                          ],
                          Text(
                            'Correct Answer: ${_formatAnswer(correctAnswer)}',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.green,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),

            SizedBox(height: 40.h),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.grey[600]!,
                          Colors.grey[700]!,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        shadowColor: Colors.blue,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      child: Text(
                        'Back to Quiz List',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24.w,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultItem(
      String title, String value, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              icon,
              color: color,
              size: 16.w,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _formatAnswer(dynamic answer) {
    if (answer is List) {
      return answer.join(', ');
    }
    return answer.toString();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _progressController.dispose();
    _cardController.dispose();
    _resultController.dispose();
    _timer.cancel();
    super.dispose();
  }
}
