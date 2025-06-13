import 'package:sqlite_demo/routes/routes.dart';
import 'package:sqlite_demo/screens/add_student/add_student_screen.dart';
import 'package:sqlite_demo/screens/homescreen/home_screen.dart';
import 'package:sqlite_demo/screens/student_screen.dart';

class PageRoutes {
  static var pageRoutes = {
    Routes.home: (context) => HomeScreen(),
    Routes.addStudent: (context) => AddStudentScreen(),
    Routes.student: (context) => StudentScreen(),
  };
}