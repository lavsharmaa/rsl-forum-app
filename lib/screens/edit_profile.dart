import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import '../widgets/constants.dart';
import '../widgets/gradient_button.dart';
import '../models/User.dart';
import 'package:intl/date_symbol_data_local.dart';
// enum GenderChoices { female, male, declineToState }

// ignore: must_be_immutable
class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String firstName = '';
  String lastName = '';
  String email = '';
  String phoneNumber = '';
  String gender = "Female";
  late DateTime dateOfBirth;
  String placeOfWork = '';
  String uid = '';
  String role = "";
  String profession = "Student";
  var userInfo;

  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // form key for validation

  final GlobalKey<ScaffoldState> _scaffoldkey =
      GlobalKey<ScaffoldState>(); // scaffold key for snack bar

  // GenderChoices selectedGender = GenderChoices.female;

  // female-0, male-1, decline to state-2
  int _genderRadioValue = 0;
  void _handleGenderRadioValueChange(int? value) {
    setState(() {
      _genderRadioValue = value!;
      if (_genderRadioValue == 0) {
        gender = "Female";
      } else if (_genderRadioValue == 1) {
        gender = "Male";
      } else {
        gender = "Decline to state";
      }
      print("gender selected: $gender");
    });
  }

  DateTime selectedDate = DateTime.now();
  TextEditingController dateController = TextEditingController();

  Future _selectDate(context) async {
    initializeDateFormatting();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dateOfBirth,
      firstDate: DateTime(1940),
      lastDate: DateTime.now().subtract(Duration(days: 4380)),
      helpText: 'Select Date of Event',
      fieldLabelText: 'Enter date of Event',
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFF49dee8),
            accentColor: const Color(0xFF49dee8),
            colorScheme: ColorScheme.light(primary: const Color(0xFF49dee8)),
            dialogBackgroundColor: Colors.white, // calendar bg color
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: secondaryColor, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != dateOfBirth) {
      setState(() {
        dateOfBirth = picked;
      });
    }
  }

  _onBackPressed() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Do you want to exit without saving changes?'),
          content: Text('Press the SAVE button if you wish to save changes'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('YES'),
              onPressed: () {
                Navigator.of(context).pop(true);
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    userInfo = Provider.of<UserData>(context, listen: false);
    uid = userInfo.getuid;
    firstName = userInfo.getfirstName;
    lastName = userInfo.getlastName;
    email = userInfo.getemailId;
    phoneNumber = userInfo.getphoneNumber;
    dateOfBirth = userInfo.getdateOfBirth;
    gender = userInfo.getgender;
    placeOfWork = userInfo.getplaceOfWork;
    role = userInfo.getmemberRole;
    profession = "Student";
    if (gender == "Male") {
      _genderRadioValue = 1;
    } else if (gender == "Female") {
      _genderRadioValue = 0;
    } else {
      _genderRadioValue = 2;
    }
    dateController.text =
        DateFormat('dd-MM-yyyy').format(userInfo.getdateOfBirth);

    super.initState();
  }

  final int height = 1;
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () => _onBackPressed(),
      child: Scaffold(
        key: _scaffoldkey,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Positioned(
                        child: AppBar(
                          centerTitle: true,
                          title: Text(
                            "RSL Forum",
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
                              _onBackPressed();
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: _height * 0.095),
                            child: Text(
                              'EDIT PROFILE',
                              style: TextStyle(
                                fontSize: 35,
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'RacingSansOne',
                                shadows: <Shadow>[
                                  Shadow(
                                    offset: Offset(2.0, 3.0),
                                    blurRadius: 3.0,
                                    color: Color(0xff333333),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Form
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: _height * 0.02,
                      horizontal: _width * 0.04,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            initialValue: firstName,
                            keyboardType: TextInputType.text,
                            onSaved: (value) {
                              setState(() {
                                firstName = value!;
                              });
                            },
                            validator: (value) {
                              if (value!.isEmpty)
                                return 'First name is required.';
                              else
                                return null;
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.account_circle,
                                color: secondaryColor,
                              ),
                              labelText: 'First Name',
                              filled: true,
                              fillColor: formFieldFillColor,
                              disabledBorder: InputBorder.none,
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: formFieldFillColor),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: formFieldFillColor),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              errorBorder: InputBorder.none,
                            ),
                          ),
                          SizedBox(height: _height * 0.015),
                          TextFormField(
                            initialValue: lastName,
                            keyboardType: TextInputType.text,
                            onSaved: (value) {
                              setState(() {
                                lastName = value!;
                              });
                            },
                            validator: (value) {
                              if (value!.isEmpty)
                                return 'Last name is required.';
                              else
                                return null;
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.account_circle,
                                color: secondaryColor,
                              ),
                              labelText: 'Last Name',
                              filled: true,
                              fillColor: formFieldFillColor,
                              disabledBorder: InputBorder.none,
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: formFieldFillColor),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: formFieldFillColor),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              errorBorder: InputBorder.none,
                            ),
                          ),
                          SizedBox(height: _height * 0.015),
                          TextFormField(
                            readOnly: true,
                            onChanged: (value) {
                              setState(() {});
                            },
                            controller: dateController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.date_range,
                                color: secondaryColor,
                              ),
                              labelText: 'Date of Birth',
                              filled: true,
                              fillColor: formFieldFillColor,
                              disabledBorder: InputBorder.none,
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: formFieldFillColor),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: formFieldFillColor),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              errorBorder: InputBorder.none,
                            ),
                            onTap: () async {
                              FocusScope.of(context).requestFocus(FocusNode());
                              await _selectDate(context);
                              dateController.text =
                                  "${dateOfBirth.toLocal()}".split(' ')[0];
                            },
                          ),
                          SizedBox(height: _height * 0.015),
                          TextFormField(
                            initialValue: userInfo.getemailId,
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (value) {
                              setState(() {
                                email = value!;
                              });
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.email,
                                color: secondaryColor,
                              ),
                              labelText: 'Email Address',
                              filled: true,
                              fillColor: formFieldFillColor,
                              disabledBorder: InputBorder.none,
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: formFieldFillColor),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: formFieldFillColor),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              errorBorder: InputBorder.none,
                            ),
                          ),
                          SizedBox(height: _height * 0.015),
                          Text(
                            'Gender',
                            style: TextStyle(
                              fontSize: 18,
                              color: primaryColor,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Radio(
                                value: 0,
                                groupValue: _genderRadioValue,
                                onChanged: _handleGenderRadioValueChange,
                                focusColor: secondaryColor,
                                hoverColor: secondaryColor,
                                activeColor: secondaryColor,
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _genderRadioValue = 0;
                                      _handleGenderRadioValueChange(
                                          _genderRadioValue);
                                    });
                                  },
                                  child: Text(
                                    'Female',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              Radio(
                                value: 1,
                                groupValue: _genderRadioValue,
                                onChanged: _handleGenderRadioValueChange,
                                focusColor: secondaryColor,
                                hoverColor: secondaryColor,
                                activeColor: secondaryColor,
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _genderRadioValue = 1;
                                      _handleGenderRadioValueChange(
                                          _genderRadioValue);
                                    });
                                  },
                                  child: Text(
                                    'Male',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              Radio(
                                value: 2,
                                groupValue: _genderRadioValue,
                                onChanged: _handleGenderRadioValueChange,
                                focusColor: secondaryColor,
                                hoverColor: secondaryColor,
                                activeColor: secondaryColor,
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _genderRadioValue = 2;
                                      _handleGenderRadioValueChange(
                                          _genderRadioValue);
                                    });
                                  },
                                  child: Text(
                                    'Decline to state',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            initialValue: userInfo.getplaceOfWork,
                            keyboardType: TextInputType.text,
                            onSaved: (value) {
                              setState(() {
                                if (value == '') {
                                  placeOfWork = 'Retired';
                                } else {
                                  placeOfWork = value!;
                                }
                              });
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.location_city,
                                color: secondaryColor,
                              ),
                              labelText: 'Place of work/school/college',
                              filled: true,
                              disabledBorder: InputBorder.none,
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: formFieldFillColor),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: formFieldFillColor),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              errorBorder: InputBorder.none,
                            ),
                          ),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  child: Text(
                                    '(Leave blank if retired)',
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 15,
                                    ),
                                  ),
                                  padding: EdgeInsets.only(
                                    top: 2.5,
                                    bottom: 2.5,
                                    right: 3,
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(height: _height * 0.005),
                          GradientButton(
                            buttonText: 'Update Profile',
                            screenHeight: _height,
                            onPressedFunction: () async {
                              print(userInfo.getmemberRole);
                              if (_formKey.currentState!.validate() != true) {
                                Vibration.vibrate(duration: 100);
                                return;
                              }
                              _formKey.currentState!.save();

                              print("updating as it is non-member");
                              await FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(uid)
                                  .update({
                                "firstName": firstName,
                                "lastName": lastName,
                                "dateOfBirth": dateOfBirth,
                                "emailId": email,
                                "gender": gender,
                                "placeOfWork": placeOfWork,
                                "uid": uid,
                                "phoneNumber": userInfo.getphoneNumber,
                                "memberRole": userInfo.getmemberRole,
                                "profession": "Student"
                              }).then((value) async {
                                await userInfo.updateAfterAuth(
                                    uid,
                                    firstName,
                                    lastName,
                                    dateOfBirth,
                                    email,
                                    phoneNumber,
                                    gender,
                                    placeOfWork,
                                    profession,
                                    userInfo.getmemberRole);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              }).catchError((error) =>
                                      print("Failed to update user: $error"));
                              // }

                              // Navigator.pop(context);
                              // Navigator.pop(context);
                            },
                          ),
                          SizedBox(
                            height: _height * 0.020,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
