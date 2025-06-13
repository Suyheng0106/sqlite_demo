import 'package:flutter/material.dart';
import 'package:sqlite_demo/routes/page_route.dart';
import 'package:sqlite_demo/routes/routes.dart';
import 'package:sqlite_demo/screens/student_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: Routes.home,
      routes: PageRoutes.pageRoutes,
    );
  }
}
