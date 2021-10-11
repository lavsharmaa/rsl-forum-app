import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:share/share.dart';
import '../../../widgets/zoom_image.dart';
import '../../../widgets/constants.dart';
import 'post_comments.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../../models/User.dart';

class AdminEventDetailPage extends StatefulWidget {
  String id, postTitle, postDescription, postCategory, postImageUrl, postAuthor;
  int postClickCount, postCommentCount, postLikeCount;
  DateTime postDate;

  AdminEventDetailPage({
    required this.id,
    required this.postTitle,
    required this.postDescription,
    required this.postCategory,
    required this.postImageUrl,
    required this.postAuthor,
    required this.postClickCount,
    required this.postCommentCount,
    required this.postLikeCount,
    required this.postDate,
  });
  @override
  _AdminEventDetailPageState createState() =>
      _AdminEventDetailPageState(id, postImageUrl);
}

class _AdminEventDetailPageState extends State<AdminEventDetailPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  late String id;
  late String postImageUrl;
  int postClickCount = 0;
  int postCommentCount = 0;
  var userInfo;

  _AdminEventDetailPageState(this.id, this.postImageUrl);

  Widget _buildImage() {
    if (postImageUrl != "") {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: GestureDetector(
          child: Image.network(
            postImageUrl,
            height: 300,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ZoomImageNetwork(postImageUrl),
              ),
            );
          },
        ),
      );
    } else {
      return SizedBox(
        height: 10,
      );
    }
  }

  addLike(context, String postId) {
    // fetching user id
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final userID = user?.uid;
    // fetching username
    final userName = userInfo.getfirstName + " " + userInfo.getlastName;
    // adding to discussion like
    FirebaseFirestore.instance
        .collection('likes')
        .where('postId', isEqualTo: postId)
        .where('userId', isEqualTo: userID)
        .get()
        .then((checkSnapshot) {
      if (checkSnapshot.size > 0) {
        print("already liksed");
      } else {
        // incrementing likes in discussion
        final DocumentReference docRef =
            FirebaseFirestore.instance.collection("discussions").doc(postId);
        docRef.update({"postLikeCount": FieldValue.increment(1)});
        print("adding");
        FirebaseFirestore.instance
            .collection('likes')
            .add({'postId': postId, 'likePerson': userName, 'userId': userID});
      }
    });
  }

  @override
  void initState() {
    userInfo = Provider.of<UserData>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    // fetching the values
    id = widget.id;
    String postTitle = widget.postTitle,
        postDescription = widget.postDescription,
        postCategory = widget.postCategory,
        postImageUrl = widget.postImageUrl,
        postAuthor = widget.postAuthor;
    int postClickCount = widget.postClickCount,
        postCommentCount = widget.postCommentCount,
        postLikeCount = widget.postLikeCount;
    DateTime date = widget.postDate;

    // post date conversion
    String formattedDate = DateFormat('dd MMM, yyyy', 'en').format(date);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "RSL Forum",
          style: TextStyle(
            fontFamily: 'Raleway',
            fontWeight: FontWeight.w800,
            fontSize: 18.0,
            color: Colors.black87,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.share,
              color: Colors.black,
            ),
            tooltip: 'Comment Icon',
            onPressed: () {
              final RenderBox box = context.findRenderObject() as RenderBox;
              Share.share(
                  "Title: $postTitle" + "\nDescription: $postDescription",
                  sharePositionOrigin:
                      box.localToGlobal(Offset.zero) & box.size);
            },
          ), //IconButton
        ],
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: _height * 0.05,
                ),
                Center(child: _buildImage()),
                SizedBox(
                  height: _height * 0.015,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: _height * 0.01,
                    horizontal: _width * 0.04,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Event title
                      Padding(
                        padding:
                            EdgeInsets.fromLTRB(_width * 0.08, 0.0, 0, 0.0),
                        child: Text(
                          postTitle,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: _height * 0.015),
                      Padding(
                        padding:
                            EdgeInsets.fromLTRB(_width * 0.08, 0.0, 0, 0.0),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              WidgetSpan(
                                child: Icon(Icons.calendar_today_outlined),
                              ),
                              TextSpan(
                                text: " " + formattedDate,
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: " | ",
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                              ),
                              WidgetSpan(
                                child: Icon(Icons.person),
                              ),
                              TextSpan(
                                text: postAuthor,
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: _height * 0.015,
                      ),
                      Padding(
                        padding:
                            EdgeInsets.fromLTRB(_width * 0.08, 0.0, 0, 0.0),
                        child: Text(
                          postDescription,
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xff000000),
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      SizedBox(height: _height * 0.015),
                      Padding(
                        padding:
                            EdgeInsets.fromLTRB(_width * 0.08, 0.0, 0, 0.0),
                        child: Text(
                          'Category: ' + postCategory,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      SizedBox(height: _height * 0.015),
                      Padding(
                        padding:
                            EdgeInsets.fromLTRB(_width * 0.08, 0.0, 0, 0.0),
                        child: Text(
                          'Posted on: ' + formattedDate,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: _height * 0.015,
                      ),
                      Padding(
                        padding:
                            EdgeInsets.fromLTRB(_width * 0.08, 0.0, 0, 0.0),
                        child: Text(
                          'Like:  ' + postLikeCount.toString(),
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: _height * 0.015,
                      ),
                      // like the post

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
                        child: FractionallySizedBox(
                          widthFactor: 1,
                          child: TextButton(
                            child: Text(
                              'Like',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Montserrat',
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              addLike(context, id);
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: _height * 0.015,
                      ),
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
                        child: FractionallySizedBox(
                          widthFactor: 1,
                          child: TextButton(
                            child: Text(
                              'Comments',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Montserrat',
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              goToCommentScreen(context, id);
                            },
                          ),
                        ),
                      ),
                    ],
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

goToCommentScreen(
  BuildContext context,
  String postId,
) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Comments(postId: postId),
    ),
  );
}
