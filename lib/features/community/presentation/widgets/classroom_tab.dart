import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/features/home/data/models/community_model.dart';
import 'package:flutterwidgets/utils/error_state.dart';
import 'package:flutterwidgets/utils/loading_state.dart';
import '../../../profile/presentation/widgets/no_profile_widget.dart';
import '../../logic/cubit/classroom_cubit.dart';
import '../../logic/cubit/classroom_states.dart';
import 'classroom_card.dart';

class ClassroomTab extends StatefulWidget {
  final Community community;

  const ClassroomTab({super.key, required this.community});

  @override
  State<ClassroomTab> createState() => _ClassroomTabState();
}

class _ClassroomTabState extends State<ClassroomTab> {
  @override
  void initState() {
    super.initState();
    fetchClassrooms();
  }

  void fetchClassrooms() {
    context.read<ClassroomCubit>().fetchClassrooms(widget.community.id);
  }
  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 24.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Available Classes',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),

        BlocBuilder<ClassroomCubit, ClassroomStates>(
          builder: (context, state) {
            if (state is ClassroomLoading) {
              return   Center(child: Column(
                children: [
                  SizedBox(height: 20.h),
                  const LoadingState(),
                  SizedBox(height: 200.h),
                ],
              ));
            } else if (state is ClassroomLoaded) {
              final classrooms = state.classrooms;
              if (classrooms.isEmpty) {
                return const NoDataWidget(message: "No classes yet... 👀", width: 100, height: 100,);
              }
              return Column(
                children: classrooms
                    .map((classroom) => ClassroomCard(classroom: classroom,))
                    .toList(),
              );
            } else if (state is ClassroomError) {
              return ErrorStateWidget(message: state.message, onRetry: fetchClassrooms);
            }
            return const SizedBox.shrink();
          },
        ),

        SizedBox(height: 24.h),
        SizedBox(height: 36.h),
      ],
    );
  }
}
