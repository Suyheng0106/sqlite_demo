import 'dart:io';

import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sqlite_demo/config/appcolors.dart';
import 'package:sqlite_demo/db_helper/db_helper.dart';

part 'add_student_controller.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  var studentData;
  var isUpdate = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    clearData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    studentData =
        (ModalRoute.of(context)!.settings.arguments ?? []) as List<dynamic>;

    if (studentData.isNotEmpty) {
      isUpdate = studentData[0];
      firstNameCtrl.text = studentData[1]["first_name"];
      lastNameCtrl.text = studentData[1]["last_name"];
      selectedGender = studentData[1]["gender"];
      formattedDate = studentData[1]["dob"];
      selectedProfile = studentData[1]["profile"];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Appcolors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Appcolors.backgroundColor,
        title: Text(
          isUpdate
              ? "Update Student".toUpperCase()
              : "Add Student".toUpperCase(),
          style: GoogleFonts.spaceGrotesk(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: buildProfile(),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "First Name",
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: firstNameCtrl,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  hintText: "Enter First Name",
                  hintStyle: GoogleFonts.spaceGrotesk(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Last Name",
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: lastNameCtrl,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  hintText: "Enter Last Name",
                  hintStyle: GoogleFonts.spaceGrotesk(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Gender",
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  buildRadioBtn(gender: "Male"),
                  buildRadioBtn(gender: "Female"),
                ],
              ),
              Text(
                "Date of Birth",
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              buildSelectDOB(),
              ElevatedButton(
                onPressed: () async {
                  isUpdate
                      ? await DbHelper.updateStudent(
                          firstNameCtrl.text,
                          lastNameCtrl.text,
                          selectedGender,
                          formattedDate,
                          selectedProfile,
                          studentData[1] ["id"],
                        )
                      : await DbHelper.insertStudent(
                          firstNameCtrl.text,
                          lastNameCtrl.text,
                          selectedGender,
                          formattedDate,
                          selectedProfile,
                        );

                  Navigator.pop(context);
                },
                child: Text(isUpdate ? "Update Student" : "Add Student"),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProfile() {
    return badges.Badge(
      badgeContent: GestureDetector(
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
                        var pickedPath = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);

                        print("Picked image path: ${pickedPath!.path}");

                        setState(() {
                          selectedProfile = pickedPath.path;
                        });
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.camera_alt),
                      title: Text("Take a Photo"),
                      onTap: () async {
                        Navigator.pop(context);
                        var pickedPath = await ImagePicker()
                            .pickImage(source: ImageSource.camera);

                        print("Picked image path: ${pickedPath!.path}");

                        setState(() {
                          selectedProfile = pickedPath.path;
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Icon(
          Icons.add,
          color: Appcolors.backgroundColor,
        ),
      ),
      position: badges.BadgePosition.bottomEnd(
        bottom: 5,
        end: 5,
      ),
      badgeStyle: badges.BadgeStyle(
        badgeColor: Appcolors.primaryColor,
      ),
      child: Container(
        clipBehavior: Clip.hardEdge,
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.amber,
        ),
        child: selectedProfile.isEmpty
            ? Image.network(
                "https://static.vecteezy.com/system/resources/previews/036/280/651/non_2x/default-avatar-profile-icon-social-media-user-image-gray-avatar-icon-blank-profile-silhouette-illustration-vector.jpg") //replace with empty profile "Image.asset()"
            : Image.file(
                File(selectedProfile),
                fit: BoxFit.cover,
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
            formattedDate =
                DateFormat("EEE dd, MMMM - yyyy").format(pickedDate);
          });

          print("Fomatted date : $formattedDate");
        }
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.black,
            width: 2,
          ),
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
            print(value);
            setState(() {
              selectedGender = value!;
            });
          },
        ),
        Text(gender),
      ],
    );
  }
}
