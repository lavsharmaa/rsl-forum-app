import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawerbehavior/drawerbehavior.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../drawers_constants/admin_drawer.dart';
import '../../../models/User.dart';
import '../../../widgets/constants.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ignore: must_be_immutable
class Comments extends StatefulWidget {
  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Comments",
          style: TextStyle(
            fontFamily: 'Raleway',
            fontWeight: FontWeight.w800,
            fontSize: 18.0,
            color: Colors.black87,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () => {
            goBackToPreviousScreen(context),
          },
        ),
      ),
      body: Padding(
          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          child: getHomePageBody(context)),
    );
  }

  Widget getHomePageBody(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('comments')
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
                          SizedBox(height: 5),
                          // Title
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                0.0, 0.0, _width * 0.5, 0.0),
                            child: Text(
                              document['comment'],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          // comment author
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                0.0, 0.0, _width * 0.25, 0.0),
                            child: Text(
                              'Author :' + document['commentAuthor'],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                      onTap: () {},
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

goBackToPreviousScreen(BuildContext context) {
  Navigator.pop(context);
}
