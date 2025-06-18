import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});


  void _signUp() async {
    final Uri uri = Uri.parse('http://192.168.1.104:3000/sign-up');
    if (!await launchUrl(uri)) {
      throw 'Could not launch $uri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: _signUp,
        child: const Text(
            "Or join LearnVerse"));
  }
}
