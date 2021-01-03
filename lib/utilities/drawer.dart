import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medifly/profile_Screen.dart';
import 'package:medifly/utilities/recenttoken_screen.dart';
import 'constants.dart';
import 'package:medifly/profile_Screen.dart';

class Drawerpop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 15),
              height: 175,
              color: kPrimaryColorBlue,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.only(left: 15),
                        child: Image.asset(
                          'images/AdLogo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Medifly",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w300,
                              color: Colors.white),
                        ),
                        Text(
                          '"Being part of your Health"',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w300,
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 6.0,
            ),
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  DrawerTileButton(
                    drawerIcon: Icons.person,
                    title: 'Profile',
                    onPressed: () {
                      Navigator.pushNamed(context, ProfileScreen.id);
                    },
                  ),
                  // Divider(),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, RecentCards.id);
                    },
                    child: DrawerTileButton(
                      drawerIcon: Icons.history,
                      title: 'Recent Bookings',
                    ),
                  ),
                  DrawerTileButton(
                    drawerIcon: Icons.feedback,
                    title: 'Feedback',
                  ),
                  // Divider(),
                  DrawerTileButton(
                    drawerIcon: Icons.info,
                    title: 'About',
                  ),
                  // Divider(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DrawerButton extends StatelessWidget {
  const DrawerButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Row(
            children: [
              Icon(
                Icons.person,
                color: kPrimaryColorBlue,
              ),
              SizedBox(
                width: 12.0,
              ),
              Text(
                'Profile',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerTileButton extends StatelessWidget {
  DrawerTileButton({this.drawerIcon, this.title, this.onPressed});
  final IconData drawerIcon;
  final String title;
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      focusColor: kCardsColor,
      leading: Icon(
        drawerIcon,
        color: kPrimaryColorBlue,
      ),
      title: Text(title),
      onTap: onPressed,
    );
  }
}
