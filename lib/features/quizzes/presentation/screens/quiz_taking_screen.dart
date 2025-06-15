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
  final Map<int, String> _answers = {};
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

  void _submitAnswer(int questionId, String answer) {
    setState(() {
      _answers[questionId] = answer;
    });

    // Animate progress
    _progressController.animateTo(
      _answers.length / widget.quiz.quizQuestions.length,
    );
  }

  void _finishQuiz() {
    int score = 0;
    for (var question in widget.quiz.quizQuestions) {
      final userAnswer = _answers[question.questionId];
      final correctAnswers = question.question.answer;
      
      if (userAnswer != null) {
        if (question.question.type == 'SINGLE') {
          // Single choice
          if (userAnswer == correctAnswers.first) {
            score += question.points;
          }
        } else if (question.question.type == 'MULTI') {
          // Multiple choice
          final userAnswers = userAnswer.split(',');
          final isCorrect = userAnswers.length == correctAnswers.length &&
              userAnswers.every((answer) => correctAnswers.contains(answer)) &&
              correctAnswers.every((answer) => userAnswers.contains(answer));
          
          if (isCorrect) {
            score += question.points;
          }
        }
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
      appBar: AppBar(
        title: Text(
          widget.quiz.name,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: _finishQuiz,
            icon: Icon(
              Icons.check_circle_outline,
              size: 20.w,
              color: Theme.of(context).colorScheme.primary,
            ),
            label: Text(
              'Finish',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Progress',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    Text(
                      '${_answers.length}/${widget.quiz.quizQuestions.length}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                LinearProgressIndicator(
                  value: widget.quiz.quizQuestions.isEmpty 
                      ? 0.0 
                      : (_answers.length / widget.quiz.quizQuestions.length).clamp(0.0, 1.0),
                  backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.primary,
                  ),
                  borderRadius: BorderRadius.circular(4.r),
                  minHeight: 8.h,
                ),
              ],
            ),
          ),
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

  Widget _buildQuestionCard(QuizQuestion quizQuestion, int index) {
    final questionType = _getQuestionType(quizQuestion);

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              'Question ${index + 1} of ${widget.quiz.quizQuestions.length}',
              style: TextStyle(
                fontSize: 14.sp,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            quizQuestion.question.questionHeader,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 24.h),
          _buildQuestionOptions(quizQuestion, questionType),
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (index > 0)
                OutlinedButton.icon(
                  onPressed: () {
                    _cardController.reset();
                    _cardController.forward();
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    size: 20.w,
                  ),
                  label: Text(
                    'Previous',
                    style: TextStyle(
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              if (index < widget.quiz.quizQuestions.length - 1)
                ElevatedButton.icon(
                  onPressed: () {
                    _cardController.reset();
                    _cardController.forward();
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  icon: Icon(
                    Icons.arrow_forward,
                    size: 20.w,
                  ),
                  label: Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 14.sp,
                    ),
                  ),
                ),
            ],
          ),
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
        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: InkWell(
            onTap: () => _submitAnswer(quizQuestion.questionId, option),
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: isSelected 
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                    : Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outline.withOpacity(0.5),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 24.w,
                    height: 24.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    child: isSelected
                        ? Center(
                            child: Container(
                              width: 12.w,
                              height: 12.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          )
                        : null,
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Text(
                      option,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
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
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        SizedBox(height: 16.h),
        ...quizQuestion.question.options.map((option) {
          final isSelected = selectedAnswers.contains(option);
          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: InkWell(
              onTap: () {
                List<String> newAnswers = List.from(selectedAnswers);
                if (isSelected) {
                  newAnswers.remove(option);
                } else {
                  newAnswers.add(option);
                }
                _submitAnswer(quizQuestion.questionId, newAnswers.join(','));
              },
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                      : Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outline.withOpacity(0.5),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24.w,
                      height: 24.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      child: isSelected
                          ? Center(
                              child: Container(
                                width: 12.w,
                                height: 12.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            )
                          : null,
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Text(
                        option,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
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
      onTap: () => _submitAnswer(quizQuestion.questionId, value),
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

  Widget _buildResultsScreen() {
    final percentage = (_score / _totalPoints) * 100;
    String grade;
    Color gradeColor;

    if (percentage >= 90) {
      grade = 'A';
      gradeColor = Colors.green;
    } else if (percentage >= 80) {
      grade = 'B';
      gradeColor = Colors.lightGreen;
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
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120.w,
                height: 120.w,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.assignment_turned_in,
                  size: 60.w,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(height: 32.h),
              Text(
                'Quiz Completed!',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 24.h),
              Container(
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Your Score',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      '$_score / $_totalPoints',
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: gradeColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        'Grade: $grade',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: gradeColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32.h),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.arrow_back,
                  size: 20.w,
                ),
                label: Text(
                  'Back to Quiz List',
                  style: TextStyle(
                    fontSize: 16.sp,
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