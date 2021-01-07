import 'package:flutter/material.dart';
import 'package:medifly/utilities/constants.dart';

class PageHeader extends StatelessWidget {
  final String title;

  const PageHeader({
  @required this.title,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'images/background.jpg',
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    kPrimaryColorBlue.withOpacity(0.9),
                    kPrimaryColorBlue.withOpacity(0.6),
                    kPrimaryColorBlue.withOpacity(0.3),
                  ],
                  stops: [
                    0.3,
                    0.6,
                    0.9,
                  ]),
            ),
            child: Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 22.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}