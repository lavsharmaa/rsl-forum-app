import 'package:drawerbehavior/drawerbehavior.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/alert_dialogs.dart';

import 'constants.dart';
import '../../drawers_constants/drawer.dart' as Drawer;
import '../../models/User.dart';
import '../../widgets/constants.dart';
import 'package:open_mail_app/open_mail_app.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

late double _height;
late double _width;

// ignore: must_be_immutable
class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final DrawerScaffoldController controller = DrawerScaffoldController();
  late int selectedMenuItemId;
  String emailId = "";
  String phoneNo = "8452930878";

  var userInfo;

  @override
  void initState() {
    selectedMenuItemId = Drawer.menuWithIcon.items[2].id;
    userInfo = Provider.of<UserData>(context, listen: false);
    super.initState();
  }

  void sendEmail(BuildContext context, String emailId) async {
    print('in send email');
    print(emailId);
    var apps = await OpenMailApp.getMailApps();
    emailId = emailId;
    if (apps.isEmpty) {
      showNoMailAppsDialog(context);
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return MailAppPickerDialog(
            mailApps: apps,
            emailContent: EmailContent(
              to: [
                emailId,
              ],
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var role =
        userInfo.getmemberRole; // to identify if user is admin or other role
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    print("item: $selectedMenuItemId");
    return WillPopScope(
      onWillPop: () => showExitAlertDialog(context),
      child: DrawerScaffold(
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
                            controller.toggle(Direction.left),
                          },
                        ),
                      ),
                    ),
                    PreferredSize(
                      preferredSize: Size.fromHeight(100),
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 70),
                            RichText(
                              text: TextSpan(
                                style: Theme.of(context).textTheme.bodyText2,
                                children: [
                                  TextSpan(
                                    text: 'Contact Us',
                                    style: TextStyle(
                                      fontSize: 26,
                                      color: Color(0xff333333),
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat',
                                      letterSpacing: 1.5,
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
                  child: DefaultTabController(
                    length: 1,
                    child: Scaffold(
                      backgroundColor: Colors.transparent,
                      appBar: AppBar(
                        automaticallyImplyLeading: false,
                        backgroundColor: Colors.transparent,
                        elevation: 0.0,
                        bottom: PreferredSize(
                          preferredSize: const Size.fromHeight(10),
                          child: Container(
                            child: TabBar(
                              labelPadding:
                                  EdgeInsets.symmetric(horizontal: 10.0),
                              labelStyle: TextStyle(
                                fontSize: 14.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                              ),
                              unselectedLabelColor: Colors.black54,
                              labelColor: Colors.black,
                              indicatorColor: secondaryColor,
                              indicatorWeight: 2.5,
                              tabs: [
                                Container(
                                  height: 20.0,
                                  width: 120.0,
                                  child: Tab(text: 'Developers'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      body: TabBarView(
                        children: <Widget>[
                          devTab(),
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

  Widget centerCard(String developerName, String emailIds, String contactNos,
      String linkedInLink, String githubLink) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: contactUsBorderColor),
          color: contactUsCardColor,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        height: _height * 0.18,
        width: _width * 0.80,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 10,
          ),
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                // text: "ANDHERI \n ",
                text: developerName,
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'CM Sans Serif',
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Email ID: ',
                    recognizer: new TapGestureRecognizer()
                      ..onTap = () => {
                            print(emailId),
                            sendEmail(context, emailId),
                          },
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                      fontSize: 11.5,
                    ),
                  ),
                  TextSpan(
                    text: emailIds,
                    recognizer: new TapGestureRecognizer()
                      ..onTap = () => {
                            print(emailId),
                            sendEmail(context, emailId),
                          },
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.blue,
                      fontWeight: FontWeight.w400,
                      fontSize: 11.5,
                    ),
                  ),
                  TextSpan(
                    text: 'LinkedIn: ',
                    recognizer: new TapGestureRecognizer()
                      ..onTap = () => {
                            print(linkedInLink),
                            sendEmail(context, linkedInLink),
                          },
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                      fontSize: 11.5,
                    ),
                  ),
                  TextSpan(
                    text: linkedInLink,
                    recognizer: new TapGestureRecognizer()
                      ..onTap = () => {
                            print(emailId),
                            sendEmail(context, emailId),
                          },
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.blue,
                      fontWeight: FontWeight.w400,
                      fontSize: 11.5,
                    ),
                  ),
                  TextSpan(
                    text: 'Github: ',
                    recognizer: new TapGestureRecognizer()
                      ..onTap = () => {
                            print(githubLink),
                            sendEmail(context, githubLink),
                          },
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                      fontSize: 11.5,
                    ),
                  ),
                  TextSpan(
                    text: githubLink,
                    recognizer: new TapGestureRecognizer()
                      ..onTap = () => {
                            print(githubLink),
                            sendEmail(context, githubLink),
                          },
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.blue,
                      fontWeight: FontWeight.w400,
                      fontSize: 11.5,
                    ),
                  ),
                  TextSpan(
                    text: 'Phone No: ',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                      fontSize: 11.5,
                    ),
                  ),
                  TextSpan(
                    text: contactNos,
                    recognizer: new TapGestureRecognizer()
                      ..onTap = () => {
                            FlutterPhoneDirectCaller.callNumber(phoneNo),
                          },
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.blue,
                      fontWeight: FontWeight.w400,
                      fontSize: 11.5,
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

  Widget devTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: _height * 0.025,
            horizontal: _width * 0.05,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: contactUsBorderColor),
            color: contactUsBgColor,
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: _height * 0.01),
              Center(
                child: Text(
                  'You can contact us easily through the below links',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Montserrat',
                    fontSize: 16.0,
                    height: 1,
                  ),
                ),
              ),
              SizedBox(height: _height * 0.015),
              centerCard(
                developerName[0],
                emailIds[0],
                contactNos[0],
                linkedInLink[0],
                githubLink[0],
              ),
              SizedBox(height: _height * 0.015),
              centerCard(
                developerName[1],
                emailIds[1],
                contactNos[1],
                linkedInLink[2],
                githubLink[0],
              ),
              SizedBox(height: _height * 0.015),
              centerCard(
                developerName[2],
                emailIds[2],
                contactNos[2],
                linkedInLink[2],
                githubLink[0],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showNoMailAppsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Open Mail App"),
          content: Text("No mail apps installed"),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
}
