import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/utils/jwt_helper.dart';
import 'package:flutterwidgets/utils/token_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:flutterwidgets/core/providers/user_provider.dart';

import '../../../../core/constants/app_colors.dart';

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

      final fullname = await getFullNameFromToken(token);
      final pp = await getUserProfilePictureURLFromToken(token);
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

  @override
  void initState() {
    super.initState();
    fullName = 'Loading...';
    pP = null;
    _getUserData();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
              onTap: () {
                setState(() {
                  isClicked = true;
                });
                Future.delayed(const Duration(seconds: 2), () {
                  context.push('/profile');
                  setState(() {
                    isClicked = false;
                  });
                });
              },
              child: SizedBox(
                width: 34.r,
                height: 34.r,
                child: isClicked || isLoading
                    ? const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CupertinoActivityIndicator(color: Colors.white),
                  ),
                )
                    : CircleAvatar(
                  radius: 17.r,
                  backgroundImage: pP != null ? NetworkImage(pP!) : null,
                  backgroundColor: Colors.grey[200],
                  child: pP == null
                      ? Icon(Icons.person, color: Colors.grey[600])
                      : null,
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