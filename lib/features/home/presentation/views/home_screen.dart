import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/core/widgets/theme_toggle_button.dart';
import 'package:flutterwidgets/features/home/presentation/widgets/build_search_results.dart';
import 'package:flutterwidgets/features/home/presentation/widgets/main_content.dart';
import '../../../community/models/owner_model.dart';
import '../../models/author_model.dart';
import '../../models/community_model.dart';
import '../widgets/home_header.dart';
import '../widgets/search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double buttonSize = 30.h;

    Widget layout;
    layout = _buildMobileLayout();
    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Stack(
          clipBehavior: Clip.none,
          children: [
            layout,
            Positioned(
              right: buttonSize,
              top: 10.h,
              child: Container(
                width: buttonSize,
                height: buttonSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: theme.colorScheme.surface.withOpacity(0.15),
                ),
                child: Center(
                  child: ThemeToggleButton(
                    isCompact: true,
                    size: 15.w,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        const HomeHeader(),
        Expanded(
          child: Container(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            child: const MainContent(),
          ),
        ),
      ],
    );
  }

}
