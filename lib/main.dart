import 'package:flutter/material.dart';
import 'package:flutterwidgets/features/home/presentation/views/home_screen.dart';
import 'package:flutterwidgets/routing/routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
       routerConfig: route,
    );
  }
}
