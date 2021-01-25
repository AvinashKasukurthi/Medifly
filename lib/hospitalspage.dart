import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:medifly/models/hospital_card_details.dart';
import 'file:///E:/Projects/Medifly/lib/bookingscreen.dart';
import 'package:medifly/utilities/categories_data.dart';
import 'package:medifly/utilities/constants.dart';
import 'package:medifly/utilities/hospitalcard.dart';
import 'package:medifly/utilities/pageheader.dart';
import 'package:medifly/utilities/time_info.dart';
import 'package:provider/provider.dart';

class HospitalPage extends StatelessWidget {
  static String id = 'HospitalPage';
  final String category;

  const HospitalPage({Key key, this.category}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColorBlue,
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              PageHeader(title: this.category),
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
                      HospitalCardDetails cardDetailsFromHospitalPage =
                          HospitalCardDetails(
                        name: card.data()['name'],
                        imageUrl: card.data()['image'],
                        cost: card.data()['cost'],
                        location: card.data()['location'],
                        departments: card.data()['categories'],
                        time: card.data()['Timedata'],
                      );

                      final cardName =
                          cardDetailsFromHospitalPage.getHospitalCardItemName();
                      final cardImage = cardDetailsFromHospitalPage
                          .getHospitalCardItemImageUrl();
                      final cardHospitalCost =
                          cardDetailsFromHospitalPage.getHospitalCardItemCost();
                      final cardlocation = cardDetailsFromHospitalPage
                          .getHospitalCardItemLocation();
                      final cardDepartments = cardDetailsFromHospitalPage
                          .getHospitalCardItemDepartments();
                      final cardTime =
                          cardDetailsFromHospitalPage.getHospitalCardItemTime();
                      final largeCard = HospitalCard(
                        title: cardName,
                        location: cardlocation,
                        image: cardImage,
                        amount: cardHospitalCost,
                        departments: cardDepartments,
                        textHeight: 20,
                        time: cardTime,
                        onPressed: () {
                          statusUpdationAndRedirectTOBookingScreen(
                              context, cardDetailsFromHospitalPage);
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

  void statusUpdationAndRedirectTOBookingScreen(
      BuildContext context, HospitalCardDetails cardDetailsFromHospitalPage) {
    statusUpdationInProviderSlotDataAndCategoryData(context);
    redirectToBookingScreen(context, cardDetailsFromHospitalPage);
  }

  void statusUpdationInProviderSlotDataAndCategoryData(BuildContext context) {
    Provider.of<CategoryData>(context, listen: false).userOut();
    Provider.of<SlotData>(context, listen: false).userOut();
  }

  void redirectToBookingScreen(
      BuildContext context, HospitalCardDetails cardDetails) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingScreen(
          amount: cardDetails.getHospitalCardItemCost(),
          image: cardDetails.getHospitalCardItemImageUrl(),
          hospitalName: cardDetails.getHospitalCardItemName(),
          location: cardDetails.getHospitalCardItemLocation(),
          departments: cardDetails.getHospitalCardItemDepartments(),
          timeList: cardDetails.getHospitalCardItemTime(),
        ),
      ),
    );
  }
}
