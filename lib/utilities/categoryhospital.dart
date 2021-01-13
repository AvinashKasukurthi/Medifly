import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medifly/bookingscreen.dart';
import 'package:medifly/utilities/categories_data.dart';
import 'package:medifly/utilities/constants.dart';
import 'package:medifly/utilities/hospitalcard.dart';
import 'package:medifly/utilities/pageheader.dart';
import 'package:medifly/utilities/time_info.dart';
import 'package:provider/provider.dart';

class CategoryHospital extends StatelessWidget {
  final String category;
  CategoryHospital({
    @required this.category,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColorBlue,
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              PageHeader(title: '$category'),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('hospital_data')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final hospitalCardData = snapshot.data.docs;
                    List<HospitalCard> hospitalCards = [];

                    for (var card in hospitalCardData) {
                      final cardName = card.data()['name'];
                      final cardImage = card.data()['image'];
                      final cardHospitalCost = card.data()['cost'];
                      final cardlocation = card.data()['location'];
                      final cardDepartments = card.data()['categories'];
                      final cardTime = card.data()['Timedata'];
                      final hospitalCard = HospitalCard(
                        title: cardName,
                        location: cardlocation,
                        image: cardImage,
                        amount: cardHospitalCost,
                        departments: cardDepartments,
                        time: cardTime,
                        textHeight: 18,
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
                      if (hospitalCard.departments.contains(category))
                        hospitalCards.add(hospitalCard);
                    }
                    return hospitalCards.isNotEmpty
                        ? Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 8.0),
                              child: GridView.count(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                crossAxisCount: 1,
                                childAspectRatio: 1.25,
                                children: hospitalCards,
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
        ),
      ),
    );
  }
}
