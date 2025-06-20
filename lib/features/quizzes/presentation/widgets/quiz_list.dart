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
                    onTap: () async {
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
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Center(
                              child: FaIcon(
                                FontAwesomeIcons.puzzlePiece,
                                size: 40.w,
                                color: Theme.of(context).colorScheme.primary,
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
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  'Duration: ${quiz.duration} minutes',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  'Grade: ${quiz.grade}',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                SizedBox(height: 4.h),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                  decoration: BoxDecoration(
                                    color: quiz.active
                                      ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                                      : Theme.of(context).colorScheme.error.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                  child: Text(
                                    quiz.active ? 'Active' : 'Inactive',
                                    style: TextStyle(
                                      color: quiz.active
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context).colorScheme.error,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                         isLoading ? const CupertinoActivityIndicator() :  Icon(Icons.arrow_forward_ios, size: 16.w),
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