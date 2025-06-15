import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/quiz_model.dart';
import '../../data/models/question_model.dart';
import '../../logic/cubit/quiz_cubit.dart';
import '../../logic/cubit/quiz_states.dart';

class QuizTakingScreen extends StatefulWidget {
  final Quiz quiz;

  const QuizTakingScreen({Key? key, required this.quiz}) : super(key: key);

  @override
  State<QuizTakingScreen> createState() => _QuizTakingScreenState();
}

class _QuizTakingScreenState extends State<QuizTakingScreen> {
  final PageController _pageController = PageController();
  final Map<int, String> _answers = {};
  bool _isFinished = false;
  int _score = 0;
  int _totalPoints = 0;

  @override
  void initState() {
    super.initState();
    _calculateTotalPoints();
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
  }

  void _finishQuiz() {
    int score = 0;
    for (var question in widget.quiz.quizQuestions) {
      if (_answers[question.questionId] == question.question.answer.first) {
        score += question.points;
      }
    }

    setState(() {
      _score = score;
      _isFinished = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isFinished) {
      return _buildResultsScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quiz.name),
        actions: [
          TextButton(
            onPressed: _finishQuiz,
            child: const Text('Finish'),
          ),
        ],
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: widget.quiz.quizQuestions.isEmpty 
                ? 0.0 
                : (_answers.length / widget.quiz.quizQuestions.length).clamp(0.0, 1.0),
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor,
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.quiz.quizQuestions.length,
              itemBuilder: (context, index) {
                final question = widget.quiz.quizQuestions[index];
                return _buildQuestionCard(question);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(QuizQuestion quizQuestion) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Question ${widget.quiz.quizQuestions.indexOf(quizQuestion) + 1} of ${widget.quiz.quizQuestions.length}',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            quizQuestion.question.questionHeader,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          ...quizQuestion.question.options.map((option) {
            return Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: RadioListTile<String>(
                title: Text(option),
                value: option,
                groupValue: _answers[quizQuestion.questionId],
                onChanged: (value) {
                  if (value != null) {
                    _submitAnswer(quizQuestion.questionId, value);
                  }
                },
              ),
            );
          }).toList(),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.quiz.quizQuestions.indexOf(quizQuestion) > 0)
                ElevatedButton(
                  onPressed: () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: const Text('Previous'),
                ),
              if (widget.quiz.quizQuestions.indexOf(quizQuestion) <
                  widget.quiz.quizQuestions.length - 1)
                ElevatedButton(
                  onPressed: () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: const Text('Next'),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultsScreen() {
    final percentage = (_score / _totalPoints) * 100;
    String grade;
    if (percentage >= 90) {
      grade = 'A';
    } else if (percentage >= 80) {
      grade = 'B';
    } else if (percentage >= 70) {
      grade = 'C';
    } else if (percentage >= 60) {
      grade = 'D';
    } else {
      grade = 'F';
    }

    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.assignment_turned_in,
                size: 80.w,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(height: 24.h),
              Text(
                'Quiz Completed!',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Your Score: $_score / $_totalPoints',
                style: TextStyle(
                  fontSize: 18.sp,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Grade: $grade',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 32.h),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Back to Quiz List'),
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
    super.dispose();
  }
} 