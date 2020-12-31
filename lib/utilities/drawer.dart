import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medifly/profile_Screen.dart';
import 'package:medifly/utilities/recenttoken_screen.dart';
import 'constants.dart';
import 'package:medifly/profile_Screen.dart';

class Drawerpop extends StatelessWidget {
  final String drawername;
  const Drawerpop({
    Key key, this.drawername,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: Column(
          children: [
            Container(
              color: kPrimaryColorBlue,
              child: Row(
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 60,
                        left: 25,
                        right: 25,
                        bottom: 25,
                      ),
                      child: Container(
                        child: Image.asset('images/AdLogo.png'),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 38.5,
                          ),
                          child: Text(
                            'Hello!',
                            style: kMainText.copyWith(
                                color: Colors.white70, fontSize: 18.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Center(
                          child: Container(
                            height: 20.0,
                            width: 150.0,
                            child: Text(
                              '$drawername',
                              textAlign: TextAlign.center,
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
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
