import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medifly/main.dart';

import 'package:medifly/utilities/bookingscreen.dart';
import 'package:medifly/utilities/cards_data.dart';
import 'package:medifly/utilities/categories_data.dart';

import 'package:medifly/utilities/hospitalcard.dart';
import 'package:medifly/utilities/constants.dart';
import 'package:medifly/utilities/drawer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'utilities/appbar.dart';
import 'package:medifly/utilities/time_info.dart';

FirebaseFirestore hospitalRef = FirebaseFirestore.instance;
String drawername;

class HomeScreen extends StatefulWidget {
  static String id = 'HomeScreen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isSearching = false;
  FirebaseFirestore ref = FirebaseFirestore.instance;
  void updateProfile() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    phoneNo = preferences.getString('phoneNo');
    print(phoneNo);
    final snapShotDoc = ref.collection('profiles').doc('$phoneNo');
    DocumentSnapshot snapshot = await snapShotDoc.get();
    print('${snapshot.id} hello');
    if (snapshot == null || !snapshot.exists) {
      ref
          .collection('profiles')
          .doc('$phoneNo')
          .set({'username': '', 'email': '', 'phonenumber': '$phoneNo'});
    } else if (snapshot.exists) {
      setState(() {
        drawername = snapshot.data()['username'];
      });
      print(drawername);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateProfile();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawerpop(
        drawername: drawername,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              SearchBar(
                scaffoldKey: _scaffoldKey,
                color: kCardsColor,
                iconColor: kPrimaryColorBlue,
              ),
              Container(
                child: AppComponents(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppComponents extends StatefulWidget {
  const AppComponents({
    Key key,
  }) : super(key: key);

  @override
  _AppComponentsState createState() => _AppComponentsState();
}

class _AppComponentsState extends State<AppComponents> {
  List<CardData> hospitalCards = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // listTest();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
          AdvertaismentContent(),
          SizedBox(height: 12.0),
          SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              'Popular Hospitals',
              style: kMainText,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18),
            child: Text(
              'Here are the popular results',
              style: kSubText,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            // height: 300,
            child: Column(
              children: [
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
                        if (totalHospitalCardsOnHome > 4) {
                          break;
                        }

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
                        hospitalCards.add(hospitalCard);
                        totalHospitalCardsOnHome++;
                      }
                      return hospitalCards.isNotEmpty
                          ? Container(
                              padding: EdgeInsets.only(left: 8.0),
                              height: 180,
                              child: GridView.count(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                crossAxisCount: 1,
                                childAspectRatio: 0.85,
                                children: hospitalCards,
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
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}

class DepartmentItems extends StatelessWidget {
  DepartmentItems({this.image, this.title});

  final Widget image;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(right: 15.0, left: 15.0, top: 30.0),
                child: image,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w300),
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: kPrimaryColorBlue,
          ),
          width: 150,
        ),
      ),
    );
  }
}

class AdvertaismentContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: FlatButton(
        onPressed: () {
          print('pressed');
        },
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        flex: 6,
                        child: Image.asset(
                          'images/AdLogo.png',
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          elevation: 0,
                          onPressed: () {},
                          color: kRedButton.withOpacity(0.85),
                          child: Text(
                            'Book Now',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Medifly',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30.0,
                          fontWeight: FontWeight.w300),
                    ),
                    Text(
                      '"Being part of your Health."',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white54, fontWeight: FontWeight.w300),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Text(
                        'Get Doctor Cosultations within seconds and have your own time.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.grey,
                  blurRadius: 15,
                  offset: Offset(0, 4),
                  spreadRadius: 1.0)
            ],
            borderRadius: BorderRadius.circular(24),
            color: kPrimaryColorBlue,
          ),
        ),
      ),
    );
  }
}
