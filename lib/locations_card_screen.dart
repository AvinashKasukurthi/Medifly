import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'file:///E:/Projects/Medifly/lib/bookingscreen.dart';
import 'package:medifly/utilities/categories_data.dart';
import 'package:medifly/utilities/constants.dart';
import 'package:medifly/utilities/hospitalcard.dart';
import 'package:medifly/utilities/pageheader.dart';
import 'package:provider/provider.dart';

class LocationCardScreen extends StatefulWidget {
  LocationCardScreen({this.location});
  final String location;

  @override
  _LocationCardScreenState createState() => _LocationCardScreenState();
}

class _LocationCardScreenState extends State<LocationCardScreen> {
  FirebaseFirestore firebaseInstance = FirebaseFirestore.instance;
  List<HospitalCard> hospitalCards = [];

  void getLocationData() async {
    var card;
    await for (var snapshots
        in firebaseInstance.collection('hospital_data').snapshots()) {
      for (var locationData in snapshots.docs) {
        if (widget.location == locationData.data()['location']) {
          card = HospitalCard(
            amount: locationData.data()['cost'],
            title: locationData.data()['name'],
            image: locationData.data()['image'],
            location: locationData.data()['location'],
            textHeight: 22,
            onPressed: () {
              Provider.of<CategoryData>(context, listen: false).userOut();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingScreen(
                    amount: locationData.data()['cost'],
                    image: locationData.data()['image'],
                    hospitalName: locationData.data()['name'],
                    location: locationData.data()['location'],
                    departments: locationData.data()['categories'],
                    timeList: locationData.data()['Timedata'],
                  ),
                ),
              );
            },
          );
          setState(() {
            print(hospitalCards.length);
            hospitalCards.add(card);
          });
        }
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocationData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColorBlue,
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              PageHeader(title: 'Hospitals at ${widget.location}'),
              hospitalCards.isNotEmpty
                  ? Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 8.0, right: 8.0),
                        child: GridView.count(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          crossAxisCount: 1,
                          childAspectRatio: 1.1,
                          children: hospitalCards,
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
