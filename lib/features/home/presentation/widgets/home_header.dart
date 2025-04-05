import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterwidgets/routing/routes.dart';
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
    final baseFontSize = screenWidth < 360 ? 20.0 : screenWidth < 600 ? 24.0 : 28.0;
    final userProvider = Provider.of<UserProvider>(context);
    final currentUser = userProvider.currentUser;
    
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: themeExtension?.backgroundGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.red, width: 2),
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
                      radius: screenWidth < 360 ? 25 : 30,
                      backgroundImage: AssetImage(currentUser.avatar),
                    )
                  : const CircularProgressIndicator(),
            ),
          ),
          SizedBox(width: screenWidth < 360 ? 4 : 5),
          Flexible(
            child: Text(
              'Welcome,',
              style: TextStyle(
                color: Colors.white,
                fontSize: baseFontSize,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          SizedBox(width: screenWidth < 360 ? 4 : 5),
          Flexible(
            child: Text(
              currentUser.name.toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontSize: baseFontSize,
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
