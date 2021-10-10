import 'package:drawerbehavior/drawerbehavior.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import './edit_user_profile.dart';
import '../posts/admin_events.dart';
import '../../../widgets/blue_bubble_design.dart';
import '../../../widgets/constants.dart';
import '../../../widgets/gradient_button.dart';

class UserProfileDetails extends StatefulWidget {
  String uid,
      firstName,
      lastName,
      phoneNumber,
      emailId,
      memberRole,
      gender,
      placeOfWork;
  DateTime dateOfBirth;

  UserProfileDetails(
      {required this.uid,
      required this.firstName,
      required this.lastName,
      required this.phoneNumber,
      required this.emailId,
      required this.dateOfBirth,
      required this.memberRole,
      required this.gender,
      required this.placeOfWork});
  @override
  _UserProfileDetailsState createState() => _UserProfileDetailsState();
}

class _UserProfileDetailsState extends State<UserProfileDetails> {
  var userInfo;
  final DrawerScaffoldController controller = DrawerScaffoldController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    String firstName = widget.firstName,
        lastName = widget.lastName,
        phoneNumber = widget.phoneNumber,
        emailId = widget.emailId,
        memberRole = widget.memberRole,
        gender = widget.gender,
        placeOfWork = widget.placeOfWork,
        uid = widget.uid;
    DateTime dateOfBirth = widget.dateOfBirth;
    String formattedDateOfBirth =
        DateFormat('dd MMM, yyyy').format(dateOfBirth);

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: <Widget>[
                MainPageBlueBubbleDesign(),
                Positioned(
                  child: AppBar(
                    centerTitle: true,
                    title: Text(
                      "YWCA OF BOMBAY",
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w800,
                        fontSize: 18.0,
                        color: Colors.black87,
                      ),
                    ),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Discussions()));
                      },
                    ),
                  ),
                ),
                PreferredSize(
                  preferredSize: Size.fromHeight(90),
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        // Distance from ywca
                        // or else it will overlap
                        SizedBox(height: 90),
                        RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.bodyText2,
                            children: [
                              TextSpan(
                                text: 'USER PROFILE',
                                style: TextStyle(
                                  fontSize: 32,
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'RacingSansOne',
                                  letterSpacing: 2.5,
                                  shadows: <Shadow>[
                                    Shadow(
                                      offset: Offset(2.0, 3.0),
                                      blurRadius: 3.0,
                                      color: Color(0xff333333),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                      left: _width * 0.05, right: _width * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: _height * 0.02),
                      if (memberRole != "Staff") ...[
                        Text(
                          'You can choose to edit this information by clicking the button at the bottom.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ],
                      SizedBox(height: _height * 0.04),
                      //main_body
                      Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name = firstName + lastName
                            DetailText(text: 'Name: $firstName $lastName'),
                            SizedBox(height: 15),
                            // Phone
                            DetailText(text: 'Phone number: +91 $phoneNumber'),
                            SizedBox(height: 15),
                            // Email id
                            DetailText(text: 'Email ID: $emailId'),
                            SizedBox(height: 15),
                            // Date of birth
                            DetailText(
                                text: 'Date Of Birth: $formattedDateOfBirth'),
                            SizedBox(height: 15),
                            // User Role
                            DetailText(text: 'User Role: $memberRole'),
                            SizedBox(height: 15),
                            // Gender
                            DetailText(text: 'Gender: $gender'),
                            SizedBox(height: 15),
                            // Place of work/school/college
                            DetailText(
                                text: 'Institute/Organization: $placeOfWork'),
                            SizedBox(height: 15),
                          ],
                        ),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(40.0)),
                          color: Color(0x1A49DEE8),
                        ),
                      ),
                      SizedBox(height: _height * 0.02),
                      GradientButton(
                        buttonText: 'Edit User Profile',
                        screenHeight: _height,
                        onPressedFunction: () {
                          goToEditUserProfile(
                              context,
                              uid,
                              firstName,
                              lastName,
                              phoneNumber,
                              emailId,
                              dateOfBirth,
                              memberRole,
                              gender,
                              placeOfWork);
                        },
                      ),
                      SizedBox(height: _height * 0.02),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  goToEditUserProfile(
      BuildContext context,
      String uid,
      String firstName,
      String lastName,
      String phoneNumber,
      String emailId,
      DateTime dateOfBirth,
      String memberRole,
      String gender,
      String placeOfWork) {
    // DateTime newdateOfBirth = dateOfBirth.toDate();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditUserProfile(
          uid: uid,
          firstName: firstName,
          lastName: lastName,
          phoneNumber: phoneNumber,
          emailId: emailId,
          dateOfBirth: dateOfBirth,
          userRole: memberRole,
          gender: gender,
          placeOfWork: placeOfWork,
        ),
      ),
    );
  }
}

class DetailText extends StatelessWidget {
  final String text;
  DetailText({required this.text});
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        color: Color(0xff333333),
        fontFamily: 'Montserrat',
      ),
    );
  }
}
