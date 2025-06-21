import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/utils/error_state.dart';
import 'package:flutterwidgets/utils/loading_state.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../profile/views/widgets/no_profile_widget.dart';
import '../../logic/cubit/quiz_cubit.dart';
import '../../logic/cubit/quiz_states.dart';
import '../screens/quiz_taking_screen.dart';

class QuizList extends StatefulWidget {
  final int communityId;

  const QuizList({Key? key, required this.communityId}) : super(key: key);

  @override
  State<QuizList> createState() => _QuizListState();
}
bool isLoading = false;

class _QuizListState extends State<QuizList> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuizCubit, QuizStates>(
      builder: (context, state) {
        if (state is QuizLoading) {
          return const Center(child: LoadingState());
        } else if (state is QuizError) {
          return Center(
            child: ErrorStateWidget(onRetry: (){
              context.read<QuizCubit>().fetchCommunityQuizzes(widget.communityId);
            }, message: state.message,),
          );
        } else if (state is QuizLoaded) {
          if (state.quizzes.isEmpty) {
            return const NoDataWidget(
              message: 'Good news! There are no quizzes available at the moment.',
            );
          }

          // Debug: Print quiz data
          for (var quiz in state.quizzes) {
            print('Quiz ${quiz.id}: isAttempted = ${quiz.isAttempted}');
          }

          return Column(
            children: state.quizzes.map((quiz) {
              return Container(
                margin: EdgeInsets.only(bottom: 16.h),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16.r),
                    onTap: quiz.isAttempted ? () {
                      print('Quiz ${quiz.id} is attempted: ${quiz.isAttempted}');
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Quiz Already Attempted'),
                            content: const Text(
                              'You have already taken this quiz. You cannot attempt it again.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    } : () async {
                      setState(() {
                        isLoading = true;
                      });
                      try {
                        final quizDetails = await context.read<QuizCubit>().getQuizById(quiz.id);
                        if (context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuizTakingScreen(quiz: quizDetails),
                            ),
                          );
                          setState(() {
                            isLoading = false;
                          });
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error loading quiz: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          print(e);
                        }
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 80.w,
                            height: 80.h,
                            decoration: BoxDecoration(
                              color: quiz.isAttempted 
                                ? Colors.grey.withOpacity(0.1)
                                : Theme.of(context).colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Center(
                              child: FaIcon(
                                quiz.isAttempted 
                                  ? FontAwesomeIcons.checkCircle
                                  : FontAwesomeIcons.puzzlePiece,
                                size: 40.w,
                                color: quiz.isAttempted 
                                  ? Colors.grey
                                  : Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  quiz.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp,
                                    color: quiz.isAttempted ? Colors.grey : null,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  'Duration: ${quiz.duration} minutes',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: quiz.isAttempted ? Colors.grey : null,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  'Grade: ${quiz.grade}',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: quiz.isAttempted ? Colors.grey : null,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                      decoration: BoxDecoration(
                                        color: quiz.isAttempted
                                          ? Colors.grey.withOpacity(0.1)
                                          : quiz.active
                                            ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                                            : Theme.of(context).colorScheme.error.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(4.r),
                                      ),
                                      child: Text(
                                        quiz.isAttempted 
                                          ? 'Already Attempted'
                                          : quiz.active ? 'Active' : 'Inactive',
                                        style: TextStyle(
                                          color: quiz.isAttempted
                                            ? Colors.grey
                                            : quiz.active
                                              ? Theme.of(context).colorScheme.primary
                                              : Theme.of(context).colorScheme.error,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (quiz.isAttempted)
                            Icon(Icons.check_circle, size: 24.w, color: Colors.grey)
                          else
                            isLoading ? const CupertinoActivityIndicator() : Icon(Icons.arrow_forward_ios, size: 16.w),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}