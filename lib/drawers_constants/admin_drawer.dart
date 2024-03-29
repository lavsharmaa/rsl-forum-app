import 'package:drawerbehavior/drawerbehavior.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/view_profile.dart';
import '../services/auth_service.dart';
import '../widgets/constants.dart';

List<MenuItem> items = [
  MenuItem<int>(
    id: 0,
    title: 'About Us',
    prefix: Icon(Icons.info),
  ),
  MenuItem<int>(
    id: 1,
    title: 'Discussions',
    prefix: Icon(Icons.event),
  ),
  MenuItem<int>(
    id: 2,
    title: 'Your Posts',
    prefix: Icon(Icons.event),
  ),
  MenuItem<int>(
    id: 3,
    title: 'Contact Us',
    prefix: Icon(Icons.quick_contacts_mail),
  ),
];
final menu = Menu(
  items: items.map((e) => e.copyWith(prefix: null)).toList(),
);

final menuWithIcon = Menu(
  items: items,
);

void selectedItem(BuildContext context, int index) {
  // controller.toggle();
  Navigator.of(context).pop();

  switch (index) {
    case 0:
      Navigator.pushNamed(context, "/about_us");
      break;
    case 1:
      Navigator.pushNamed(context, "/admin_events");
      break;
    case 2:
      Navigator.pushNamed(context, "/edit_post");
      break;
    case 3:
      Navigator.pushNamed(context, "/contact_us");
      break;
  }
}

Widget header(BuildContext context, var userInfo) {
  // final DrawerScaffoldController controller = DrawerScaffoldController();
  return Container(
    width: MediaQuery.of(context).size.width * 0.7,
    child: Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.04,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // Container(
          //   width: MediaQuery.of(context).size.width * 0.5,
          //   child: FittedBox(
          //     fit: BoxFit.fitWidth,
          //     child: Image(
          //       image: AssetImage("assets/images/logo-with-text-round.png"),
          //     ),
          //   ),
          // ),
          SizedBox(height: 15),
          Text(
            'Welcome ' + userInfo.getfirstName,
            style: TextStyle(
                fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          ElevatedButton.icon(
            icon: Icon(Icons.person),
            label: Text('View Profile'),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed))
                    return primaryColor;
                  return secondaryColor; // Use the component's default.
                },
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewProfileScreen(),
                ),
              );
            },
          ),
        ],
      ),
    ),
  );
}

Widget footer(
    BuildContext context, DrawerScaffoldController controller, var userInfo) {
  return Padding(
    padding: EdgeInsets.only(
      bottom: MediaQuery.of(context).size.height * 0.04,
    ),
    child: Column(
      children: [
        InkWell(
          onTap: () async => {
            // controller.toggle(),
            onLogoutPressed(context, userInfo),
          },
          child: Container(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.11,
              top: MediaQuery.of(context).size.height * 0.02,
              bottom: MediaQuery.of(context).size.height * 0.02,
            ),
            child: Row(
              children: [
                Icon(Icons.logout, size: 20),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Logout',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          'Developed by DBIT',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            // color: Colors.red,
            color: Color(0xff0056B4),
          ),
        ),
      ],
    ),
  );
}
