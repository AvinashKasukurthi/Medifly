import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:medifly/utilities/bookingscreen.dart';
import 'package:medifly/utilities/categories_data.dart';
import 'package:medifly/utilities/hospitalcard.dart';
import 'package:medifly/utilities/time_info.dart';
import 'package:provider/provider.dart';

class HospitalPage extends StatelessWidget {
  static String id = 'HospitalPage';
  final String category;

  const HospitalPage({Key key, this.category}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Container(
                height: 100,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'images/background.jpg',
                      fit: BoxFit.cover,
                    ),
                    Container(
                      color: Colors.black45,
                      child: Center(
                        child: Text(
                          "$category.",
                          style:
                              TextStyle(color: Colors.white70, fontSize: 22.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('hospital_data')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final hospitalCardData = snapshot.data.docs;
                    List<HospitalCard> hospitalCards = [];
                    int totalHospitalCardsOnHome = 0;
                    for (var card in hospitalCardData) {
                      if (totalHospitalCardsOnHome > 49) {
                        break;
                      }

                      final cardName = card.data()['name'];
                      final cardImage = card.data()['image'];
                      final cardHospitalCost = card.data()['cost'];
                      final cardlocation = card.data()['location'];
                      final cardDepartments = card.data()['categories'];
                      final cardTime = card.data()['Timedata'];
                      final largeCard = HospitalCard(
                        title: cardName,
                        location: cardlocation,
                        image: cardImage,
                        amount: cardHospitalCost,
                        departments: cardDepartments,
                        textHeight: 20,
                        time: cardTime,
                        onPressed: () {
                          Provider.of<CategoryData>(context, listen: false)
                              .userOut();
                          Provider.of<SlotData>(context, listen: false)
                              .userOut();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookingScreen(
                                amount: cardHospitalCost,
                                image: cardImage,
                                hospitalName: cardName,
                                location: cardlocation,
                                departments: cardDepartments,
                                timeList: cardTime,
                              ),
                            ),
                          );
                        },
                      );
                      hospitalCards.add(largeCard);
                      totalHospitalCardsOnHome++;
                    }
                    return hospitalCards.isNotEmpty
                        ? Expanded(
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              child: GridView.count(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                crossAxisCount: 1,
                                childAspectRatio: 1.1,
                                children: hospitalCards,
                              ),
                            ),
                          )
                        : Container();
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
