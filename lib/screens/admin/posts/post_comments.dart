import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawerbehavior/drawerbehavior.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../drawers_constants/admin_drawer.dart';
import '../../../models/User.dart';
import 'package:intl/date_symbol_data_local.dart';

// ignore: must_be_immutable
class Comments extends StatefulWidget {
  String postId = "";

  Comments({
    required this.postId,
  });
  @override
  CommentsState createState() => CommentsState(postId);
}

class CommentsState extends State<Comments> {
  TextEditingController commentController = TextEditingController();

  String postId = "";
  String postComment = "";

  CommentsState(this.postId);

  final DrawerScaffoldController controller = DrawerScaffoldController();
  late int selectedMenuItemId;
  var userInfo;
  var screenSize;

  // insert comment into database
  addComment(String comment) {
    final userName = userInfo.getfirstName + " " + userInfo.getlastName;
    print(comment);
    FirebaseFirestore.instance
        .collection('comments')
        .add({'postId': postId, 'comment': comment, 'commentAuthor': userName});
  }

  @override
  void initState() {
    selectedMenuItemId = menuWithIcon.items[1].id;
    userInfo = Provider.of<UserData>(context, listen: false);
    initializeDateFormatting('en', null);
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
      body: Column(
        children: <Widget>[
          Expanded(child: getHomePageBody(context)),
          Divider(),
          ListTile(
            title: TextFormField(
              onChanged: (value) {
                setState(() {
                  postComment = value;
                });
              },
              validator: (value) {
                if (value!.isEmpty)
                  return 'Comment is required';
                else
                  return null;
              },
              controller: commentController,
              decoration: InputDecoration(labelText: "Write a comment..."),
            ),
            trailing: OutlineButton(
              onPressed: () => addComment(postComment),
              child: Text("Post"),
            ),
          ),
        ],
      ),
    );
  }

  Widget getHomePageBody(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('comments')
          .where('postId', isEqualTo: postId)
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
