part of 'home_screen.dart';

var listStudent = [];

void loadData(Function(dynamic) onLoad) async {
  var item = await DbHelper.getStudents();

  listStudent = item;

  onLoad(listStudent);

  print("Student : ${listStudent}");
}
