import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/features/home/data/models/community_model.dart';
import 'package:flutterwidgets/utils/error_state.dart';
import 'package:flutterwidgets/utils/loading_state.dart';
import '../../logic/cubit/classroom_cubit.dart';
import '../../logic/cubit/classroom_states.dart';
import 'section_card.dart';

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
              return const Center(child: LoadingState());
            } else if (state is ClassroomLoaded) {
              final classrooms = state.classrooms;
              if (classrooms.isEmpty) {
                return const Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.hourglass_empty, size: 48, color: Colors.blue),
                    SizedBox(height: 8),
                    Text('No classes yet', style: TextStyle(color: Colors.grey)),
                  ],
                ));
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
