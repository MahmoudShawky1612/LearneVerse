import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/error_state.dart';
import '../../utils/loading_state.dart';
import 'data/models/models.dart';
import 'logic/cubit/sections_cubit.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/jwt_helper.dart';
import '../../utils/token_storage.dart';

class SectionsScreen extends StatefulWidget {
  final int classroomId;
  const SectionsScreen({super.key, required this.classroomId});

  @override
  State<SectionsScreen> createState() => _SectionsScreenState();
}

class _SectionsScreenState extends State<SectionsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SectionsCubit>().loadSections(widget.classroomId);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<SectionsCubit, SectionsState>(
      builder: (context, state) {
        if (state is SectionsLoading || state is SectionsInitial) {
          return const Center(child: LoadingState());
        } else if (state is SectionsError) {
          return Center(
            child: ErrorStateWidget(
              message: state.message,
              onRetry: () => context.read<SectionsCubit>().loadSections(widget.classroomId),
            ),
          );
        } else if (state is SectionsLoaded) {
          final sections = state.sections;
          final lessons = state.lessons;
          final selectedSectionIndex = state.selectedSectionIndex ?? 0;
          final currentSection = sections.isNotEmpty ? sections[selectedSectionIndex] : null;

          return FutureBuilder<String?>(
            future: TokenStorage.getToken(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: LoadingState());
              }
              final token = snapshot.data!;
              final userId = getUserIdFromToken(token);

              return Scaffold(
                backgroundColor: isDark ? const Color(0xFF0A0A0A) : const Color(0xFFF8FAFC),
                body: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // Modern Header
                    SliverAppBar(
                      expandedHeight: 200.h,
                      floating: false,
                      pinned: true,
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      leading: Container(
                        margin: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withOpacity(0.1)
                              : Colors.black.withOpacity(0.05),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark
                                ? Colors.white.withOpacity(0.1)
                                : Colors.black.withOpacity(0.1),
                          ),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: isDark ? Colors.white : Colors.black87,
                            size: 20.sp,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      flexibleSpace: FlexibleSpaceBar(
                        background: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: isDark
                                  ? [
                                const Color(0xFF1A1A2E),
                                const Color(0xFF16213E),
                                const Color(0xFF0F3460),
                              ]
                                  : [
                                const Color(0xFF667EEA),
                                const Color(0xFF764BA2),
                                const Color(0xFFF093FB),
                              ],
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  (isDark ? const Color(0xFF0A0A0A) : const Color(0xFFF8FAFC))
                                      .withOpacity(0.1),
                                ],
                              ),
                            ),
                            child: SafeArea(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(24.w, 60.h, 24.w, 24.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(20.r),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.3),
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        'LEARNING PATH',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.9),
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1.5,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 12.h),
                                    Text(
                                      currentSection?.name ?? 'Course Sections',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 28.sp,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: -0.5,
                                        height: 1.2,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      '${lessons.length} lessons available',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Section Pills
                    SliverToBoxAdapter(
                      child: Container(
                        height: 120.h,
                        margin: EdgeInsets.symmetric(vertical: 24.h),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          itemCount: sections.length,
                          itemBuilder: (context, index) {
                            bool isSelected = index == selectedSectionIndex;
                            final section = sections[index];

                            return GestureDetector(
                              onTap: () {
                                context.read<SectionsCubit>().selectSection(index);
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 16.w),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 70.w,
                                      height: 70.h,
                                      decoration: BoxDecoration(
                                        gradient: isSelected
                                            ? LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: isDark
                                              ? [
                                            const Color(0xFF667EEA),
                                            const Color(0xFF764BA2),
                                          ]
                                              : [
                                            const Color(0xFF667EEA),
                                            const Color(0xFF764BA2),
                                          ],
                                        )
                                            : null,
                                        color: isSelected
                                            ? null
                                            : isDark
                                            ? const Color(0xFF1A1A1A)
                                            : Colors.white,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isSelected
                                              ? Colors.transparent
                                              : isDark
                                              ? Colors.white.withOpacity(0.1)
                                              : Colors.grey.withOpacity(0.2),
                                          width: 1.5,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: isSelected
                                                ? (isDark ? Colors.blue.withOpacity(0.3) : Colors.purple.withOpacity(0.3))
                                                : Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                                            blurRadius: isSelected ? 20.r : 10.r,
                                            offset: Offset(0, isSelected ? 8.h : 4.h),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${index + 1}',
                                          style: TextStyle(
                                            color: isSelected
                                                ? Colors.white
                                                : isDark
                                                ? Colors.white.withOpacity(0.8)
                                                : Colors.grey[700],
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 12.h),
                                    SizedBox(
                                      width: 90.w,
                                      child: Text(
                                        section.name,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600,
                                          color: isSelected
                                              ? (isDark ? const Color(0xFF667EEA) : const Color(0xFF764BA2))
                                              : isDark
                                              ? Colors.white.withOpacity(0.7)
                                              : Colors.grey[600],
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    // Lessons Grid
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (context, index) {
                            final lesson = lessons[index];
                            final isDone = lesson.isCompleted(userId);
                            final material = lesson.materials.isNotEmpty ? lesson.materials[0] : null;
                            final contentType = material?.type ?? ContentType.file;

                            return Container(
                              margin: EdgeInsets.only(bottom: 20.h),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    _showLessonDetail(context, lesson, contentType);
                                  },
                                  borderRadius: BorderRadius.circular(24.r),
                                  child: Container(
                                    padding: EdgeInsets.all(24.w),
                                    decoration: BoxDecoration(
                                      color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
                                      borderRadius: BorderRadius.circular(24.r),
                                      border: Border.all(
                                        color: isDone
                                            ? (isDark ? const Color(0xFF00C851) : const Color(0xFF4CAF50))
                                            : isDark
                                            ? Colors.white.withOpacity(0.05)
                                            : Colors.grey.withOpacity(0.1),
                                        width: isDone ? 2 : 1,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: isDark
                                              ? Colors.black.withOpacity(0.3)
                                              : Colors.black.withOpacity(0.04),
                                          blurRadius: 20.r,
                                          offset: Offset(0, 8.h),
                                        ),
                                        if (isDone)
                                          BoxShadow(
                                            color: (isDark ? const Color(0xFF00C851) : const Color(0xFF4CAF50))
                                                .withOpacity(0.2),
                                            blurRadius: 15.r,
                                            offset: Offset(0, 5.h),
                                          ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        // Content Icon
                                        Container(
                                          width: 56.w,
                                          height: 56.h,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: _getContentTypeGradient(contentType, isDark),
                                            ),
                                            borderRadius: BorderRadius.circular(16.r),
                                            boxShadow: [
                                              BoxShadow(
                                                color: _getContentTypeColor(contentType, isDark).withOpacity(0.3),
                                                blurRadius: 12.r,
                                                offset: Offset(0, 4.h),
                                              ),
                                            ],
                                          ),
                                          child: Icon(
                                            _getContentTypeIcon(contentType),
                                            color: Colors.white,
                                            size: 24.sp,
                                          ),
                                        ),
                                        SizedBox(width: 20.w),
                                        // Content
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      padding: EdgeInsets.symmetric(
                                                        horizontal: 10.w,
                                                        vertical: 4.h,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: _getContentTypeColor(contentType, isDark)
                                                            .withOpacity(0.1),
                                                        borderRadius: BorderRadius.circular(8.r),
                                                      ),
                                                      child: Text(
                                                        _getContentTypeLabel(contentType),
                                                        style: TextStyle(
                                                          fontSize: 10.sp,
                                                          color: _getContentTypeColor(contentType, isDark),
                                                          fontWeight: FontWeight.w700,
                                                          letterSpacing: 0.8,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 12.w),
                                                  if (isDone)
                                                    Container(
                                                      padding: EdgeInsets.symmetric(
                                                        horizontal: 10.w,
                                                        vertical: 4.h,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        gradient: LinearGradient(
                                                          colors: [
                                                            const Color(0xFF00C851),
                                                            const Color(0xFF007E33),
                                                          ],
                                                        ),
                                                        borderRadius: BorderRadius.circular(8.r),
                                                      ),
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Icon(
                                                            Icons.check_circle_rounded,
                                                            color: Colors.white,
                                                            size: 12.sp,
                                                          ),
                                                          SizedBox(width: 4.w),
                                                          Text(
                                                            'COMPLETED',
                                                            style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 9.sp,
                                                              fontWeight: FontWeight.w700,
                                                              letterSpacing: 0.5,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                ],
                                              ),
                                              SizedBox(height: 12.h),
                                              Text(
                                                lesson.title,
                                                style: TextStyle(
                                                  fontSize: 17.sp,
                                                  fontWeight: FontWeight.w700,
                                                  color: isDark ? Colors.white : Colors.grey[800],
                                                  letterSpacing: -0.3,
                                                  height: 1.3,
                                                ),
                                              ),
                                              SizedBox(height: 8.h),
                                              Text(
                                                lesson.notes.isNotEmpty ? lesson.notes[0] : '',
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  color: isDark ? Colors.white.withOpacity(0.7) : Colors.grey[600],
                                                  height: 1.5,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(height: 16.h),
                                              // Action Button
                                              Container(
                                                width: double.infinity,
                                                height: 44.h,
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    await context.read<SectionsCubit>()
                                                        .toggleLessonCompleted(lesson.id, currentSection!.id);
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: isDone
                                                        ? isDark
                                                        ? Colors.white.withOpacity(0.1)
                                                        : Colors.grey[100]
                                                        : isDark
                                                        ? const Color(0xFF667EEA)
                                                        : const Color(0xFF764BA2),
                                                    foregroundColor: isDone
                                                        ? isDark ? Colors.white.withOpacity(0.8) : Colors.grey[700]
                                                        : Colors.white,
                                                    elevation: 0,
                                                    shadowColor: Colors.transparent,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(12.r),
                                                      side: BorderSide(
                                                        color: isDone
                                                            ? isDark
                                                            ? Colors.white.withOpacity(0.2)
                                                            : Colors.grey.withOpacity(0.3)
                                                            : Colors.transparent,
                                                      ),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Icon(
                                                        isDone ? Icons.undo_rounded : Icons.check_rounded,
                                                        size: 13.sp,
                                                      ),
                                                      SizedBox(width: 5.w),
                                                      Text(
                                                        isDone ? 'Mark as Undone' : 'Mark as Done',
                                                        style: TextStyle(
                                                          fontSize: 10.sp,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 12.w),
                                        // Arrow
                                        Container(
                                          width: 32.w,
                                          height: 32.h,
                                          decoration: BoxDecoration(
                                            color: isDark
                                                ? Colors.white.withOpacity(0.05)
                                                : Colors.grey.withOpacity(0.1),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            size: 14.sp,
                                            color: isDark
                                                ? Colors.white.withOpacity(0.5)
                                                : Colors.grey[500],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          childCount: lessons.length,
                        ),
                      ),
                    ),
                    // Bottom spacing
                    SliverToBoxAdapter(
                      child: SizedBox(height: 40.h),
                    ),
                  ],
                ),
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }

  List<Color> _getContentTypeGradient(ContentType type, bool isDark) {
    switch (type) {
      case ContentType.document:
        return isDark
            ? [const Color(0xFF667EEA), const Color(0xFF764BA2)]
            : [const Color(0xFF667EEA), const Color(0xFF764BA2)];
      case ContentType.image:
        return isDark
            ? [const Color(0xFFFF6B6B), const Color(0xFFEE5A24)]
            : [const Color(0xFFFF6B6B), const Color(0xFFEE5A24)];
      case ContentType.video:
        return isDark
            ? [const Color(0xFF00D2FF), const Color(0xFF3A7BD5)]
            : [const Color(0xFF00D2FF), const Color(0xFF3A7BD5)];
      case ContentType.recording:
        return isDark
            ? [const Color(0xFFFF9472), const Color(0xFFF2709C)]
            : [const Color(0xFFFF9472), const Color(0xFFF2709C)];
      case ContentType.file:
        return isDark
            ? [const Color(0xFF11998E), const Color(0xFF38EF7D)]
            : [const Color(0xFF11998E), const Color(0xFF38EF7D)];
    }
  }

  Color _getContentTypeColor(ContentType type, bool isDark) {
    switch (type) {
      case ContentType.document:
        return const Color(0xFF667EEA);
      case ContentType.image:
        return const Color(0xFFFF6B6B);
      case ContentType.video:
        return const Color(0xFF00D2FF);
      case ContentType.recording:
        return const Color(0xFFFF9472);
      case ContentType.file:
        return const Color(0xFF11998E);
    }
  }

  IconData _getContentTypeIcon(ContentType type) {
    switch (type) {
      case ContentType.document:
        return Icons.description_rounded;
      case ContentType.image:
        return Icons.image_rounded;
      case ContentType.video:
        return Icons.play_circle_fill_rounded;
      case ContentType.recording:
        return Icons.mic_rounded;
      case ContentType.file:
        return Icons.insert_drive_file_rounded;
    }
  }

  String _getContentTypeLabel(ContentType type) {
    switch (type) {
      case ContentType.document:
        return 'DOCUMENT';
      case ContentType.image:
        return 'IMAGE';
      case ContentType.video:
        return 'VIDEO';
      case ContentType.recording:
        return 'AUDIO';
      case ContentType.file:
        return 'FILE';
    }
  }

  void _showLessonDetail(BuildContext context, LessonContent lesson, ContentType type) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LessonDetailSheet(lesson: lesson, type: type),
    );
  }
}

class LessonDetailSheet extends StatefulWidget {
  final LessonContent lesson;
  final ContentType type;

  const LessonDetailSheet({super.key, required this.lesson, required this.type});

  @override
  State<LessonDetailSheet> createState() => _LessonDetailSheetState();
}

class _LessonDetailSheetState extends State<LessonDetailSheet> {
  VideoPlayerController? _videoController;
  AudioPlayer? _audioPlayer;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initializeMedia();
  }

  void _initializeMedia() {
    if (widget.type == ContentType.video) {
      _videoController = VideoPlayerController.network(widget.lesson.materials[0].fileUrl)
        ..initialize().then((_) {
          setState(() {});
        });
      _videoController?.addListener(_videoListener);
    } else if (widget.type == ContentType.recording) {
      _audioPlayer = AudioPlayer();
      _audioPlayer!.onDurationChanged.listen((duration) {
        setState(() {
          _duration = duration;
        });
      });
      _audioPlayer!.onPositionChanged.listen((position) {
        setState(() {
          _position = position;
        });
      });
      _audioPlayer!.onPlayerStateChanged.listen((state) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      });
    }
  }

  void _videoListener() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _videoController?.removeListener(_videoListener);
    _videoController?.dispose();
    _audioPlayer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedSectionIndex = context.read<SectionsCubit>().selectedSectionIndex ?? 0;
    final sectionId = context.read<SectionsCubit>().sections[selectedSectionIndex].id;

    return FutureBuilder<String?>(
        future: TokenStorage.getToken(),
    builder: (context, snapshot) {
    if (!snapshot.hasData) {
    return const Center(child: LoadingState());
    }
    final token = snapshot.data!;
    final userId = getUserIdFromToken(token);
    final isCompleted = widget.lesson.isCompleted(userId);

    return Container(
    height: MediaQuery.of(context).size.height * 0.92,
    decoration: BoxDecoration(
    color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
    borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
    boxShadow: [
    BoxShadow(
    color: Colors.black.withOpacity(0.2),
    blurRadius: 20.r,
    offset: Offset(0, -8.h),
    ),
    ],
    ),
    child: Column(
    children: [
    // Handle
    Container(
    margin: EdgeInsets.only(top: 16.h),
    width: 50.w,
    height: 5.h,
    decoration: BoxDecoration(
    color: isDark
    ? Colors.white.withOpacity(0.3)
        : Colors.grey[300],
    borderRadius: BorderRadius.circular(3.r),
    ),
    ),

    // Header
    Container(
    padding: EdgeInsets.all(28.w),
    child: Row(
    children: [
    Container(
    width: 70.w,
    height: 70.h,
    decoration: BoxDecoration(
    gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: _getContentTypeGradient(widget.type, isDark),
    ),
    borderRadius: BorderRadius.circular(20.r),
    boxShadow: [
    BoxShadow(
    color: _getContentTypeColor(widget.type, isDark).withOpacity(0.3),
    blurRadius: 15.r,
    offset: Offset(0, 8.h),
    ),
    ],
    ),
    child: Icon(
    _getContentTypeIcon(widget.type),
    color: Colors.white,
    size: 32.sp,
    ),
    ),
    SizedBox(width: 20.w),
    Expanded(
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Container(
    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
    decoration: BoxDecoration(
    color: _getContentTypeColor(widget.type, isDark).withOpacity(0.1),
    borderRadius: BorderRadius.circular(12.r),
    ),
    child: Text(
    _getContentTypeLabel(widget.type),
    style: TextStyle(
    fontSize: 12.sp,
    color: _getContentTypeColor(widget.type, isDark),
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
    ),
    ),
    ),
    SizedBox(height: 8.h),
    Text(
    widget.lesson.title,
      style: TextStyle(
        fontSize: 22.sp,
        fontWeight: FontWeight.w700,
        color: isDark ? Colors.white : Colors.grey[800],
        letterSpacing: -0.3,
        height: 1.2,
      ),
    ),
    ],
    ),
    ),
      // Close button
      Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withOpacity(0.1)
              : Colors.grey.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: Icon(
            Icons.close_rounded,
            color: isDark ? Colors.white.withOpacity(0.8) : Colors.grey[600],
            size: 20.sp,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    ],
    ),
    ),

      // Content Area
      Expanded(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 28.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Media Player Section
              if (widget.type == ContentType.video) ...[
                Container(
                  width: double.infinity,
                  height: 220.h,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15.r,
                        offset: Offset(0, 8.h),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.r),
                    child: _videoController != null && _videoController!.value.isInitialized
                        ? Stack(
                      children: [
                        AspectRatio(
                          aspectRatio: _videoController!.value.aspectRatio,
                          child: VideoPlayer(_videoController!),
                        ),
                        Center(
                          child: IconButton(
                            icon: Icon(
                              _videoController!.value.isPlaying
                                  ? Icons.pause_circle_filled
                                  : Icons.play_circle_filled,
                              color: Colors.white,
                              size: 60.sp,
                            ),
                            onPressed: () {
                              setState(() {
                                _videoController!.value.isPlaying
                                    ? _videoController!.pause()
                                    : _videoController!.play();
                              });
                            },
                          ),
                        ),
                      ],
                    )
                        : const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  ),
                ),
              ] else if (widget.type == ContentType.recording) ...[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? [const Color(0xFF2A2A2A), const Color(0xFF1A1A1A)]
                          : [const Color(0xFFF8F9FA), const Color(0xFFE9ECEF)],
                    ),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Audio controls
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(
                              _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                              size: 60.sp,
                              color: const Color(0xFFFF9472),
                            ),
                            onPressed: () async {
                              if (_isPlaying) {
                                await _audioPlayer!.pause();
                              } else {
                                await _audioPlayer!.play(UrlSource(widget.lesson.materials[0].fileUrl));
                              }
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      // Progress bar
                      Row(
                        children: [
                          Text(
                            _formatDuration(_position),
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: isDark ? Colors.white.withOpacity(0.7) : Colors.grey[600],
                            ),
                          ),
                          Expanded(
                            child: Slider(
                              value: _duration.inSeconds > 0
                                  ? _position.inSeconds / _duration.inSeconds
                                  : 0.0,
                              onChanged: (value) async {
                                final position = Duration(
                                  seconds: (_duration.inSeconds * value).round(),
                                );
                                await _audioPlayer!.seek(position);
                              },
                              activeColor: const Color(0xFFFF9472),
                              inactiveColor: isDark
                                  ? Colors.white.withOpacity(0.2)
                                  : Colors.grey.withOpacity(0.3),
                            ),
                          ),
                          Text(
                            _formatDuration(_duration),
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: isDark ? Colors.white.withOpacity(0.7) : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ] else if (widget.type == ContentType.document) ...[
                Container(
                  width: double.infinity,
                  height: 400.h,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF2A2A2A) : Colors.grey[50],
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.2),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.r),
                    child: SfPdfViewer.network(
                      widget.lesson.materials[0].fileUrl,
                      canShowScrollHead: false,
                      canShowScrollStatus: false,
                    ),
                  ),
                ),
              ] else if (widget.type == ContentType.image) ...[
                Container(
                  width: double.infinity,
                  constraints: BoxConstraints(maxHeight: 400.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 15.r,
                        offset: Offset(0, 8.h),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.r),
                    child: Image.network(
                      widget.lesson.materials[0].fileUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200.h,
                          color: isDark ? const Color(0xFF2A2A2A) : Colors.grey[200],
                          child: Center(
                            child: Icon(
                              Icons.error_outline,
                              size: 48.sp,
                              color: isDark ? Colors.white.withOpacity(0.5) : Colors.grey[500],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ] else ...[
                // File type - show download option
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? [const Color(0xFF2A2A2A), const Color(0xFF1A1A1A)]
                          : [const Color(0xFFF8F9FA), const Color(0xFFE9ECEF)],
                    ),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.insert_drive_file_rounded,
                        size: 64.sp,
                        color: const Color(0xFF11998E),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Download File',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Tap to download the lesson file',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: isDark ? Colors.white.withOpacity(0.7) : Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      ElevatedButton.icon(
                        onPressed: () async {
                          final url = Uri.parse(widget.lesson.materials[0].fileUrl);
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          }
                        },
                        icon: Icon(Icons.download_rounded, size: 18.sp),
                        label: Text(
                          'Download',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF11998E),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              SizedBox(height: 32.h),

              // Lesson Description
              if (widget.lesson.notes.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF2A2A2A) : Colors.grey[50],
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.description_rounded,
                            color: isDark ? Colors.white.withOpacity(0.8) : Colors.grey[600],
                            size: 20.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Lesson Notes',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      ...widget.lesson.notes.map((note) => Padding(
                        padding: EdgeInsets.only(bottom: 8.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('• ', style: TextStyle(fontSize: 15.sp, color: isDark ? Colors.white : Colors.grey[800])),
                            Expanded(
                              child: Text(
                                note,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: isDark ? Colors.white.withOpacity(0.8) : Colors.grey[700],
                                  height: 1.6,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
                SizedBox(height: 32.h),
              ],

              // Progress Action
              Container(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: () async {
                    await context.read<SectionsCubit>()
                        .toggleLessonCompleted(widget.lesson.id, sectionId);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isCompleted
                        ? isDark
                        ? Colors.white.withOpacity(0.1)
                        : Colors.grey[200]
                        : isDark
                        ? const Color(0xFF667EEA)
                        : const Color(0xFF764BA2),
                    foregroundColor: isCompleted
                        ? isDark ? Colors.white.withOpacity(0.8) : Colors.grey[700]
                        : Colors.white,
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      side: BorderSide(
                        color: isCompleted
                            ? isDark
                            ? Colors.white.withOpacity(0.2)
                            : Colors.grey.withOpacity(0.3)
                            : Colors.transparent,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isCompleted ? Icons.undo_rounded : Icons.check_rounded,
                        size: 20.sp,
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        isCompleted ? 'Mark as Undone' : 'Mark as Complete',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    ],
    ),
    );
    },
    );
  }

  // Helper methods from parent class
  List<Color> _getContentTypeGradient(ContentType type, bool isDark) {
    switch (type) {
      case ContentType.document:
        return isDark
            ? [const Color(0xFF667EEA), const Color(0xFF764BA2)]
            : [const Color(0xFF667EEA), const Color(0xFF764BA2)];
      case ContentType.image:
        return isDark
            ? [const Color(0xFFFF6B6B), const Color(0xFFEE5A24)]
            : [const Color(0xFFFF6B6B), const Color(0xFFEE5A24)];
      case ContentType.video:
        return isDark
            ? [const Color(0xFF00D2FF), const Color(0xFF3A7BD5)]
            : [const Color(0xFF00D2FF), const Color(0xFF3A7BD5)];
      case ContentType.recording:
        return isDark
            ? [const Color(0xFFFF9472), const Color(0xFFF2709C)]
            : [const Color(0xFFFF9472), const Color(0xFFF2709C)];
      case ContentType.file:
        return isDark
            ? [const Color(0xFF11998E), const Color(0xFF38EF7D)]
            : [const Color(0xFF11998E), const Color(0xFF38EF7D)];
    }
  }

  Color _getContentTypeColor(ContentType type, bool isDark) {
    switch (type) {
      case ContentType.document:
        return const Color(0xFF667EEA);
      case ContentType.image:
        return const Color(0xFFFF6B6B);
      case ContentType.video:
        return const Color(0xFF00D2FF);
      case ContentType.recording:
        return const Color(0xFFFF9472);
      case ContentType.file:
        return const Color(0xFF11998E);
    }
  }

  IconData _getContentTypeIcon(ContentType type) {
    switch (type) {
      case ContentType.document:
        return Icons.description_rounded;
      case ContentType.image:
        return Icons.image_rounded;
      case ContentType.video:
        return Icons.play_circle_fill_rounded;
      case ContentType.recording:
        return Icons.mic_rounded;
      case ContentType.file:
        return Icons.insert_drive_file_rounded;
    }
  }

  String _getContentTypeLabel(ContentType type) {
    switch (type) {
      case ContentType.document:
        return 'DOCUMENT';
      case ContentType.image:
        return 'IMAGE';
      case ContentType.video:
        return 'VIDEO';
      case ContentType.recording:
        return 'AUDIO';
      case ContentType.file:
        return 'FILE';
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}