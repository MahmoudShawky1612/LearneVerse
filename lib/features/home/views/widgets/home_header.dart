import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/utils/jwt_helper.dart';
import 'package:flutterwidgets/utils/token_storage.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../utils/url_helper.dart'; // Add this import

class HomeHeader extends StatefulWidget {
  const HomeHeader({super.key});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  String? fullName;
  String? pP;
  bool isClicked = false;
  bool isLoading = true;

  Future<void> _getUserData() async {
    try {
      final token = await TokenStorage.getToken() ?? '';
      if (token.isEmpty) {
        setState(() {
          fullName = 'Guest';
          pP = null;
          isLoading = false;
        });
        return;
      }

      final fullname = getFullNameFromToken(token);
      final pp = getUserProfilePictureURLFromToken(token);
      setState(() {
        fullName = fullname;
        pP = pp;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        fullName = 'Guest';
        pP = null;
        isLoading = false;
      });
    }
  }

  Future<int> getUserId() async {
    final token = await TokenStorage.getToken();
    if (token != null) {
      return getUserIdFromToken(token);
    }
    return 0;
  }

  void goToProfile() async {
    final userId = await getUserId();
    if (userId != 0) {
      context.push('/profile', extra: userId);
    }
  }

  @override
  void initState() {
    super.initState();
    fullName = 'Loading...';
    _getUserData();
  }

  @override
  Widget build(BuildContext context) {
    final themeExtension = Theme.of(context).extension<AppThemeExtension>();
    final screenWidth = MediaQuery.of(context).size.width;
    final baseFontSize = screenWidth < 360
        ? 20.sp
        : screenWidth < 600
            ? 24.sp
            : 28.sp;

    return Container(
      height: 115.h,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: themeExtension?.backgroundGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25.r),
          bottomRight: Radius.circular(25.r),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.red, width: 1.5.w),
            ),
            child: GestureDetector(
              onTap: () => goToProfile(),
              child: SizedBox(
                width: 34.r,
                height: 34.r,
                child: isClicked || isLoading
                    ? const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child:
                              CupertinoActivityIndicator(color: Colors.white),
                        ),
                      )
                    : CircleAvatar(
                        radius: 17.r,
                        backgroundImage: pP != null && pP != ''
                            ? NetworkImage(
                                UrlHelper.transformUrl(pP!),
                                headers: {
                                  'ngrok-skip-browser-warning': 'true',
                                },
                              )
                            : null,
                        backgroundColor: Colors.grey[200],
                        onBackgroundImageError: pP != null && pP != ''
                            ? (exception, stackTrace) {}
                            : null,
                        child: Icon(
                          Icons.person,
                          color: Colors.blue,
                          size: 20.sp,
                        ),
                      ),
              ),
            ),
          ),
          SizedBox(width: screenWidth < 360 ? 4.w : 5.w),
          Flexible(
            child: Text(
              'Welcome,',
              style: TextStyle(
                color: Colors.white,
                fontSize: baseFontSize - 4.sp,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          SizedBox(width: screenWidth < 360 ? 4.w : 5.w),
          Flexible(
            child: Text(
              fullName?.toUpperCase() ?? 'Guest',
              style: TextStyle(
                color: Colors.white,
                fontSize: baseFontSize - 4.sp,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
