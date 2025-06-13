import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sqlite_demo/db_helper/db_helper.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  var firstNameCtrl = TextEditingController();
  var lastNameCtrl = TextEditingController();
  String selectedGender = "";
  var formattedDate = "";

  List<Map<String, dynamic>> studentItems = [];

  var selectedProfile = "";

  bool isEdit = false;

  int id = 0;

  void loadData() async {
    var item = await DbHelper.getStudents();
    setState(() {
      studentItems = item;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: buildSelectPf(),
                ),

                TextField(
                  controller: firstNameCtrl,
                  decoration: InputDecoration(
                    hintText: "Enter First Name",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: lastNameCtrl,
                  decoration: InputDecoration(
                    hintText: "Enter Last Name",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    buildRadioBtn(gender: "Male"),
                    buildRadioBtn(gender: "Female"),
                  ],
                ),

                buildSelectDOB(),

                ElevatedButton(
                  onPressed: () async {
                    if (isEdit) {
                      await DbHelper.updateStudent(
                        firstNameCtrl.text,
                        lastNameCtrl.text,
                        selectedGender,
                        formattedDate,
                        selectedProfile,
                        id,
                      );
                    } else {
                      await DbHelper.insertStudent(
                        firstNameCtrl.text,
                        lastNameCtrl.text,
                        selectedGender,
                        formattedDate,
                        selectedProfile,
                      );
                    }

                    loadData();

                    firstNameCtrl.clear();
                    lastNameCtrl.clear();
                  },
                  child: Text(isEdit ? "Edit Student" : "Add Student"),
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("All Students"),
                ),
                studentItems.isEmpty
                    ? Center(child: Text("No Student"))
                    : Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return Dismissible(
                            key: Key(studentItems[index]["id"].toString()),
                            confirmDismiss: (direction) async {
                              // await DbHelper.deleteStudent(
                              //   studentItems[index]["id"]
                              // );

                              // loadData();

                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Are you sure?"),
                                    content: Text(
                                      "Are you sure you want to delete ${studentItems[index]["first_name"]} ${studentItems[index]["last_name"]}",
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          DbHelper.deleteStudent(
                                            studentItems[index]["id"],
                                          );
                                          loadData();
                                          Navigator.pop(context);
                                        },
                                        child: Text("Yes"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("No"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            background: Container(
                              padding: EdgeInsets.only(right: 20),
                              alignment: Alignment.centerRight,
                              color: Colors.red,
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                            child: ListTile(
                              leading: Image.file(
                                File(studentItems[index]["profile"]),
                                errorBuilder: (context, error, stackTrace) {
                                  return Container();
                                },
                              ),
                              title: Text(
                                "Full Name : ${studentItems[index]["first_name"]} ${studentItems[index]["last_name"]}",
                              ),
                              subtitle: Row(
                                children: [
                                  Text(
                                    "Gender : ${studentItems[index]["gender"]}",
                                  ),

                                  SizedBox(
                                    height: 15,
                                    child: VerticalDivider(
                                      width: 20,
                                      thickness: 2,
                                      color: Colors.grey,
                                    ),
                                  ),

                                  Expanded(
                                    child: Text(
                                      "DOB : ${studentItems[index]["dob"]}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isEdit = true;

                                    firstNameCtrl.text =
                                        studentItems[index]["first_name"];

                                    lastNameCtrl.text =
                                        studentItems[index]["last_name"];

                                    selectedGender =
                                        studentItems[index]["gender"];

                                    formattedDate = studentItems[index]["dob"];

                                    selectedProfile =
                                        studentItems[index]["profile"];

                                    id = studentItems[index]["id"];
                                  });
                                },
                                child: Icon(Icons.edit),
                              ),
                            ),
                          );
                        },
                        itemCount: studentItems.length,
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSelectDOB() {
    return GestureDetector(
      onTap: () async {
        var pickedDate = await showDatePicker(
          initialDate: DateTime.now(),
          context: context,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (pickedDate != null) {
          setState(() {
            formattedDate = DateFormat(
              "EEE dd, MMMM - yyyy",
            ).format(pickedDate);
          });
        }
      },
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: Center(
          child: Text(formattedDate.isEmpty ? "Select DOB" : formattedDate),
        ),
      ),
    );
  }

  Widget buildRadioBtn({required String gender}) {
    return Row(
      children: [
        Radio<String>(
          value: gender,
          groupValue: selectedGender,
          onChanged: (value) {
            setState(() {
              selectedGender = value!;
            });
          },
        ),
        Text(gender),
      ],
    );
  }

  Widget buildSelectPf() {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Select Profile"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text("Choose Photo"),
                    onTap: () async {
                      Navigator.pop(context);
                      var pickedPath = await ImagePicker().pickImage(
                        source: ImageSource.gallery,
                      );
                      setState(() {
                        selectedProfile = pickedPath!.path;
                      });
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.camera),
                    title: Text("Take Photo"),
                    onTap: () async {
                      Navigator.pop(context);
                      var pickedPath = await ImagePicker().pickImage(
                        source: ImageSource.camera,
                      );
                      setState(() {
                        selectedProfile = pickedPath!.path;
                      });
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle),
        child:
            selectedProfile.isEmpty
                ? Center(
                  child: Text(
                    "Select Profile",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
                : Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: Image.file(File(selectedProfile), fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) {
                    return Container();
                  },),
                ),
      ),
    );
  }
}
