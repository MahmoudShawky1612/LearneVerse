import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/core/widgets/theme_toggle_button.dart';
import 'package:flutterwidgets/features/home/presentation/widgets/build_search_results.dart';
import 'package:flutterwidgets/features/home/presentation/widgets/main_content.dart';
import 'package:go_router/go_router.dart';
import '../../../../utils/token_storage.dart';
import '../../../community/models/owner_model.dart';
import '../../../login/presentation/widgets/snackbar.dart';
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

    final colorScheme = theme.colorScheme;


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
              right: buttonSize+15.h,
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
            Positioned(
               right: 5.h,
              top: 3.h,
              child:
            IconButton(
              icon: Icon(Icons.logout, color: colorScheme.onPrimary),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor:
                    const Color(0xFF1E1E1E),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    title: const Text(
                      'Confirm Logout',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    content: const Text(
                      'Are you sure you want to log out?',
                      style: TextStyle(color: Colors.white70),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel',
                            style: TextStyle(color: Colors.grey[400])),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          TokenStorage.deleteToken();
                          context.go('/login');
                          showPremiumSnackbar(
                            context,
                            message: "Logged out successfully",
                            isSuccess: true,
                          );
                        },
                        child: const Text('Logout',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                );
              },
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
