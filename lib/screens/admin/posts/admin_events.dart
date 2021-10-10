import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawerbehavior/drawerbehavior.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widgets/alert_dialogs.dart';

import 'admin_event_details.dart';
import 'admin_new_event.dart';

import '../../../drawers_constants/admin_drawer.dart';
import '../../../models/User.dart';
import '../../../widgets/constants.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ignore: must_be_immutable
class Discussions extends StatefulWidget {
  @override
  _DiscussionsState createState() => _DiscussionsState();
}

class _DiscussionsState extends State<Discussions> {
  final DrawerScaffoldController controller = DrawerScaffoldController();
  late int selectedMenuItemId;
  var userInfo;
  var screenSize;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // conversion of event postdate to string for displaying
  String readpostdate(Timestamp eventpostdate) {
    DateTime newpostdate = eventpostdate.toDate();
    String formattedpostdate =
        DateFormat('EEE | dd MMM, yyyy', 'en').format(newpostdate);
    return formattedpostdate;
  }

  // insert token into the database
  _getToken() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final userID = user?.uid;
    _firebaseMessaging.getToken().then((deviceToken) {
      print("device token: $deviceToken");
      // adding to mobile token
      FirebaseFirestore.instance
          .collection('mobileToken')
          .where('userID', isEqualTo: userID)
          .get()
          .then((checkSnapshot) {
        if (checkSnapshot.size > 0) {
          print("already exists");
          print("updating token");
          FirebaseFirestore.instance
              .collection('mobileToken')
              .doc(userID)
              .update({'token': deviceToken})
              .then((_) => print('Uppostdated'))
              .catchError((error) => print('Uppostdate failed: $error'));
        } else {
          // saving the value if it doesn't exists
          print("adding");
          FirebaseFirestore.instance
              .collection('mobileToken')
              .add({'token': deviceToken, 'userID': userID});
        }
      });
    });
  }

  @override
  void initState() {
    selectedMenuItemId = menuWithIcon.items[1].id;
    userInfo = Provider.of<UserData>(context, listen: false);
    initializeDateFormatting('en', null);
    // _getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () => showExitAlertDialog(context),
      child: DrawerScaffold(
        // appBar: AppBar(), // green app bar
        drawers: [
          SideDrawer(
            percentage: 0.75, // main screen height proportion
            headerView: header(context, userInfo),
            footerView: footer(context, controller, userInfo),
            color: successStoriesCardBgColor,
            selectorColor: Colors.indigo[600], menu: menuWithIcon,
            animation: true,
            selectedItemId: selectedMenuItemId,
            onMenuItemSelected: (itemId) {
              setState(() {
                selectedMenuItemId = itemId;
                selectedItem(context, itemId);
              });
            },
          ),
        ],
        controller: controller,
        builder: (context, id) => SafeArea(
          child: Center(
            child: Stack(
              children: <Widget>[
                Positioned(
                  child: AppBar(
                    centerTitle: true,
                    title: Text(
                      "RSL Forum",
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        // fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w800,
                        fontSize: 18.0,
                        color: Colors.black87,
                      ),
                    ),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: Colors.black,
                        size: 30,
                      ),
                      onPressed: () => {
                        controller.toggle(Direction.left),
                        // OR
                        // controller.open()
                      },
                    ),
                  ),
                ),
                // Events & Search bar Starts
                PreferredSize(
                  preferredSize: Size.fromHeight(80),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 80),
                      Center(
                        child: Text(
                          'Dicussions',
                          style: TextStyle(
                            fontSize: 26,
                            color: Color(0xff333333),
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                    ],
                  ),
                ),
                // card view for the events
                Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 160.0, 0.0, 0.0),
                    child: getHomePageBody(context)),
                Column(
                  children: [
                    Spacer(flex: 20),
                    Row(
                      children: [
                        Spacer(flex: 15),
                        ElevatedButton.icon(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith((states) {
                              if (states.contains(MaterialState.pressed))
                                return secondaryColor.withOpacity(0.90);
                              return firstButtonGradientColor;
                            }),
                            foregroundColor:
                                MaterialStateProperty.resolveWith((states) {
                              return null;
                            }),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          icon: Icon(Icons.add),
                          label: Text(
                            "Start New Discussion",
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                          onPressed: () async {
                            // when clicked on new event open Add Event page
                            gotoNewEvent(context);
                          },
                        ),
                        Spacer(),
                      ],
                    ),
                    Spacer(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getHomePageBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('discussions')
          // .orderBy('eventpostdate', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return Text('Error: ${snapshot.error}' + 'something');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
          default:
            return ListView(
              padding: EdgeInsets.only(bottom: 100),
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                  child: Card(
                    child: ListTile(
                      minVerticalPadding: 10,
                      title: Column(
                        children: [
                          // Event image
                          ClipRRect(
                            borderRadius: BorderRadius.all(
                              // add border radius here
                              Radius.circular(10.0),
                            ),
                            child: Image.network(
                              // Image
                              document['postImageUrl'],
                              fit: BoxFit.fitWidth,
                              // // width: 200,
                            ),
                          ),
                          SizedBox(height: 5),
                          // Title
                          Text(
                            document['postTitle'],
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // postAuthor
                              Text(
                                'Author: ' + document['postAuthor'],
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              // Category
                              Text(
                                'Category: ' + document['postCategory'],
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              SizedBox(height: 5),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // postLikeCount
                              Text(
                                'Likes: ' + document['postLikeCount'].toString(),
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              // Comments
                              Text(
                                'Date: ' +
                                    (readpostdate(document['postdate'])),
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          // start of edit and delete button
                          // Row(
                          //   children: [
                          //     Spacer(flex: 12),
                          //     ElevatedButton(
                          //       onPressed: () async {
                          //         await showDialog(
                          //           context: context,
                          //           builder: (context) {
                          //             // Alert box for edit event
                          //             return AlertDialog(
                          //               title: Text('Confirmation'),
                          //               content: Text(
                          //                   'Are you sure you want to edit this event?'),
                          //               actions: <Widget>[
                          //                 TextButton(
                          //                   onPressed: () {
                          //                     Navigator.of(
                          //                       context,
                          //                       rootNavigator: true,
                          //                     ).pop(
                          //                         false); // dismisses only the dialog and returns false
                          //                   },
                          //                   child: Text('No'),
                          //                 ),
                          //                 TextButton(
                          //                   onPressed: () {
                          //                     Navigator.of(context,
                          //                             rootNavigator: true)
                          //                         .pop(true);
                          //                     gotoEditEvent2(
                          //                       context,
                          //                       document.id,
                          //                       document['eventAmount'],
                          //                       document['eventDescription'],
                          //                       document['eventName'],
                          //                       document['eventImageUrl'],
                          //                       document['eventVenue'],
                          //                       document['eventType'],
                          //                       document['eventpostdate'],
                          //                       document['eventDeadline'],
                          //                       document['eventTime'],
                          //                     );
                          //                   },
                          //                   child: Text('Yes'),
                          //                 ),
                          //               ],
                          //             );
                          //           },
                          //         );
                          //       },
                          //       style: ButtonStyle(
                          //         backgroundColor:
                          //             MaterialStateProperty.all(secondaryColor),
                          //         padding: MaterialStateProperty.all(
                          //             EdgeInsets.all(5)),
                          //       ),
                          //       child: Icon(
                          //         Icons.edit,
                          //       ),
                          //     ),
                          //     Spacer(),
                          //     ElevatedButton(
                          //       onPressed: () async {
                          //         // Alert box for delete event
                          //         await showDialog(
                          //           context: context,
                          //           builder: (context) {
                          //             return AlertDialog(
                          //               title: Text('Confirmation'),
                          //               content: Text(
                          //                 'Are you sure you want to delete this event?',
                          //               ),
                          //               actions: <Widget>[
                          //                 TextButton(
                          //                   onPressed: () {
                          //                     Navigator.of(
                          //                       context,
                          //                       rootNavigator: true,
                          //                     ).pop(
                          //                         false); // dismisses only the dialog and returns false
                          //                   },
                          //                   child: Text('No'),
                          //                 ),
                          //                 TextButton(
                          //                   onPressed: () async {
                          //                     Navigator.of(context,
                          //                             rootNavigator: true)
                          //                         .pop(true);
                          //                     var events = FirebaseFirestore
                          //                         .instance
                          //                         .collection('events');
                          //                     var eventsBackup =
                          //                         FirebaseFirestore
                          //                             .instance
                          //                             .collection(
                          //                                 'eventsBackup');
                          //                     await events
                          //                         .doc(document.id)
                          //                         .delete();
                          //                     await eventsBackup
                          //                         .doc(document.id)
                          //                         .delete();
                          //                     await FirebaseStorage.instance
                          //                         .refFromURL(
                          //                             document['eventImageUrl'])
                          //                         .delete();
                          //                     await FirebaseFirestore.instance
                          //                         .collection("eventClick")
                          //                         .where('eventID',
                          //                             isEqualTo: document.id)
                          //                         .get()
                          //                         .then((querySnapshot) {
                          //                       querySnapshot.docs
                          //                           .forEach((doc) {
                          //                         doc.reference.delete();
                          //                       });
                          //                     });
                          //                     await FirebaseFirestore.instance
                          //                         .collection(
                          //                             "eventRegistration")
                          //                         .where('eventID',
                          //                             isEqualTo: document.id)
                          //                         .get()
                          //                         .then((querySnapshot) {
                          //                       querySnapshot.docs
                          //                           .forEach((doc) {
                          //                         doc.reference.delete();
                          //                       });
                          //                     });
                          //                     setState(() {});
                          //                   },
                          //                   child: Text('Yes'),
                          //                 ),
                          //               ],
                          //             );
                          //           },
                          //         );
                          //       },
                          //       style: ButtonStyle(
                          //         backgroundColor:
                          //             MaterialStateProperty.all(Colors.red),
                          //         padding: MaterialStateProperty.all(
                          //             EdgeInsets.all(5)),
                          //       ),
                          //       child: Icon(
                          //         Icons.delete,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // end of edit and delete
                        ],
                      ),
                      onTap: () {
                        gotoDetailEvent(
                            context,
                            document.id,
                            document['postTitle'],
                            document['postDescription'],
                            document['postCategory'],
                            document['postImageUrl'],
                            document['postClickCount'],
                            document['postCommentCount'],
                            document['postdate'],
                            document['postLikeCount'],
                            document['postAuthor']);
                      },
                    ),
                  ),
                );
              }).toList(),
            );
        }
      },
    );
  }
}

gotoNewEvent(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => AdminNewEvent()),
  );
}

gotoDetailEvent(
    BuildContext context,
    String id,
    String postTitle,
    String postDescription,
    String postCategory,
    String postImageUrl,
    int postClickCount,
    int postCommentCount,
    Timestamp postdate,
    int postLikeCount,
    String postAuthor) {
  // TimeStamp to postdateTime conversion of postdate for displaying
  DateTime newpostdate = postdate.toDate();
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => AdminEventDetailPage(
        id: id,
        postTitle: postTitle,
        postDescription: postDescription,
        postCategory: postCategory,
        postImageUrl: postImageUrl,
        postClickCount: postClickCount,
        postCommentCount: postCommentCount,
        postLikeCount: postLikeCount,
        postAuthor: postAuthor,
        postDate: newpostdate,
      ),
    ),
  );
}