import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medifly/main.dart';
import 'package:medifly/utilities/constants.dart';
import 'package:medifly/utilities/department_icons.dart';
import 'package:medifly/utilities/pageheader.dart';

FirebaseFirestore ref = FirebaseFirestore.instance;

class RecentCards extends StatefulWidget {
  static String id = 'RecentCards';
  RecentCards({Key key}) : super(key: key);

  @override
  _RecentCardsState createState() => _RecentCardsState();
}

class _RecentCardsState extends State<RecentCards> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          PageHeader(title: "Resent Bookings.",),
          StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('token_data').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final tokenCardData = snapshot.data.docs;
                List<CardRecent> tokenCards = [];
                for (var card in tokenCardData) {
                  if (phoneNo == card.data()['mobileNumber']) {
                    final tokenCard = CardRecent(
                      departmenttext: card.data()['department'],
                      date: card.data()['date'],
                      hospitalname: card.data()['hospitalName'],
                      imagetext: departmentIcons[card.data()['department']],
                      timetext: card.data()['time'],
                    );
                    tokenCards.add(tokenCard);
                  }
                }
                return tokenCards.isNotEmpty
                    ? Expanded(
                        child: Container(
                          child: GridView.count(
                            shrinkWrap: true,
                            // reverse: true,
                            scrollDirection: Axis.vertical,
                            crossAxisCount: 1,
                            childAspectRatio: 1.5,
                            children: tokenCards,
                          ),
                        ),
                      )
                    : Container();
              }
              return Container();
            },
          )
        ],
      ),
    );
  }
}



class CardRecent extends StatelessWidget {
  final String departmenttext;
  final String timetext;
  final String date;
  final String hospitalname;
  final String imagetext;
  final String mobilenum;

  CardRecent({
    this.departmenttext,
    this.date,
    this.hospitalname,
    this.timetext,
    this.imagetext,
    this.mobilenum,
  });
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding:
            const EdgeInsets.only(right: 20, left: 20, top: 15, bottom: 15),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: kCardsColor,
                  borderRadius: BorderRadius.circular(10.0)),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Image.asset('images/$imagetext'),
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                departmenttext,
                                style: kNormalText.copyWith(
                                  color: kPrimaryColorBlue,
                                  fontSize: 30,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 8.0,
                                      ),
                                      child: Text(
                                        '${date}',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10.0,
                                    horizontal: 30.0,
                                  ),
                                  child: Text(
                                    '${timetext}',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  color: kPrimaryColorBlue,
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 30.0,
                        ),
                        child: Text(
                          '${hospitalname}',
                          style: TextStyle(color: Colors.black, fontSize: 20),
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
