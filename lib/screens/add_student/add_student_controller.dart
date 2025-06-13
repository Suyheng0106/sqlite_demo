part of 'add_student_screen.dart';

var firstNameCtrl = TextEditingController();
  var lastNameCtrl = TextEditingController();
  String selectedGender = "";
  var formattedDate = "";
  var selectedProfile = "";

  void clearData(){
    firstNameCtrl.clear();
    lastNameCtrl.clear();
    selectedGender = "";
    selectedProfile = "";
    formattedDate = "";
  }

  void loadData(Map<String, dynamic> data){
    firstNameCtrl.text = data["first_name"];
    lastNameCtrl.text = data["last_name"];
    selectedGender = data["gender"];
    formattedDate = data["dob"];
    selectedProfile = data["profile"];
  }