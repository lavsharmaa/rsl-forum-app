import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:drawerbehavior/drawerbehavior.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../drawers_constants/admin_drawer.dart' as Drawer;
import '../../models/User.dart';
import '../../widgets/constants.dart';
import '../../widgets/alert_dialogs.dart';

// ignore: must_be_immutable
class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  final DrawerScaffoldController controller = DrawerScaffoldController();
  late int selectedMenuItemId;

  var userInfo;

  @override
  void initState() {
    selectedMenuItemId = Drawer.menuWithIcon.items[0].id;
    userInfo = Provider.of<UserData>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var role = userInfo.getmemberRole;
    final _height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () => showExitAlertDialog(context),
      child: DrawerScaffold(
        // appBar: AppBar(), // green app bar
        drawers: [
          (role == "Admin")
              ? // ADMIN DRAWER
              SideDrawer(
                  percentage: 0.75, // main screen height proportion
                  headerView: Drawer.header(context, userInfo),
                  footerView: Drawer.footer(context, controller, userInfo),
                  color: successStoriesCardBgColor,
                  selectorColor: Colors.indigo[600],
                  menu: Drawer.menuWithIcon,
                  animation: true,
                  selectedItemId: selectedMenuItemId,
                  onMenuItemSelected: (itemId) {
                    setState(() {
                      selectedMenuItemId = itemId;
                      Drawer.selectedItem(context, itemId);
                    });
                  },
                )
              : // DRAWER FOR OTHER ROLES
              SideDrawer(
                  percentage: 0.75, // main screen height proportion
                  headerView: Drawer.header(context, userInfo),
                  footerView: Drawer.footer(context, controller, userInfo),
                  color: successStoriesCardBgColor,
                  selectorColor: Colors.indigo[600],
                  menu: Drawer.menuWithIcon,
                  animation: true,
                  selectedItemId: selectedMenuItemId,
                  onMenuItemSelected: (itemId) {
                    setState(() {
                      selectedMenuItemId = itemId;
                      Drawer.selectedItem(context, itemId);
                    });
                  },
                ),
        ],
        controller: controller,
        builder: (context, id) => SafeArea(
          child: Center(
            child: Column(
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
                            Icons.menu,
                            color: Colors.black,
                            size: 30,
                          ),
                          onPressed: () => {
                            // widget.onMenuPressed,
                            controller.toggle(Direction.left),
                            // OR
                            // controller.open()
                          },
                        ),
                      ),
                    ),
                    // Events & Search bar Starts
                    Positioned(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: _height * 0.1),
                          child: Column(
                            children: [
                              Text(
                                'About Us',
                                style: TextStyle(
                                  fontSize: 35,
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
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.only(top: 10, left: 30, right: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'We are currently in our Final Year of Computer Engineering from Don Bosco Institute of Technology. We have developed this project as a part of our subject.\n',
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.25,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                          Text(
                            'We have developed this application using flutter making it to work both in Android and iOS and connecting people through the means of forum and similar ideas.\n',
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.25,
                              fontFamily: 'Montserrat',
                            ),
                            textAlign: TextAlign.left,
                          ),
                          // ),
                          SizedBox(
                            height: _height * 0.010,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      text:
                                          "To learn more, visit our github repo:\n",
                                    ),
                                    TextSpan(
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      ),
                                      text: "Click here\n",
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          var url =
                                              "https://github.com/lavsharmaa/rsl-forum-app";
                                          if (await canLaunch(url)) {
                                            await launch(url);
                                          } else {
                                            throw 'Could not launch $url';
                                          }
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: _height * 0.020),
                        ],
                      ),
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
