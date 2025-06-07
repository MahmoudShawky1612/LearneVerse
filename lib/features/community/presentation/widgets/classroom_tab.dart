import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/features/home/data/models/community_model.dart';
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
    context.read<ClassroomCubit>().fetchClassrooms(widget.community.id);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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

        /// 🔽 BlocBuilder replaces static section rendering
        BlocBuilder<ClassroomCubit, ClassroomStates>(
          builder: (context, state) {
            if (state is ClassroomLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ClassroomLoaded) {
              final classrooms = state.classrooms;

              if (classrooms.isEmpty) {
                return const Text("No classrooms available.");
              }

              return Column(
                children: classrooms
                    .map((classroom) => ClassroomCard(classroom: classroom,))
                    .toList(),
              );
            } else if (state is ClassroomError) {
              return Text(state.message, style: const TextStyle(color: Colors.red));
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
