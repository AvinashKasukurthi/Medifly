import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medifly/utilities/categories_data.dart';
import 'package:medifly/utilities/constants.dart';
import 'package:medifly/utilities/department_icons.dart';
import 'package:medifly/utilities/pageheader.dart';
import 'package:provider/provider.dart';

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget({this.cardDepartments, Key key}) : super(key: key);
  final List cardDepartments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColorBlue,
      body: Container(
        child: ListView.builder(
          itemCount: cardDepartments.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: GestureDetector(
                onTap: () {
                  Provider.of<CategoryData>(context, listen: false)
                      .selectCategory(cardDepartments[index]);
                  Navigator.pop(context);
                },
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: kCardsColor,
                  ),
                  child: Center(
                    child: ListTile(
                      leading: Image.asset(
                          'images/${departmentIcons[cardDepartments[index]]}'),
                      title: Text(
                        cardDepartments[index],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class CategoryPage extends StatelessWidget {
  static String id = 'CategoryPage';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            PageHeader(title: "Categories"),
            // StreamBuilder<QuerySnapshot>(
            // stream:
            //     FirebaseFirestore.instance.collection('token_data').snapshots(),
            // builder: (context, snapshot) {
            //   if (snapshot.hasData) {
            //     final tokenCardData = snapshot.data.docs;
            //   List<CardRecent> tokenCards = [];

            //     for (var card in tokenCardData) {
            //       if (phoneNo == card.data()['mobileNumber']) {
            //         final tokenCard = CardRecent(
            //           departmenttext: card.data()['department'],
            //           date: card.data()['date'],
            //           hospitalname: card.data()['hospitalName'],
            //           imagetext: departmentIcons[card.data()['department']],
            //           timetext: card.data()['time'],
            //         );
            //         tokenCards.add(tokenCard);
            //       }
            //     }
            //     return tokenCards.isNotEmpty
            //         ? Expanded(
            //             child: Container(
            //               child: GridView.count(
            //                 shrinkWrap: true,
            //                 // reverse: true,
            //                 scrollDirection: Axis.vertical,
            //                 crossAxisCount: 1,
            //                 childAspectRatio: 1.5,
            //                 children: tokenCards,
            //               ),
            //             ),
            //           )
            //         : Container();
            //   }
            //   return Container();
            CategoryCard(),
          ],
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(25),
        ),
      ),
      child: Column(
        children: [
          Text('Heart'),
        ],
      ),
    );
  }
}
