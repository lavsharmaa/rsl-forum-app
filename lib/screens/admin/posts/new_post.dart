import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:vibration/vibration.dart';
import '../../../widgets/constants.dart';
import '../../../widgets/gradient_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ignore: must_be_immutable
class AdminNewEvent extends StatefulWidget {
  @override
  _AdminNewEventState createState() => _AdminNewEventState();
}
// Future<http.Response> SendNotification(String eventTitle,String eventDate) {
//   return http.post(
//     Uri.parse('https://ywca-temp.herokuapp.com/post/'),
//     body: (<String, String>{
//       'title': eventTitle,
//       'body': eventDate,
//       'password':"12345678"

//     }),
//   );
// }
class _AdminNewEventState extends State<AdminNewEvent> {
  String postTitle = "";
  String postDescription = "";
  String postImageUrl = "";
  String postCategory = "Everyone";
  // image path variable
  File? _image;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Image
  Future<void> captureImage(ImageSource imageSource) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
          source: ImageSource.gallery, maxHeight: 2000, maxWidth: 2000);
      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print('No image selected.');
        }
      });
    } catch (e) {
      print(e);
    }
  }

  // displaying image
  Widget _buildImage() {
    // ignore: unnecessary_null_comparison
    if (_image != null) {
      return Image.file(_image!);
    } else {
      return Text('Choose an image to show', style: TextStyle(fontSize: 18.0));
    }
  }

  // uploading image to firebase storage
  Future uploadData(
      BuildContext context, postTitle, postDescription, postCategory) async {
    goBackToPreviousScreen(context);
    String fileName = basename(_image!.path);
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = firebaseStorageRef.putFile(_image!);

    uploadTask.whenComplete(() {});
    // reference to the firestore of the image
    var imageUrl = await (await uploadTask).ref.getDownloadURL();
    var url = imageUrl.toString();
    print("Image URL=" + url);

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final userID = user?.uid;

    FirebaseFirestore.instance.collection('discussions').add({
      'postImageUrl': url,
      'postTitle': postTitle,
      'postDescription': postDescription,
      'postCategory': postCategory,
      'postdate': DateTime.now(),
      'postAuthor': 'Lav Sharma',
      'postLikeCount': 0,
      'postCommentCount': 0,
      'postClickCount': 0,
      'authorUid': userID,
    });
  }

  // everyone-0, members-1
  int? _postTypeRadioValue = 0;
  void _handlePostTypeRadioValueChange(int? value) {
    setState(() {
      _postTypeRadioValue = value;
      if (_postTypeRadioValue == 0) {
        postCategory = "General";
      } else {
        postCategory = "Question";
      }
      print("Category: $postCategory");
    });
  }

  @override
  void initState() {
    Intl.defaultLocale = 'pt_BR';
    setState(() {
      postCategory = "General";
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        goBackToPreviousScreen(context);
                      },
                    ),
                    Positioned(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: _height * 0.15),
                          child: Text(
                            'New Discussion',
                            style: TextStyle(
                              fontSize: 40,
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'RacingSansOne',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: _height * 0.025,
                ),
                // choose image
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: _height * 0.01,
                    horizontal: _width * 0.04,
                  ),
                  child: GradientButton(
                    buttonText: 'Choose file',
                    screenHeight: _height,
                    onPressedFunction: () => captureImage(ImageSource.gallery),
                  ),
                ),
                SizedBox(
                  height: _height * 0.015,
                ),
                // display image
                Center(child: _buildImage()),
                SizedBox(
                  height: _height * 0.015,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: _height * 0.01,
                    horizontal: _width * 0.04,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        // title
                        TextFormField(
                          onChanged: (value) {
                            setState(() {
                              postTitle = value;
                            });
                          },
                          validator: (value) {
                            if (value!.isEmpty)
                              return 'Title is required';
                            else
                              return null;
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.star_border,
                              color: secondaryColor,
                            ),
                            labelText: 'Title',
                            filled: true,
                            fillColor: formFieldFillColor,
                            disabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                          ),
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: _height * 0.015,
                        ),
                        // description
                        TextFormField(
                          onChanged: (value) {
                            setState(() {
                              postDescription = value;
                            });
                          },
                          validator: (value) {
                            if (value!.isEmpty)
                              return 'Description is required';
                            else
                              return null;
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.description_outlined,
                              color: secondaryColor,
                            ),
                            labelText: 'Description',
                            filled: true,
                            fillColor: formFieldFillColor,
                            disabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                          ),
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: _height * 0.015),
                        // post category
                        Text(
                          'Post Category:',
                          style: TextStyle(
                            fontSize: 18,
                            color: primaryColor,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Radio(
                              value: 0,
                              groupValue: _postTypeRadioValue,
                              onChanged: _handlePostTypeRadioValueChange,
                              focusColor: secondaryColor,
                              hoverColor: secondaryColor,
                              activeColor: secondaryColor,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _postTypeRadioValue = 0;
                                  _handlePostTypeRadioValueChange(
                                      _postTypeRadioValue);
                                });
                              },
                              child: Text(
                                'General',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Radio(
                              value: 1,
                              groupValue: _postTypeRadioValue,
                              onChanged: _handlePostTypeRadioValueChange,
                              focusColor: secondaryColor,
                              hoverColor: secondaryColor,
                              activeColor: secondaryColor,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _postTypeRadioValue = 1;
                                  _handlePostTypeRadioValueChange(
                                      _postTypeRadioValue);
                                });
                              },
                              child: Text(
                                'Question',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: _height * 0.015),
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: _height * 0.015,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                firstButtonGradientColor,
                                firstButtonGradientColor,
                                secondButtonGradientColor
                              ],
                              begin: FractionalOffset.centerLeft,
                              end: FractionalOffset.centerRight,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: GradientButton(
                            buttonText: 'Submit',
                            screenHeight: _height * 0.4,
                            onPressedFunction: () async {
                              if (!_formKey.currentState!.validate()) {
                                Vibration.vibrate(duration: 100);
                                return;
                              }
                              _formKey.currentState!.save();
                              uploadData(
                                context,
                                postTitle,
                                postDescription,
                                postCategory,
                              );
                            },
                          ),
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
    );
  }
}

goBackToPreviousScreen(BuildContext context) {
  Navigator.pop(context);
}
