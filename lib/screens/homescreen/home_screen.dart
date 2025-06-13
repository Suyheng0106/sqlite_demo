import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sqlite_demo/config/appcolors.dart';
import 'package:sqlite_demo/db_helper/db_helper.dart';
import 'package:sqlite_demo/routes/routes.dart';

part 'home_screen_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadData((listStudent) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeader(),
            buildBody(),
            buildDisplayStudent(),
          ],
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Appcolors.primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      padding: EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height * 0.40,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "good\nmorning!".toUpperCase(),
            style: GoogleFonts.spaceGrotesk(
              color: Appcolors.backgroundColor,
              height: 1,
              fontSize: 70,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "You have 0 student in your class!",
            style: GoogleFonts.spaceGrotesk(
              color: Appcolors.backgroundColor,
              height: 1,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBody() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Get started".toUpperCase(),
            style: GoogleFonts.spaceGrotesk(
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 220,
            width: double.infinity,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return buildListCard();
              },
              itemCount: 2,
            ),
          )
        ],
      ),
    );
  }

  Widget buildListCard() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.addStudent,
        ).then(
          (value) {
            loadData((listStudent) {
              setState(() {});
            });
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Container(
          padding: EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width * 0.8,
          height: 220,
          decoration: BoxDecoration(
            color: Appcolors.secondaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Appcolors.backgroundColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Appcolors.backgroundColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Text(
                "Add student".toUpperCase(),
                style: GoogleFonts.spaceGrotesk(
                  color: Appcolors.backgroundColor,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Add student to your class",
                style: GoogleFonts.spaceGrotesk(
                  color: Appcolors.backgroundColor,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDisplayStudent() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "All Student".toUpperCase(),
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Text(
                "View all".toUpperCase(),
                style: GoogleFonts.spaceGrotesk(
                  color: Appcolors.secondaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                Icons.arrow_forward,
                color: Appcolors.secondaryColor,
              )
            ],
          ),
          buildStudentList(),
        ],
      ),
    );
  }

  Widget buildStudentList() {
    return ListView.builder(
      padding: EdgeInsets.only(top: 10),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 15),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Appcolors.primaryColor,
                    width: 2,
                  ),
                  shape: BoxShape.circle,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.file(
                    File(listStudent[index]["profile"]),
                    fit: BoxFit.cover,
                    width: 60,
                    height: 60,
                    errorBuilder: (context, error, stackTrace) {
                      return Container();
                    },
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Full Name : ${listStudent[index]["first_name"]} ${listStudent[index]["last_name"]}",
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    "Gender : ${listStudent[index]["gender"]}",
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  )
                ],
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    showDragHandle: true,
                    builder: (context) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                Routes.addStudent,
                                arguments: [
                                  true,
                                  listStudent[index],
                                ],
                              ).then(
                                (value) {
                                  loadData((listStudent) {
                                    setState(() {});
                                  });
                                },
                              );
                            },
                            leading: Icon(Icons.edit),
                            title: Text(
                              "Update Student",
                              style: GoogleFonts.spaceGrotesk(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            subtitle: Text(
                              "Update student details",
                              style: GoogleFonts.spaceGrotesk(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 17,
                              ),
                            ),
                          ),
                          ListTile(
                            onTap: () {
                              Navigator.pop(context);
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Are you sure?"),
                                    content: Text(
                                        "Are you sure you wanna delete ${listStudent[index]["first_name"]} ${listStudent[index]["last_name"]}?"),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          DbHelper.deleteStudent(
                                              listStudent[index]["id"]);

                                          loadData(
                                            (p0) {
                                              setState(() {});
                                            },
                                          );
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
                            leading: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            title: Text(
                              "Delete Student",
                              style: GoogleFonts.spaceGrotesk(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            subtitle: Text(
                              "Delete student details",
                              style: GoogleFonts.spaceGrotesk(
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                                fontSize: 17,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Icon(
                  Icons.more_horiz,
                  size: 30,
                ),
              ),
            ],
          ),
        );
      },
      itemCount: listStudent.length,
    );
  }
}
