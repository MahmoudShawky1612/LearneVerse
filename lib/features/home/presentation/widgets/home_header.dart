import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutterwidgets/core/providers/user_provider.dart';

import '../../../../core/constants/app_colors.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({super.key});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

bool isClicked = false;

class _HomeHeaderState extends State<HomeHeader> {
  @override
  Widget build(BuildContext context) {
    final themeExtension = Theme.of(context).extension<AppThemeExtension>();
    final screenWidth = MediaQuery.of(context).size.width;
    final baseFontSize = screenWidth < 360 ? 20.sp : screenWidth < 600 ? 24.sp : 28.sp;
    final userProvider = Provider.of<UserProvider>(context);
    final currentUser = userProvider.currentUser;
    
    return Container(
      height: 115.h,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: themeExtension?.backgroundGradient,
        borderRadius:   BorderRadius.only(
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
              child: isClicked == false
                  ? CircleAvatar(
                      radius:  17.r,
                      backgroundImage: AssetImage(currentUser.avatar),
                    )
                  : const CircularProgressIndicator(),
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
              currentUser.name.toUpperCase(),
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
