import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/features/home/data/models/community_model.dart';
import 'package:flutterwidgets/features/quizzes/logic/cubit/quiz_cubit.dart';
import 'package:flutterwidgets/features/quizzes/presentation/widgets/quiz_list.dart';
import 'package:flutterwidgets/features/quizzes/service/quiz_service.dart';

class QuizzesTab extends StatefulWidget {
  final Community community;

  const QuizzesTab({Key? key, required this.community}) : super(key: key);

  @override
  State<QuizzesTab> createState() => _QuizzesTabState();
}

class _QuizzesTabState extends State<QuizzesTab> {
  @override
  void initState() {
    super.initState();
    fetchQuizzes();
  }

  void fetchQuizzes() {
    context.read<QuizCubit>().fetchCommunityQuizzes(widget.community.id);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 24.h),
        Text(
          'Community Quizzes',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16.h),
        QuizList(communityId: widget.community.id),
      ],
    );
  }
} 