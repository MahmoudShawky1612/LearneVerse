import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/quiz_model.dart';
import '../../data/models/question_model.dart';
import '../../logic/cubit/quiz_cubit.dart';
import '../../logic/cubit/quiz_states.dart';

enum QuestionType { SINGLE, MULTI, TRUE_FALSE }

class QuizTakingScreen extends StatefulWidget {
  final Quiz quiz;

  const QuizTakingScreen({Key? key, required this.quiz}) : super(key: key);

  @override
  State<QuizTakingScreen> createState() => _QuizTakingScreenState();
}

class _QuizTakingScreenState extends State<QuizTakingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  final Map<int, dynamic> _answers = {}; // Changed to dynamic to handle different answer types
  bool _isFinished = false;
  int _score = 0;
  int _totalPoints = 0;
  late AnimationController _progressController;
  late AnimationController _cardController;

  @override
  void initState() {
    super.initState();
    _calculateTotalPoints();
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _cardController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _cardController.forward();
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

    // Determine question type based on answer structure or add type field to your model
    if (correctAnswers.length == 1) {
      // Single choice or True/False
      return userAnswer == correctAnswers.first;
    } else {
      // Multi choice
      if (userAnswer is List<String>) {
        return userAnswer.toSet().containsAll(correctAnswers.toSet()) &&
            correctAnswers.toSet().containsAll(userAnswer.toSet());
      }
      return false;
    }
  }

  void _finishQuiz() {
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
  }

  QuestionType _getQuestionType(QuizQuestion question) {
    // You might want to add a type field to your QuizQuestion model
    // For now, we'll determine based on options
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
          onPressed: () => Navigator.pop(context),
        ),
      ),
      title: Text(
        widget.quiz.name,
        style: TextStyle(
          color: Colors.black87,
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
        ),
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
            onPressed: _finishQuiz,
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
                '${_answers.length} of ${widget.quiz.quizQuestions.length}',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                '${((_answers.length / widget.quiz.quizQuestions.length) * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
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
                  widthFactor: _progressController.value,
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
          onTap: () => _submitAnswer(quizQuestion.questionId, option, QuestionType.SINGLE),
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
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? Theme.of(context).primaryColor : Colors.black87,
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
    final selectedAnswers = _answers[quizQuestion.questionId] as List<String>? ?? [];

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
              _submitAnswer(quizQuestion.questionId, newAnswers, QuestionType.MULTI);
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
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected ? Theme.of(context).primaryColor : Colors.black87,
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
      onTap: () => _submitAnswer(quizQuestion.questionId, value, QuestionType.TRUE_FALSE),
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (currentIndex > 0)
          _buildNavButton(
            'Previous',
            Icons.arrow_back_ios,
            false,
                () {
              _cardController.reset();
              _cardController.forward();
              _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
          )
        else
          const SizedBox(),
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
          )
        else
          const SizedBox(),
      ],
    );
  }

  Widget _buildNavButton(String text, IconData icon, bool isNext, VoidCallback onPressed) {
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
            if (!isNext) ...[
              Icon(icon, size: 18.w, color: Colors.white),
              SizedBox(width: 8.w),
            ],
            Text(
              text,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            if (isNext) ...[
              SizedBox(width: 8.w),
              Icon(icon, size: 18.w, color: Colors.white),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultsScreen() {
    final percentage = (_score / _totalPoints) * 100;
    String grade;
    Color gradeColor;

    if (percentage >= 90) {
      grade = 'A';
      gradeColor = Colors.green;
    } else if (percentage >= 80) {
      grade = 'B';
      gradeColor = Colors.blue;
    } else if (percentage >= 70) {
      grade = 'C';
      gradeColor = Colors.orange;
    } else if (percentage >= 60) {
      grade = 'D';
      gradeColor = Colors.deepOrange;
    } else {
      grade = 'F';
      gradeColor = Colors.red;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(40.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      gradeColor.withOpacity(0.1),
                      gradeColor.withOpacity(0.2),
                    ],
                  ),
                ),
                child: Icon(
                  Icons.emoji_events,
                  size: 80.w,
                  color: gradeColor,
                ),
              ),
              SizedBox(height: 32.h),
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
                '🎉 Great job! 🎉',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 32.h),
              Container(
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
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Your Score:',
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          '$_score / $_totalPoints',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Percentage:',
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          '${percentage.toInt()}%',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: gradeColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Grade:',
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: gradeColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            grade,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: gradeColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40.h),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor.withOpacity(0.8),
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
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
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
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _progressController.dispose();
    _cardController.dispose();
    super.dispose();
  }
}