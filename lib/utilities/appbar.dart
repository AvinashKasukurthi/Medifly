import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medifly/profile_Screen.dart';
import 'package:medifly/search_screen.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key key,
    @required this.color,
    @required this.iconColor,
    @required GlobalKey<ScaffoldState> scaffoldKey,
    this.backgroundColor,
  })  : _scaffoldKey = scaffoldKey,
        super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey;
  final Color color;
  final Color iconColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      margin: EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              _scaffoldKey.currentState.openDrawer();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Image.asset(
                'images/Drawer.png',
                width: 25,
                height: 20,
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, SearchScreen.id);
              },
              child: Container(
                height: 45.0,
                child: Center(
                    child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(CupertinoIcons.search),
                      ),
                    ),
                    Text('Search for Locations'),
                  ],
                )),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
          ),
          IconButton(
              icon: Icon(
                Icons.person,
                color: iconColor,
              ),
              onPressed: () {
                Navigator.pushNamed(context, ProfileScreen.id);
              }),
        ],
      ),
    );
  }
}

class DrawerPop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 10.0,
    );
  }
}
