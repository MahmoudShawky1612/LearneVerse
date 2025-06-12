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
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart' hide PlayerState;
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
          final colorScheme = Theme.of(context).colorScheme;
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
                backgroundColor: colorScheme.surface,
                body: CustomScrollView(
                  slivers: [
                    // Modern App Bar
                    SliverAppBar(
                      expandedHeight: 160.h,
                      floating: false,
                      pinned: true,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                colorScheme.primary,
                                colorScheme.primary.withOpacity(0.8),
                              ],
                            ),
                          ),
                          child: SafeArea(
                            child: Padding(
                              padding: EdgeInsets.all(24.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 20.h),
                                  Text(
                                    'Learning Path',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 32.sp,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    currentSection?.name ?? '',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 16.sp,
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

                    // Section Tabs
                    SliverToBoxAdapter(
                      child: Container(
                        height: 100.h,
                        margin: EdgeInsets.symmetric(vertical: 16.h),
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
                                margin: EdgeInsets.only(right: 12.w),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 60.w,
                                      height: 60.h,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: isSelected
                                            ? LinearGradient(
                                                colors: [colorScheme.primary, colorScheme.primary.withOpacity(0.8)],
                                              )
                                            : null,
                                        color: isSelected ? null : Colors.grey[100],
                                        boxShadow: isSelected
                                            ? [
                                                BoxShadow(
                                                  color: colorScheme.primary.withOpacity(0.3),
                                                  blurRadius: 12.r,
                                                  offset: Offset(0, 4.h),
                                                ),
                                              ]
                                            : null,
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${index + 1}',
                                          style: TextStyle(
                                            color: isSelected ? Colors.white : Colors.grey[600],
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    SizedBox(
                                      width: 80.w,
                                      child: Text(
                                        section.name,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600,
                                          color: isSelected ? colorScheme.primary : Colors.grey[600],
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Container(
                                      width: 4.w,
                                      height: 4.h,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isSelected ? colorScheme.primary : Colors.transparent,
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

                    // Lessons List
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final lesson = lessons[index];
                            final isDone = lesson.isCompleted(userId);
                            bool isLocked = false;
                            // Use lesson.materials[0] for type and fileUrl if available
                            final material = lesson.materials.isNotEmpty ? lesson.materials[0] : null;
                            final fileUrl = material?.fileUrl ?? '';
                            final fileName = fileUrl.split('/').last;
                            final contentType = material?.type ?? ContentType.file;

                            return Container(
                              margin: EdgeInsets.only(bottom: 16.h),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: isLocked
                                      ? null
                                      : () {
                                          _showLessonDetail(context, lesson, contentType);
                                        },
                                  borderRadius: BorderRadius.circular(20.r),
                                  child: Container(
                                    padding: EdgeInsets.all(20.w),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20.r),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 20.r,
                                          offset: Offset(0, 8.h),
                                        ),
                                      ],
                                      border: isDone
                                          ? Border.all(
                                              color: const Color(0xFF4CAF50).withOpacity(0.3),
                                              width: 2.w,
                                            )
                                          : null,
                                    ),
                                    child: Row(
                                      children: [
                                        // Content Type Icon
                                        Container(
                                          width: 50.w,
                                          height: 50.h,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: _getContentTypeColor(contentType).withOpacity(0.1),
                                          ),
                                          child: Icon(
                                            _getContentTypeIcon(contentType),
                                            color: _getContentTypeColor(contentType),
                                            size: 24.sp,
                                          ),
                                        ),
                                        SizedBox(width: 16.w),
                                        // Lesson Content
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      _getContentTypeLabel(contentType),
                                                      style: TextStyle(
                                                        fontSize: 12.sp,
                                                        color: _getContentTypeColor(contentType),
                                                        fontWeight: FontWeight.w600,
                                                        letterSpacing: 0.5,
                                                      ),
                                                    ),
                                                  ),
                                                  if (isDone)
                                                    Container(
                                                      padding: EdgeInsets.symmetric(
                                                        horizontal: 8.w,
                                                        vertical: 4.h,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: const Color(0xFF4CAF50).withOpacity(0.1),
                                                        borderRadius: BorderRadius.circular(12.r),
                                                      ),
                                                      child: Text(
                                                        'DONE',
                                                        style: TextStyle(
                                                          color: const Color(0xFF4CAF50),
                                                          fontSize: 10.sp,
                                                          fontWeight: FontWeight.w700,
                                                          letterSpacing: 0.5,
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                              SizedBox(height: 6.h),
                                              Text(
                                                lesson.title,
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w700,
                                                  color: isLocked ? Colors.grey[400] : Colors.grey[800],
                                                  letterSpacing: -0.2,
                                                ),
                                              ),
                                              SizedBox(height: 8.h),
                                              Text(
                                                lesson.notes,
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  color: isLocked ? Colors.grey[300] : Colors.grey[600],
                                                  height: 1.4,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(height: 10.h),
                                              Row(
                                                children: [
                                                  if (isDone)
                                                    ElevatedButton.icon(
                                                      icon: Icon(Icons.undo, size: 18.sp),
                                                      label: Text('Undone'),
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: Colors.grey[200],
                                                        foregroundColor: Colors.grey[800],
                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                                                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                                                        elevation: 0,
                                                      ),
                                                      onPressed: () async {
                                                        await context.read<SectionsCubit>().toggleLessonCompleted(lesson.id, currentSection!.id);
                                                      },
                                                    )
                                                  else
                                                    ElevatedButton.icon(
                                                      icon: Icon(Icons.check, size: 18.sp),
                                                      label: Text('Done'),
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: Theme.of(context).colorScheme.primary,
                                                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                                                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                                                        elevation: 2,
                                                      ),
                                                      onPressed: () async {
                                                        await context.read<SectionsCubit>().toggleLessonCompleted(lesson.id, currentSection!.id);
                                                      },
                                                    ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Arrow
                                        if (!isLocked)
                                          Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            size: 16.sp,
                                            color: Colors.grey[400],
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

  Color _getContentTypeColor(ContentType type) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    switch (type) {
      case ContentType.document:
        return colorScheme.primary;
      case ContentType.image:
        return colorScheme.secondary;
      case ContentType.video:
        return colorScheme.tertiary;
      case ContentType.recording:
        return colorScheme.error;
      case ContentType.file:
        return colorScheme.outline;
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
    final colorScheme = Theme.of(context).colorScheme;
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
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: EdgeInsets.only(top: 12.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),

              // Header
              Container(
                padding: EdgeInsets.all(24.w),
                child: Row(
                  children: [
                    Container(
                      width: 60.w,
                      height: 60.h,
                      decoration: BoxDecoration(
                        color: _getContentTypeColor(widget.type),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Icon(
                        _getContentTypeIcon(widget.type),
                        color: Colors.white,
                        size: 30.sp,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getContentTypeLabel(widget.type),
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: _getContentTypeColor(widget.type),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            widget.lesson.title,
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                      iconSize: 24.sp,
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Content Display
                      _buildContentDisplay(),

                      SizedBox(height: 24.h),

                      // Description
                      Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        widget.lesson.notes,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                          height: 1.6,
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // Notes Section
                      Text(
                        'Lesson Notes',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 16.h),

                      ...widget.lesson.notes.split('\n').map((note) =>
                          Container(
                            margin: EdgeInsets.only(bottom: 12.h),
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: Colors.grey[200]!,
                                width: 1.w,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 6.w,
                                  height: 6.h,
                                  margin: EdgeInsets.only(top: 6.h),
                                  decoration: BoxDecoration(
                                    color: _getContentTypeColor(widget.type),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Text(
                                    note,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.grey[700],
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ).toList(),
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

  Widget _buildContentDisplay() {
    switch (widget.type) {
      case ContentType.document:
        return _buildDocumentViewer();
      case ContentType.image:
        return _buildImageViewer();
      case ContentType.video:
        return _buildVideoPlayer();
      case ContentType.recording:
        return _buildAudioPlayer();
      case ContentType.file:
        return _buildFileViewer();
    }
  }
  Widget _buildDocumentViewer() {
    final fileUrl = widget.lesson.materials[0].fileUrl;
    final materialType = widget.lesson.materials[0].type;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    if (materialType == ContentType.document || materialType == ContentType.file) {
      // Always show the URL as a clickable link for DOC or FILE
      return Center(
        child: InkWell(
          onTap: () async {
            final uri = Uri.parse(fileUrl);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            }
          },
          child: Text(
            fileUrl,
            style: TextStyle(
              color: colorScheme.primary,
              decoration: TextDecoration.underline,
              fontSize: 16,
            ),
          ),
        ),
      );
    }
    if (fileUrl.toLowerCase().endsWith('.pdf')) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.7,
        child: SfPdfViewer.network(
          fileUrl,
          canShowScrollStatus: true,
          onDocumentLoadFailed: (details) {
              Center(child: ErrorStateWidget(message: 'Failed to load PDF: ${details.description}', onRetry: () => setState(() {})));
          },
        ),
      );
    } else if (fileUrl.toLowerCase().endsWith('.doc') || fileUrl.toLowerCase().endsWith('.docx')) {
      final officeUrl = 'https://view.officeapps.live.com/op/embed.aspx?src=$fileUrl';
      final WebViewController controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(Uri.parse(officeUrl));
      return Container(
        height: MediaQuery.of(context).size.height * 0.7,
        child: WebViewWidget(controller: controller),
      );
    } else {
      // For any other file, show the URL as a clickable link
      return Center(
        child: InkWell(
          onTap: () async {
            final uri = Uri.parse(fileUrl);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            }
          },
          child: Text(
            fileUrl,
            style: TextStyle(
              color: colorScheme.primary,
              decoration: TextDecoration.underline,
              fontSize: 16,
            ),
          ),
        ),
      );
    }
  }

  Widget _buildFileViewer() {
    // For any file, just show the URL as a clickable link
    final fileUrl = widget.lesson.materials[0].fileUrl;
    final materialType = widget.lesson.materials[0].type;
    final colorScheme = Theme.of(context).colorScheme;
    if (materialType == ContentType.document || materialType == ContentType.file) {
      return Center(
        child: InkWell(
          onTap: () async {
            final uri = Uri.parse(fileUrl);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            }
          },
          child: Text(
            fileUrl,
            style: TextStyle(
              color: colorScheme.primary,
              decoration: TextDecoration.underline,
              fontSize: 16,
            ),
          ),
        ),
      );
    }
    // fallback for other types (shouldn't happen, but just in case)
    return Center(
      child: InkWell(
        onTap: () async {
          final uri = Uri.parse(fileUrl);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
        child: Text(
          fileUrl,
          style: TextStyle(
            color: colorScheme.primary,
            decoration: TextDecoration.underline,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
  Widget _buildImageViewer() {
    return Container(
      width: double.infinity,
      height: 250.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        image: DecorationImage(
          image: NetworkImage(widget.lesson.materials[0].fileUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildVideoPlayer() {
    final fileUrl = widget.lesson.materials[0].fileUrl;
    final youtubeId = YoutubePlayer.convertUrlToId(fileUrl);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    if (youtubeId != null) {
      return YoutubePlayer(
        controller: YoutubePlayerController(
          initialVideoId: youtubeId,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
          ),
        ),
        showVideoProgressIndicator: true,
      );
    }
    if (_videoController == null || !_videoController!.value.isInitialized) {
      return const Center(child: LoadingState());
    }
    if (_videoController!.value.hasError) {
      return Center(child: ErrorStateWidget(
        message: 'Failed to load video.',
        onRetry: () => setState(() { _videoController!.initialize(); }),
      ));
    }
    final position = _videoController!.value.position;
    final duration = _videoController!.value.duration;
    final timeLeft = duration - position;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AspectRatio(
          aspectRatio: _videoController!.value.aspectRatio,
          child: Stack(
            alignment: Alignment.center,
            children: [
              VideoPlayer(_videoController!),
              Positioned(
                left: 8,
                bottom: 8,
                child: Row(
                  children: [
                    Text(
                      _formatDuration(position),
                      style: TextStyle(color: colorScheme.onSurface),
                    ),
                    Text(
                      ' / ',
                      style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)),
                    ),
                    Text(
                      _formatDuration(duration),
                      style: TextStyle(color: colorScheme.onSurface),
                    ),
                    Text(
                      '  (left: ${_formatDuration(timeLeft)})',
                      style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7), fontSize: 12),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 8,
                bottom: 8,
                child: IconButton(
                  icon: Icon(Icons.fullscreen, color: Colors.white),
                  onPressed: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => Scaffold(
                          backgroundColor: Colors.black,
                          body: Center(
                            child: AspectRatio(
                              aspectRatio: _videoController!.value.aspectRatio,
                              child: VideoPlayer(_videoController!),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Center play/pause overlay button
              if (!_videoController!.value.isPlaying)
                Center(
                  child: IconButton(
                    icon: Icon(Icons.play_circle_fill, size: 64, color: colorScheme.primary),
                    onPressed: () {
                      setState(() {
                        _videoController!.play();
                      });
                    },
                  ),
                ),
              if (_videoController!.value.isPlaying)
                Center(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _videoController!.pause();
                      });
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Icon(Icons.pause_circle_filled, size: 64, color: colorScheme.primary.withOpacity(0.7)),
                    ),
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Text(_formatDuration(position), style: TextStyle(color: colorScheme.onSurface)),
              Expanded(
                child: Slider(
                  value: position.inSeconds.toDouble().clamp(0, duration.inSeconds.toDouble()),
                  min: 0,
                  max: duration.inSeconds.toDouble(),
                  onChanged: (value) {
                    _videoController!.seekTo(Duration(seconds: value.toInt()));
                    setState(() {});
                  },
                  activeColor: colorScheme.primary,
                  inactiveColor: colorScheme.onSurface.withOpacity(0.2),
                ),
              ),
              Text(_formatDuration(duration), style: TextStyle(color: colorScheme.onSurface)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAudioPlayer() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF9C27B0).withOpacity(0.1),
            const Color(0xFF9C27B0).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFF9C27B0).withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () async {
                  if (_isPlaying) {
                    await _audioPlayer!.pause();
                  } else {
                    await _audioPlayer!.play(UrlSource(widget.lesson.materials[0].fileUrl));
                  }
                },
                child: Container(
                  width: 60.w,
                  height: 60.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF9C27B0),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 30.sp,
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Audio Recording',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      widget.lesson.materials[0].fileUrl.split('/').last,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Text(
                _formatDuration(_position),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                ),
              ),
              Expanded(
                child: Slider(
                  value: _position.inSeconds.toDouble(),
                  max: _duration.inSeconds.toDouble(),
                  activeColor: const Color(0xFF9C27B0),
                  inactiveColor: Colors.grey[300],
                  onChanged: (value) async {
                    await _audioPlayer!.seek(Duration(seconds: value.toInt()));
                  },
                ),
              ),
              Text(
                _formatDuration(_duration),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  Color _getContentTypeColor(ContentType type) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    switch (type) {
      case ContentType.document:
        return colorScheme.primary;
      case ContentType.image:
        return colorScheme.secondary;
      case ContentType.video:
        return colorScheme.tertiary;
      case ContentType.recording:
        return colorScheme.error;
      case ContentType.file:
        return colorScheme.outline;
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
}