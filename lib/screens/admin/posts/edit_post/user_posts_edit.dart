import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'user_posts_edit_image.dart';
import '../../../../widgets/constants.dart';
import '../../../../widgets/gradient_button.dart';

// ignore: must_be_immutable
class EditEventScreen extends StatefulWidget {
  String id = "";
  String postTitle = "";
  String postDescription = "";
  String postImageUrl = "";
  String postCategory = "Everyone";

  EditEventScreen(
      {required this.id,
      required this.postTitle,
      required this.postDescription,
      required this.postCategory,
      required this.postImageUrl});
  @override
  _EditEventScreenState createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  String id = "";
  String postTitle = "";
  String postDescription = "";
  String postImageUrl = "";
  String postCategory = "Everyone";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> _scaffoldkey =
      GlobalKey<ScaffoldState>(); // scaffold key for snack bar

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

  Future<bool?> _onBackPressed() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Do you want to exit without saving changes?'),
            content:
                Text('Please press the SAVE button at the bottom of the page'),
            actions: <Widget>[
              TextButton(
                child: Text('NO'),
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
        });
  }

  Future<bool?> savePressed() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              'Your request to change information has been successfully sent!'),
          actions: <Widget>[
            TextButton(
              child: Text('Continue'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    id = widget.id;
    postTitle = widget.postTitle;
    postDescription = widget.postDescription;
    postImageUrl = widget.postImageUrl;
    postCategory = widget.postCategory;
    if (postCategory == "General") {
      _postTypeRadioValue = 1;
    } else if (postCategory == "Question") {
      _postTypeRadioValue = 0;
    }
    super.initState();
  }

  final int height = 1;
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        bool? result = await _onBackPressed();
        if (result == null) {
          result = false;
        }
        return result;
      },
      child: Scaffold(
        key: _scaffoldkey,
        // body:WillPopScope(
        //   onWillPop: _onBackPressed,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // circle design and Title
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
                            // onPressed: () => Navigator.of(context).pop(true),
                            // onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ),
                      Positioned(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: _height * 0.095),
                            child: Text(
                              'EDIT POST',
                              style: TextStyle(
                                fontSize: 35,
                                // color: Color(0xff333333),
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
                  // Displaying event image
                  Image.network(
                    postImageUrl,
                    fit: BoxFit.cover,
                    width: 120.0,
                  ),
                  SizedBox(height: 20),
                  // choose image
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: _height * 0.01,
                      horizontal: _width * 0.04,
                    ),
                    child: GradientButton(
                      buttonText: 'Edit image',
                      screenHeight: _height,
                      onPressedFunction: () async {
                        // Edit event image alertbox
                        await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Confirmation'),
                              content: Text(
                                  'Are you sure you want to edit this image?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(
                                      context,
                                      rootNavigator: true,
                                    ).pop(
                                        false); // dismisses only the dialog and returns false
                                  },
                                  child: Text('No'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop(true);
                                    goToEditEventImage(
                                        context, id, postImageUrl);
                                  },
                                  child: Text('Yes'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
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
                          // Event Name
                          TextFormField(
                            initialValue: postTitle,
                            keyboardType: TextInputType.text,
                            onSaved: (value) {
                              setState(() {
                                postTitle = value!;
                              });
                            },
                            validator: (value) {
                              if (value!.isEmpty)
                                return 'Title is required.';
                              else
                                return null;
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.star_border,
                                color: secondaryColor,
                              ),
                              labelText: 'Post Title',
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
                          // Event Description
                          TextFormField(
                            initialValue: postDescription,
                            keyboardType: TextInputType.text,
                            onSaved: (value) {
                              setState(() {
                                postDescription = value!;
                              });
                            },
                            validator: (value) {
                              if (value!.isEmpty)
                                return 'Post Description is required.';
                              else
                                return null;
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.description,
                                color: secondaryColor,
                              ),
                              labelText: 'Post Description',
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
                          SizedBox(height: _height * 0.015),
                          SizedBox(height: _height * 0.015),
                          SizedBox(height: _height * 0.015),
                          SizedBox(height: _height * 0.015),
                          SizedBox(height: _height * 0.015),
                          // Event Type
                          Text(
                            'Post Category: ',
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
                          SizedBox(
                            height: 10,
                          ),
                          // Update event button
                          GradientButton(
                            buttonText: 'Update Post',
                            screenHeight: _height,
                            onPressedFunction: () async {
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }
                              _formKey.currentState!.save();
                              await showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Confirmation'),
                                    content: Text(
                                        'Are you sure you want to save the changes?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(
                                            context,
                                            rootNavigator: true,
                                          ).pop(
                                              false); // dismisses only the dialog and returns false
                                        },
                                        child: Text('No'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop(true);
                                          // updating the event after changes if yes pressed
                                          FirebaseFirestore.instance
                                              .collection('discussions')
                                              .doc(id)
                                              .update({
                                            'postTitle': postTitle,
                                            'postDescription': postDescription,
                                            'postCategory': postCategory,
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: Text('Yes'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
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

goToEditEventImage(BuildContext context, String id, String eventImageUrl) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => AdminEditEventImage(
        id: id,
        eventImageUrl: eventImageUrl,
      ),
    ),
  );
}
