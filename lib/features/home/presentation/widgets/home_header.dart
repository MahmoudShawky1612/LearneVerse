import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterwidgets/routing/routes.dart';
import 'package:go_router/go_router.dart';

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
    
    return Positioned(
      left: 0,
      right: 0,
      top: 0,
      child: Container(
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
                    ? const CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage('assets/images/avatar.jpg'),
                      )
                    : const CircularProgressIndicator(),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            const Text(
              'Welcome,',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            const Text(
              'DODJE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
